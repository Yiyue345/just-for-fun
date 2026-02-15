import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/core/network/comment.dart';
import 'package:go_deeper/data/model/comment.dart';
import 'package:go_deeper/data/model/feeditem.dart';
import 'package:go_deeper/data/model/feeditem_controller.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/article_pages/comment_controller.dart';
import 'package:go_deeper/ui/pages/article_pages/edit_article_page.dart';
import 'package:go_deeper/ui/pages/other_user_page/controller.dart';
import 'package:go_deeper/ui/pages/other_user_page/other_user_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/comment_tile.dart';

class ArticlePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final feedItemController = Get.find<FeedItemController>();
    final CommentController commentController = Get.put(CommentController(articleID: feedItemController.currentArticle.value!.id));
    commentController.articleID = feedItemController.currentArticle.value!.id;
    commentController.loadComments();
    feedItemController.reloadCurrentArticle();
    // print(article.toJson());
    return Scaffold(
      appBar: AppBar(
        title: Text(feedItemController.currentArticle.value!.title),
        actions: [
          _popupMenuButton()
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            final futures = [
              commentController.loadComments(),
              feedItemController.reloadCurrentArticle()
            ];
            await Future.wait(futures);
            // await commentController.loadComments();
            // await feedItemController.reloadCurrentArticle();
          },
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Obx(() => ListView(
          children: [
            if (feedItemController.currentArticle.value!.summary.isNotEmpty) ...[
              Text(
                feedItemController.currentArticle.value!.summary,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
            ],
            if (feedItemController.currentArticle.value!.authorName != null && feedItemController.currentArticle.value!.authorName!.isNotEmpty) ...[
              GestureDetector(
                  onTap: () {
                    final otherUsersController = Get.find<OtherUsersController>();
                    otherUsersController.updateWatchUserProfile(feedItemController.currentArticle.value!.author);
                    Get.to(OtherUserPage());
                  },
                  child: Text.rich(
                      TextSpan(
                          text: 'By ',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                          children: [
                            TextSpan(
                              text: feedItemController.currentArticle.value!.authorName,
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            )
                          ]
                      )
                  )

                // Text(
                //   'By ${feedItemController.currentArticle.value!.authorName}',
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontStyle: FontStyle.italic,
                //     color: Colors.grey[600],
                //   ),
                // ),
              ),
            ]
            else ...[
              Text(
                  'by Unknown Author',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ))
            ],
            SizedBox(height: 16),
            Text(
              feedItemController.currentArticle.value!.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            Divider(
              height: 16,
            ),

            if (commentController.isLoading.value)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (commentController.comments.isNotEmpty) ...[
              Text(
                AppLocalizations.of(context)!.comments,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final comment = commentController.comments[index];
                  return CommentTile(
                    comment: comment,
                    isTopLevelComment: true,
                    showTrailingButton: false,
                  );
                },
                itemCount: commentController.comments.length,
              )
            ]
            else ...[
                Text(
                  AppLocalizations.of(context)!.noComments,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                )
              ]
          ],
        )),
      )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _showPostCommentDialog();
          },
        shape: CircleBorder(),
        child: Icon(Icons.add_comment),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _showPostCommentDialog({Comment? parentComment}) async {
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
                    hintText: AppLocalizations.of(context)!.commentHint,
                    // border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 4,),
                if (commentController.isSubmitting.value)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          commentController.isSubmitting.value = true;
                          final newComment = await createComment(
                              articleID: feedItemController.currentArticle.value!.id,
                              parentID: parentComment?.id,
                              userID: Supabase.instance.client.auth.currentUser!.id,
                              content: content
                          );
                          commentController.isSubmitting.value = false;
                          commentController.comments.add(newComment);
                          Fluttertoast.showToast(msg: AppLocalizations.of(context)!.commentPostedToast);
                          Get.back();
                        } catch(e) {
                          commentController.isSubmitting.value = false;
                          // todo: 修改为更友好的错误提示
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 12)),

                      ),
                      child: Text(AppLocalizations.of(context)!.post)
                  )
              ],
            ),
          );
        }
    );
  }
  
  PopupMenuButton<String> _popupMenuButton() {
    final context = Get.context!;
    final l10n = AppLocalizations.of(context)!;
    final feedItemController = Get.find<FeedItemController>();
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            final feedController = Get.find<FeedItemController>();
            feedController.isEditingArticle.value = true;
            feedController.editingArticle = feedItemController.currentArticle.value!;
            Get.off(() => EditArticlePage());
            break;
          case 'delete':
            _showDeleteDialog();
            break;
        }
      },
        itemBuilder: (context) => [
          if (feedItemController.currentArticle.value!.author == Supabase.instance.client.auth.currentUser!.id) ...[
            PopupMenuItem(
              value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(l10n.edit),
                  ],
                ),
            ),
            PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text(l10n.delete, style: TextStyle(color: Colors.red)),
                  ],
                )
            )
          ]

        ]
    );
  }

  Future<void> _showDeleteDialog() async {
    final context = Get.context!;
    final l10n = AppLocalizations.of(context)!;
    final feedItemController = Get.find<FeedItemController>();
    var article = feedItemController.currentArticle.value!;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.deleteArticleTitle),
          content: Text(l10n.deleteArticleMessage),
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: Text(l10n.cancel)
            ),
            TextButton(
                onPressed: () async {
                  await deleteArticle(articleID: feedItemController.currentArticle.value!.id);
                  final feedController = Get.find<FeedItemController>();
                  feedController.feedItems.remove(article);
                  Fluttertoast.showToast(msg: 'Deleted article successfully.');
                  Get.back();
                  Get.back();
                },
                child: Text(l10n.delete, style: TextStyle(color: Colors.red))
            )
          ],
        )
    );
  }

  // Future<void> _showPostCommentDialog(Comment? parentComment) async {
  //   final context = Get.context!;
  //   final l10n = AppLocalizations.of(context)!;
  //   String commentContent = '';
  //   showDialog(
  //     barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(
  //             parentComment == null ? l10n.postCommentTo(article.authorName ?? '') : l10n.replyTo(parentComment.userName)
  //           ),
  //           content: TextField(
  //             onChanged: (value) {
  //               commentContent = value;
  //             },
  //             maxLines: 5,
  //             decoration: InputDecoration(
  //               hintText: l10n.commentHint,
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           actions: [
  //             TextButton(onPressed: () {
  //               Get.back();
  //             }, child: Text(l10n.cancel)),
  //             TextButton(onPressed: () {
  //
  //             }, child: Text(l10n.post))
  //           ],
  //         );
  //       }
  //   );
  // }
}