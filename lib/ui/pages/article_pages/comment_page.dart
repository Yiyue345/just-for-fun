import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/ui/pages/article_pages/comment_controller.dart';


// 展示评论及其回复的页面
class CommentPage extends GetView<CommentController> {

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: controller.currentComment.value!.replies.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // 展示评论内容
            return ListTile(
              title: Text(controller.currentComment.value!.content),
              subtitle: Text('By ${controller.currentComment.value!.userName}'),
            );
          } else {
            // 展示回复内容
            final reply = controller.currentComment.value!.replies[index - 1];
            return ListTile(
              title: Text(reply.content),
              subtitle: Text('By ${reply.userName}'),
            );
          }
        }
    );
  }
}