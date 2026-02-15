import 'package:get/get.dart';
import 'package:go_deeper/core/network/comment.dart';
import 'package:go_deeper/data/model/comment.dart';

class CommentController extends GetxController {
  // 所有评论，包括子评论
  final RxList<Comment> _allComments = <Comment>[].obs;

  // 顶级评论
  final RxList<Comment> comments = <Comment>[].obs;

  Rx<Comment?> currentComment = Rx<Comment?>(null);

  var isLoading = false.obs;
  var isSubmitting = false.obs;

  int articleID;

  CommentController({required this.articleID});

  @override
  void onInit() {
    super.onInit();
    loadComments();
  }

  Future<void> loadComments() async {
    isLoading.value = true;
    if (articleID <= 0) {
      comments.clear();
      isLoading.value = false;
      return;
    }
    _allComments.value = await getComments(articleID: articleID);
    comments.assignAll(_buildCommentTree(_allComments));
    isLoading.value = false;
  }

  List<Comment> _buildCommentTree(List<Comment> flatComments) {
    final Map<int, Comment> commentMap = {
      for (var c in flatComments) c.id: c
    };

    final List<Comment> roots = [];

    // 清空所有评论的 replies
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

    // 先找出所有顶层评论
    for (var c in flatComments) {
      if (c.parentId == null) {
        roots.add(c);
      }
    }

    // 将所有非顶层评论归属到对应的顶层评论
    for (var c in flatComments) {
      if (c.parentId != null) {
        final root = findRootComment(c);
        if (root != null) {
          root.replies.add(c);
        } else {
          // 如果找不到顶层评论（可能被删了），作为顶级评论显示
          roots.add(c);
        }
      }
    }

    for (var c in _allComments) {
      if (c.parentId == null) {
        continue;
      }
      final parent = commentMap[c.parentId];
      if (parent != null) {
        c.parentUserName = parent.userName;
      }
    }

    return roots;
  }
}