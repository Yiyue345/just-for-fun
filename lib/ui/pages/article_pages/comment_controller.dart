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

    for (var c in flatComments) {
      c.replies = [];
    }

    for (var c in flatComments) {
      if (c.parentId == null) {
        // 如果没有父ID，则是顶级评论
        roots.add(c);
      } else {
        // 如果有父ID，找到父评论并加入其 replies 列表
        final parent = commentMap[c.parentId];
        if (parent != null) {
          parent.replies.add(c);
        } else {
          // 如果找不到父评论（可能被删了），可以选择作为顶级评论显示或丢弃
          roots.add(c);
        }
      }
    }
    return roots;
  }
}