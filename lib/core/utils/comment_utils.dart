import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/data/repository/article_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/model/comment.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/pages/agent_page/agent_chat_page.dart';
import '../../ui/pages/agent_page/agent_controller.dart';
import '../../ui/pages/article_pages/article_controller.dart';
import '../network/comment.dart';

Future<void> showPostCommentDialog({
  required int articleID,
  Comment? parentComment,
  String? initialContent
}) async {
  final agentController = Get.find<AgentController>(tag: 'agent_article_$articleID');
  final context = Get.context!;
  final l10n = AppLocalizations.of(context)!;
  final agentTag = 'agent_article_$articleID';

  void showAgentSheet() {
    // 更新页面上下文
    final articleController = Get.find<ArticleController>(tag: articleID.toString());
    final article = articleController.article.value;
    if (parentComment != null) {
      articleController.currentCommentChain = articleController.getCommentWithAncestors(parentComment);
    }
    else {
      articleController.currentCommentChain = [];
    }

    if (article != null) {
      final commentChain = articleController.currentCommentChain
          .map((c) => l10n.agentContextCommentEntry(c.userName, c.content))
          .join('\n');
      agentController.setPageContext(
        '${l10n.agentContextCurrentArticle(article.id.toString())}\n'
        '${l10n.agentContextTitleLine(article.title)}\n'
        '${l10n.agentContextSummaryLine(article.summary)}\n'
        '${l10n.agentContextContentLine(article.content)}\n'
        '${l10n.agentContextCommentChainLine(commentChain)}',
      );
    }

    // debugPrint('当前评论链：${articleController.currentCommentChain.map((c) => '【${c.userName}】说：${c.content}').join('\n')}');

    void showPrefilledCommentDialog(String prefillContent, Comment? parentComment) {
      showPostCommentDialog(articleID: articleID, initialContent: prefillContent, parentComment: parentComment);
    }

    // 设置评论填充回调：将 agent 草稿评论通过 toast 提示用户
    agentController.onFillComment = (commentContent) {
      // 关闭 agent sheet，然后打开评论对话框并预填
      Get.back(); // 关闭 ModalBottomSheet
      showPrefilledCommentDialog(commentContent, parentComment);
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

  String content = initialContent ?? '';
  final articleController = Get.find<ArticleController>(tag: articleID.toString());
  final textController = TextEditingController(text: initialContent);
  final repository = Get.find<ArticleRepositoryImpl>();
  await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: textController,
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
                      ? articleController.article.value!.authorName == null
                        ? AppLocalizations.of(context)!.commentHint
                        : AppLocalizations.of(context)!.replyingTo(articleController.article.value!.authorName!)
                      : parentComment.parentUserName == null
                        ? AppLocalizations.of(context)!.commentHint
                        : AppLocalizations.of(context)!.replyingTo(parentComment.parentUserName!)
                  ,
                  // border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 4,),
              SizedBox(
                height: 40,
                child: Obx(() {
                  if (articleController.isSubmitting.value) {
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
                    return Row(
                      mainAxisAlignment:  MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Future.delayed(const Duration(milliseconds: 350), () {
                                showAgentSheet();
                              });
                            },
                            icon: Icon(Icons.auto_awesome)
                        ),
                        // TODO: 把按钮改得好看一点
                        ElevatedButton(
                            onPressed: () async {
                              if (content.isEmpty) {
                                Fluttertoast.showToast(msg: l10n.commentCannotBeEmpty);
                                return;
                              }
                              try {
                                articleController.isSubmitting.value = true;
                                final newComment = await repository.createComment(
                                    articleID: articleController.article.value!.id,
                                    userID: Supabase.instance.client.auth.currentUser!.id,
                                    content: content,
                                    parentID: parentComment?.id
                                );
                                // print('New comment created: ${newComment.toJson()}');
                                articleController.isSubmitting.value = false;
                                if (parentComment == null) {
                                  articleController.comments.add(newComment);
                                }
                                else {
                                  // print(newComment.toJson());
                                  articleController.addReply(
                                      parent: parentComment,
                                      reply: newComment
                                  );
                                }

                                Fluttertoast.showToast(msg: AppLocalizations.of(context)!.commentPostedToast);

                                Get.back();
                              } catch (e) {
                                articleController.isSubmitting.value = false;
                                // todo: 修改为更友好的错误提示
                                print(e.toString());
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
                        )
                      ],
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
