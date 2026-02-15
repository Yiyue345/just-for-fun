import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/data/model/comment.dart';
import 'package:go_deeper/ui/pages/article_pages/comment_controller.dart';

import '../pages/article_pages/comment_page.dart';

class CommentTile extends StatelessWidget {

  final Comment comment;
  final bool showTrailingButton;
  final bool isTopLevelComment;
  final Future<void> Function()? onReply;

  CommentTile({
    required this.comment,
    this.showTrailingButton = true,
    required this.isTopLevelComment,
    this.onReply
  });

  @override
  Widget build(BuildContext context) {
    final commentController = Get.find<CommentController>();
    return InkWell(
      onTap: () async {
        if (!isTopLevelComment) {
          // 回复逻辑
          if (onReply != null) await onReply!();
          return;
        }
        if (comment.replies.isNotEmpty) {
          commentController.currentComment.value = comment;
          showModalBottomSheet(
              context: context,
              // 解放尺寸
              isScrollControlled: true,
              builder: (context) {
                return FractionallySizedBox(
                  heightFactor: 0.8,
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: CommentPage(),
                  ),
                );
              }
          );
        }
        else {
          // 回复逻辑
          if (onReply != null) await onReply!();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider(height: 0,),
          ListTile(
            title: Row(
              children: [
                Text(comment.userName),
                SizedBox(width: 8,),
                if (comment.parentUserName != null) GestureDetector(
                  onTap: () {
                    // 点击跳转到被回复用户的主页
                  },
                  child: Text(
                    'Replying to @${comment.parentUserName}',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
            subtitle: Text(comment.content),
            trailing: showTrailingButton ? IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.chat_bubble_outline)
            )
            : null,
            contentPadding: EdgeInsets.only(left: 16, right: 12, top: 4),
          ),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Row(
              children: [
                Text(comment.createdAt.toLocal().toString())
              ],
            ),
          ),
          Divider(height: 0,)
        ],
      ),
    );
  }
}