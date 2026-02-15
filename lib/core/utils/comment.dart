import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/model/comment.dart';
import '../../data/model/feeditem_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/pages/article_pages/comment_controller.dart';
import '../network/comment.dart';

Future<void> showPostCommentDialog({Comment? parentComment}) async {
  String content = '';
  final context = Get.context!;
  final commentController = Get.find<CommentController>();
  final feedItemController = Get.find<FeedItemController>();
  await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                autofocus: true,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onChanged: (value) {
                  content = value;
                },
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: parentComment == null
                      ? feedItemController.currentArticle.value!.authorName == null
                        ? AppLocalizations.of(context)!.commentHint
                        : AppLocalizations.of(context)!.replyTo(feedItemController.currentArticle.value!.authorName!)
                      : parentComment.parentUserName == null
                        ? AppLocalizations.of(context)!.commentHint
                        : AppLocalizations.of(context)!.replyTo(parentComment.parentUserName!)
                  ,
                  // border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 4,),
              SizedBox(
                height: 40,
                child: Obx(() {
                  if (commentController.isSubmitting.value) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  }
                  else {
                    return ElevatedButton(
                        onPressed: () async {
                          if (content.isEmpty) {
                            Fluttertoast.showToast(msg: '评论不能为空！');
                            return;
                          }
                          try {
                            commentController.isSubmitting.value = true;
                            final newComment = await createComment(
                                articleID: feedItemController.currentArticle
                                    .value!.id,
                                parentID: parentComment?.id,
                                userID: Supabase.instance.client.auth.currentUser!
                                    .id,
                                content: content
                            );
                            commentController.isSubmitting.value = false;
                            if (parentComment == null) {
                              commentController.comments.add(newComment);
                            }
                            else {
                              // print(newComment.toJson());
                              commentController.addReply(
                                  parent: parentComment,
                                  reply: newComment
                              );
                            }

                            Fluttertoast.showToast(msg: AppLocalizations.of(
                                context)!.commentPostedToast);
                            Get.back();
                          } catch (e) {
                            commentController.isSubmitting.value = false;
                            // todo: 修改为更友好的错误提示
                            Fluttertoast.showToast(msg: e.toString());
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                          foregroundColor: WidgetStateProperty.all(Colors.white),
                          padding: WidgetStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 24, vertical: 12)),

                        ),
                        child: Text(AppLocalizations.of(context)!.post)
                    );
                  }
                }),
              )
            ],
          ),
        );
      }
  );
}