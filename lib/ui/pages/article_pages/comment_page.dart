import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/ui/pages/article_pages/comment_controller.dart';
import 'package:go_deeper/ui/widgets/comment_tile.dart';


// 展示评论及其回复的页面
class CommentPage extends GetView<CommentController> {

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
      child: Obx(() => controller.isLoading.value
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
          itemCount: controller.currentComment.value!.replies.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // 展示评论内容
              return CommentTile(
                  comment: controller.currentComment.value!,
                  isTopLevelComment: false,
                  showTrailingButton: false
              );
            } else {
              // 展示回复内容
              final reply = controller.currentComment.value!.replies[index - 1];
              return CommentTile(
                  comment: reply,
                  isTopLevelComment: false,
                  showTrailingButton: false
              );
            }
          }
      )
      ),
    );
  }
}