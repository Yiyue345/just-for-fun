import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/core/utils/article_utils.dart';
import 'package:go_deeper/data/model/feeditem.dart';
import 'package:go_deeper/data/model/feeditem_controller.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/article_pages/article_page.dart';
import 'package:go_deeper/ui/pages/agent_page/agent_chat_page.dart';
import 'package:go_deeper/ui/pages/agent_page/agent_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({
    super.key,
  });

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {

  String title = '';
  String summary = '';
  String content = '';
  bool publicArticle = true;
  bool isUploading = false;
  bool isEdited = false;

  late FeedItemController _feedItemController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late AgentController _agentController;
  late String _agentTag;

  @override
  void initState() {
    super.initState();
    _feedItemController = Get.find<FeedItemController>();

    // 初始化编辑内容
    if (_feedItemController.isEditingArticle.value) {
      _titleController.text = _feedItemController.editingArticle!.title;
      _summaryController.text = _feedItemController.editingArticle!.summary;
      _contentController.text = _feedItemController.editingArticle!.content;
      title = _feedItemController.editingArticle!.title;
      summary = _feedItemController.editingArticle!.summary;
      content = _feedItemController.editingArticle!.content;
    }

    _agentTag = 'agent_edit_${DateTime.now().millisecondsSinceEpoch}';
    _agentController = Get.put(
      AgentController(contextType: 'article_edit'),
      tag: _agentTag,
    );

    // 设置回调：agent 工具调用时填充编辑器
    _agentController.onFillArticle = (agentTitle, agentContent, agentSummary) {
      setState(() {
        if (agentTitle.isNotEmpty) {
          title = agentTitle;
          _titleController.text = agentTitle;
        }
        if (agentContent.isNotEmpty) {
          content = agentContent;
          _contentController.text = agentContent;
        }
        if (agentSummary != null && agentSummary.isNotEmpty) {
          summary = agentSummary;
          _summaryController.text = agentSummary;
        }
        isEdited = true;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editArticle),
        leading: IconButton(
            onPressed: () {
              if (!isEdited) {
                Get.back();
                return;
              }
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.discardChangesTitle),
                    content: Text(l10n.discardChangesMessage),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(l10n.cancel)
                      ),
                      TextButton(
                          onPressed: () {
                            Get.back();
                            Get.back();
                          },
                          child: Text(
                              l10n.discard,
                            style: TextStyle(
                              color: Colors.red
                            ),
                          )
                      )
                    ],
                  )
              );
            },
            icon: Icon(Icons.arrow_back)
        ),
        actions: [
          IconButton(onPressed: () {
            _showAgentSheet(context);
          },
              icon: Icon(Icons.auto_awesome)
          ),
          _updateArticleButton()
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontSize: 24
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: l10n.title,
                  hintStyle: TextStyle(
                      color: Colors.grey
                  )
              ),
              onChanged: (value) {
                title = value;
                isEdited = true;
              },
            ),
            TextField(
              controller: _summaryController,
              decoration: InputDecoration(
                hintText: l10n.summary,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey
                )
              ),
              onChanged: (value) {
                summary = value;
                isEdited = true;
              },
            ),
            CheckboxListTile(
                value: publicArticle,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(l10n.publicArticle),
                onChanged: (value) {
                  isEdited = true;
                  setState(() {
                    publicArticle = value ?? true;
                  });
                }
            ),
            Expanded(
                child: TextField(
                  controller: _contentController,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: l10n.content,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16
                )
              ),
              maxLines: null,
              onChanged: (value) {
                content = value;
                isEdited = true;
              },
            ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    Get.delete<AgentController>(tag: _agentTag);
    _feedItemController.isEditingArticle.value = false;
    super.dispose();
  }

  void _showAgentSheet(BuildContext context) {
    // 更新页面上下文为当前编辑器内容
    final sb = StringBuffer();
    if (_feedItemController.isEditingArticle.value) {
      sb.writeln('当前正在编辑文章（ID: ${_feedItemController.editingArticle!.id}）');
    } else {
      sb.writeln('当前正在撰写新文章');
    }
    sb.writeln('标题: $title');
    sb.writeln('摘要: $summary');
    sb.writeln('正文: $content');
    _agentController.setPageContext(sb.toString());

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
          child: AgentChatPage(controllerTag: _agentTag),
        );
      },
    );
  }

  Widget _updateArticleButton() {
    return IconButton(
        onPressed: () async {
          if (title.isEmpty) {
            Fluttertoast.showToast(msg: 'Title cannot be empty.');
            return;
          }
          if (content.isEmpty) {
            Fluttertoast.showToast(msg: 'Content cannot be empty.');
            return;
          }
          if (isUploading) {
            return;
          }
          isUploading = true;
          try {
            if (_feedItemController.isEditingArticle.value) {
              final newItem = await updateArticle(
                  articleID: _feedItemController.editingArticle!.id,
                  title: title,
                  content: content,
                  summary: summary
              );
              final index = _feedItemController.feedItems.indexWhere((item) => item.id == newItem.id);
              if (index != -1) {
                _feedItemController.feedItems[index] = newItem;
              }
              Fluttertoast.showToast(msg: 'Article updated successfully.');
              goToArticlePage(articleID: newItem.id, replace: true);
            }
            else {
              final newItem = await createArticle(
                  authorUUID: Supabase.instance.client.auth.currentUser!.id,
                  // 已经……不需要了
                  // authorName: Supabase.instance.client.auth.currentUser!.userMetadata?['display_name'],
                  title: title,
                  content: content,
                  summary: summary
              );
              _feedItemController.feedItems.add(newItem);
              Fluttertoast.showToast(msg: 'Article created successfully.');
              Get.back();
            }
          } catch (e) {
            Fluttertoast.showToast(msg: 'Failed to create article: $e');
            isUploading = false;
            return;
          }
        },
        icon: Icon(Icons.send)
    );
  }
}