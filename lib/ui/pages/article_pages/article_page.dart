import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/data/model/comment.dart';
import 'package:go_deeper/data/model/feeditem.dart';
import 'package:go_deeper/data/model/feeditem_controller.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/article_pages/comment_controller.dart';
import 'package:go_deeper/ui/pages/article_pages/edit_article_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArticlePage extends StatelessWidget {

  final ArticleFeed article;

  ArticlePage({super.key, required this.article});



  @override
  Widget build(BuildContext context) {
    final CommentController commentController = Get.put(CommentController());
    // print(article.toJson());
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          _popupMenuButton()
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            if (article.summary.isNotEmpty) ...[
              Text(
                article.summary,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
            ],
            if (article.authorName != null && article.authorName!.isNotEmpty) ...[
              Text(
                'By ${article.authorName}',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
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
              article.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            Divider(

            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            
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
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            final feedController = Get.find<FeedItemController>();
            feedController.isEditingArticle.value = true;
            feedController.editingArticle = article;
            Get.off(() => EditArticlePage());
            break;
          case 'delete':
            _showDeleteDialog();
            break;
        }
      },
        itemBuilder: (context) => [
          if (article.author == Supabase.instance.client.auth.currentUser!.id) ...[
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
                  await deleteArticle(articleID: article.id);
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

  Future<void> _showPostCommentDialog(Comment? parentComment) async {
    final context = Get.context!;
    final l10n = AppLocalizations.of(context)!;
    String commentContent = '';
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              parentComment == null ? l10n.postCommentTo(article.authorName ?? '') : l10n.replyTo(parentComment.userName)
            ),
            content: TextField(
              onChanged: (value) {
                commentContent = value;
              },
              maxLines: 5,
              decoration: InputDecoration(
                hintText: l10n.commentHint,
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(onPressed: () {
                Get.back();
              }, child: Text(l10n.cancel)),
              TextButton(onPressed: () {

              }, child: Text(l10n.post))
            ],
          );
        }
    );
  }
}