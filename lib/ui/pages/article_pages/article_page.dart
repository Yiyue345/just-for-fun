import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/core/utils/comment_utils.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:go_deeper/data/model/feeditem_controller.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/article_pages/article_controller.dart';
import 'package:go_deeper/ui/pages/agent_page/agent_chat_page.dart';
import 'package:go_deeper/ui/pages/agent_page/agent_controller.dart';
import 'package:go_deeper/ui/pages/article_pages/edit_article_page.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/repository/article_repository.dart';
import '../../widgets/comment_tile.dart';

class ArticlePage extends StatelessWidget {

  final int articleID;
  ArticlePage({required this.articleID});

  @override
  Widget build(BuildContext context) {
    final ArticleController articleController = Get.find<ArticleController>(tag: articleID.toString());
    final agentTag = 'agent_article_$articleID';
    final AgentController agentController = Get.find<AgentController>(tag: agentTag);
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(articleController.article.value?.title ?? '')),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () {
              _showAgentSheet(context, agentController, agentTag);
            },
          ),
          Obx(() => articleController.renderMarkdown.value
              ? IconButton(onPressed: () {
                articleController.renderMarkdown.value = false;
          },
              icon: Icon(Icons.code)
          )
              : IconButton(onPressed: () {
                articleController.renderMarkdown.value = true;
          },
              icon: Icon(Icons.visibility)
          )
          ),
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
            if (articleController.renderMarkdown.value)
              MarkdownBlock(
                config: MarkdownConfig(

                ),
                  data: articleController.article.value!.content
              )
            else
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

  
  void _showAgentSheet(BuildContext context, AgentController agentController, String agentTag) {
    // 更新页面上下文
    final articleController = Get.find<ArticleController>(tag: articleID.toString());
    final article = articleController.article.value;
    if (article != null) {
      agentController.setPageContext(
        '当前正在查看文章（ID: ${article.id}）\n'
        '标题: ${article.title}\n'
        '摘要: ${article.summary}\n'
        '正文: ${article.content}\n'
        '当前评论链：${articleController.currentCommentChain.map((c) => '【${c.userName}】说：${c.content}').join('\n')}',
      );
    }

    // 设置评论填充回调：将 agent 草稿评论通过 toast 提示用户
    agentController.onFillComment = (commentContent) {
      // 关闭 agent sheet，然后打开评论对话框并预填
      Get.back(); // 关闭 ModalBottomSheet
      _showPrefilledCommentDialog(commentContent);
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: AgentChatPage(controllerTag: agentTag),
        );
      },
    );
  }



  /// 打开预填内容的评论对话框
  void _showPrefilledCommentDialog(String prefillContent) {
    showPostCommentDialog(articleID: articleID, initialContent: prefillContent);
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
                  final repository = Get.find<ArticleRepositoryImpl>();
                  await repository.deleteArticle(articleID: articleController.article.value!.id);
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