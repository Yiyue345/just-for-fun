import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:go_deeper/data/model/comment.dart';
import 'package:go_deeper/ui/pages/article_pages/article_controller.dart';

import '../../l10n/app_localizations.dart';
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
    final articleController = Get.find<ArticleController>(tag: comment.articleId.toString());
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () async {
        if (!isTopLevelComment) {
          // 回复逻辑
          if (onReply != null) await onReply!();
          return;
        }
        if (comment.replies.isNotEmpty) {
          articleController.currentComment.value = comment;
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
                    child: CommentPage(articleID: comment.articleId,),
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
                GestureDetector(
                  onTap: () {
                    goToOtherUserPage(userUUID: comment.userId);
                  },
                  child: Text(
                       comment.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                if (comment.parentUserName != null) GestureDetector(
                  onTap: () {
                    goToOtherUserPage(userUUID: comment.userId);
                  },
                  child: Text(
                    l10n.replyTo(comment.parentUserName!),
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