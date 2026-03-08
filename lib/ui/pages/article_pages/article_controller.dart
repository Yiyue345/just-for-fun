import 'package:get/get.dart';
import 'package:go_deeper/core/network/comment.dart';
import 'package:go_deeper/data/model/comment.dart';

import '../../../core/network/article.dart';
import '../../../data/model/feeditem.dart';

class ArticleController extends GetxController {
  Rx<ArticleFeed?> article = Rx<ArticleFeed?>(null);
  // 所有评论，包括子评论
  final RxList<Comment> allComments = <Comment>[].obs;

  // 顶级评论
  final RxList<Comment> comments = <Comment>[].obs;

  Rx<Comment?> currentComment = Rx<Comment?>(null);

  var isLoading = false.obs;
  var isSubmitting = false.obs;

  final renderMarkdown = true.obs;

  int articleID;

  ArticleController({required this.articleID});

  @override
  void onInit() {
    super.onInit();
    loadArticleAndComments(articleID: articleID);
  }

  @override
  void refresh() {
    super.refresh();
    loadArticleAndComments(articleID: articleID);
  }

  Future<void> loadArticleAndComments({required int articleID}) async {
    isLoading.value = true;
    await Future.wait([
      loadArticle(articleID: articleID),
      loadComments(),
    ]);
    isLoading.value = false;
  }

  Future<void> loadArticle({required int articleID}) async {
    final updatedArticle = await getArticleByID(articleID: articleID);
    if (updatedArticle != null) {
      article.value = updatedArticle;
    }
  }


  Future<void> loadComments() async {
    if (articleID <= 0) {
      comments.clear();
      isLoading.value = false;
      return;
    }
    allComments.value = await getComments(articleID: articleID);
    comments.assignAll(_buildCommentTree(allComments));
    comments.refresh();
  }

  List<Comment> _buildCommentTree(List<Comment> flatComments) {
    // 1. 建立 ID 到 Comment 的映射
    final Map<int, Comment> commentMap = {
      for (var c in flatComments) c.id: c
    };

    final List<Comment> roots = [];

    // 2. 清空遗留的 replies
    for (var c in flatComments) {
      c.replies = [];
    }

    // 辅助函数：递归查找顶层评论
    Comment? findRootComment(Comment comment) {
      if (comment.parentId == null) {
        return comment;
      }
      final parent = commentMap[comment.parentId];
      if (parent == null) {
        return null;
      }
      return findRootComment(parent);
    }

    // 3. 构建树
    for (var c in flatComments) {
      if (c.parentId == null) {
        // 肯定是根评论
        roots.add(c);
      } else {
        // 是回复
        final root = findRootComment(c);
        if (root != null) {
          root.replies.add(c);
        }
        // else:
        // 这是一个孤儿评论（有父ID但在当前列表中找不到祖先）。
        // 绝对不要把它加入 roots，否则它会错误地出现在文章页的主列表中。
      }
    }

    // 4. 设置 parentUserName (保持你原有的逻辑)
    for (var c in flatComments) { // 注意：遍历 flatComments 比 allComments 安全
      if (c.parentId != null) {
        final parent = commentMap[c.parentId];
        if (parent != null) {
          c.parentUserName = parent.userName;
        }
      }
    }

    return roots;
  }


  void addReply({
    required Comment parent,
    required Comment reply,
  }) {
    // 1. 设置 UI 显示用的 parentUserName
    reply.parentUserName = parent.userName;
    allComments.add(reply);

    // 2. 寻找根评论 ID (Root ID)
    // 简化版寻找 Root 逻辑
    int rootID = parent.id;
    if (parent.parentId != null) {
      // 如果 parent 有 parentId，说明它不是根，我们要向上找
      // 这里只是简单的 fallback，实际应该递归查找，或者根据你的数据结构
      // 如果你的树只有两层（root -> replies），那么 parent.parentId 就是 rootID
      // 如果 parent 是顶级评论，replies 为空，那么 rootID 就是 parent.id

      // 尝试在 comments 列表(顶级列表)里找
      var isRoot = comments.any((c) => c.id == parent.id);
      if (!isRoot) {
        // parent 是子评论
        // 假设你现在的 parentId 指向的就是顶级评论（两层结构）或者能追溯到
        // 此处简化逻辑：如果在 allComments 能找到链条最好，防止 crash 我们简单处理
        rootID = parent.parentId!;
      }
    }

    // 更稳健的查找 root 逻辑 (结合你之前的 while)
    Comment? currentObj = parent;
    while(currentObj?.parentId != null) {
      currentObj = allComments.firstWhereOrNull((c) => c.id == currentObj!.parentId);
    }
    if (currentObj != null) {
      rootID = currentObj.id;
    }


    // 3. 将回复添加到对应的顶级评论对象中
    // 'comments' 是 ArticlePage 展示的顶级评论列表
    var rootComment = comments.firstWhereOrNull((c) => c.id == rootID);

    if (rootComment != null) {
      rootComment.replies.add(reply);

      // *** 关键修复 1 ***
      // 在 Dart 中，修改 List 内部对象的属性（如 replies.add）不会自动触发 Obx 更新
      // 必须手动通知更新。

      // 通知 comments 列表更新 (ArticlePage UI 刷新)
      comments.refresh();

      // *** 关键修复 2 ***
      // 如果当前正在查看这个评论的详情 (CommentPage)，或者是刚刚把这个评论设为 current
      // 必须更新 currentComment，否则 CommentPage 也就是详情页看不到新回复
      if (currentComment.value == null || currentComment.value!.id == rootID) {
        // 如果 currentComment 还没设置（比如在 ArticlePage 直接回复），设为它
        currentComment.value = rootComment;
      }
      // 强制刷新 currentComment (CommentPage UI 刷新)
      currentComment.refresh();

    } else {
      // 没找到根，可能需要重新拉取数据
      loadComments();
    }
  }



}