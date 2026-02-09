import 'package:get/get.dart';
import 'package:go_deeper/data/model/comment.dart';

class CommentController extends GetxController {
  // 所有评论，包括子评论
  final RxList<Comment> _allComments = <Comment>[].obs;

  // 顶级评论
  final RxList<Comment> comments = <Comment>[].obs;

  Rx<Comment?> currentComment = Rx<Comment?>(null);

  void loadComments() async {
    comments.assignAll(_buildCommentTree(_allComments));
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

    return roots;
  }
}