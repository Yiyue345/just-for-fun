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

        }
    );
  }
}