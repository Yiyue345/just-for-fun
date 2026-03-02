import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/core/network/comment.dart';
import 'package:go_deeper/core/utils/comment.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:go_deeper/data/model/comment.dart';
import 'package:go_deeper/data/model/feeditem.dart';
import 'package:go_deeper/data/model/feeditem_controller.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/article_pages/article_controller.dart';
import 'package:go_deeper/ui/pages/article_pages/edit_article_page.dart';
import 'package:go_deeper/ui/pages/other_user_page/controller.dart';
import 'package:go_deeper/ui/pages/other_user_page/other_user_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/comment_tile.dart';

class ArticlePage extends StatelessWidget {

  final int articleID;
  ArticlePage({required this.articleID});

  @override
  Widget build(BuildContext context) {
    final ArticleController articleController = Get.find<ArticleController>(tag: articleID.toString());
    // commentController.loadComments();
    // feedItemController.reloadCurrentArticle();
    // print(article.toJson());
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(articleController.article.value?.title ?? '')),
        actions: [
          _popupMenuButton()
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            final futures = [
              articleController.loadComments(),
              articleController.loadArticle(articleID: articleID)
            ];
            await Future.wait(futures);
          },
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Obx(() => articleController.isLoading.value 
            ? Center(
          child: CircularProgressIndicator(),
        )
            : articleController.article.value == null 
              ? Center(
          child: TextButton(onPressed: () {
            articleController.refresh();
          }, 
              child: Text(AppLocalizations.of(context)!.loadArticleFailedRetry)
          ),
        )
              : ListView(
          children: [
            if (articleController.article.value!.summary.isNotEmpty) ...[
              Text(
                articleController.article.value!.summary,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
            ],
            if (articleController.article.value!.authorName != null && articleController.article.value!.authorName!.isNotEmpty) ...[
              GestureDetector(
                  onTap: () {
                    goToOtherUserPage(userUUID: articleController.article.value!.author);
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
                              text: articleController.article.value!.authorName,
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
              articleController.article.value!.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            Divider(
              height: 16,
            ),

            if (articleController.isLoading.value)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (articleController.comments.isNotEmpty) ...[
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
                  final comment = articleController.comments[index];
                  return CommentTile(
                    comment: comment,
                    isTopLevelComment: true,
                    showTrailingButton: false,
                    onReply: () async {
                      await showPostCommentDialog(articleID: articleID, parentComment: comment);
                    },
                  );
                },
                itemCount: articleController.comments.length,
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
        )
        ),
      )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showPostCommentDialog(articleID: articleID);
          },
        shape: CircleBorder(),
        child: Icon(Icons.add_comment),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  
  PopupMenuButton<String> _popupMenuButton() {
    final context = Get.context!;
    final l10n = AppLocalizations.of(context)!;
    final articleController = Get.find<ArticleController>(tag: articleID.toString());
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            final feedController = Get.find<FeedItemController>();
            feedController.isEditingArticle.value = true;
            feedController.editingArticle = articleController.article.value!;
            Get.off(() => EditArticlePage());
            break;
          case 'delete':
            _showDeleteDialog();
            break;
        }
      },
        itemBuilder: (context) => [
          if (articleController.article.value!.author == Supabase.instance.client.auth.currentUser!.id) ...[
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
    final articleController = Get.find<ArticleController>(tag: articleID.toString());
    var article = articleController.article.value!;
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
                  await deleteArticle(articleID: articleController.article.value!.id);
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
  
}