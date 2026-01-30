import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/data/model/feeditem.dart';
import 'package:go_deeper/data/model/feeditem_controller.dart';
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
  late TextEditingController _titleController;
  late TextEditingController _summaryController;
  late TextEditingController _contentController;

  @override
  Widget build(BuildContext context) {
    _feedItemController = Get.find<FeedItemController>();
    _titleController = TextEditingController();
    _summaryController = TextEditingController();
    _contentController = TextEditingController();

    if (_feedItemController.isEditingArticle.value) {
      _titleController.text = _feedItemController.editingArticle!.title;
      _summaryController.text = _feedItemController.editingArticle!.summary;
      _contentController.text = _feedItemController.editingArticle!.content;
      title = _feedItemController.editingArticle!.title;
      summary = _feedItemController.editingArticle!.summary;
      content = _feedItemController.editingArticle!.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Article'),
        leading: IconButton(
            onPressed: () {
              if (!isEdited) {
                Get.back();
                return;
              }
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Discard changes?'),
                    content: Text('Leave without saving will lost all changes.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Cancel')
                      ),
                      TextButton(
                          onPressed: () {
                            Get.back();
                            Get.back();
                          },
                          child: Text(
                              'Discard',
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
                  hintText: 'Title',
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
                hintText: 'Summary',
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
                title: Text('Public Article'),
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
                hintText: 'Content',
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
    super.dispose();
    _feedItemController.isEditingArticle.value = false;
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
              await updateArticle(
                  articleID: _feedItemController.editingArticle!.id,
                  title: title,
                  content: content,
                  summary: summary
              );
              Fluttertoast.showToast(msg: 'Article updated successfully.');
            }
            else {
              await createArticle(
                  authorUUID: Supabase.instance.client.auth.currentUser!.id,
                  authorName: Supabase.instance.client.auth.currentUser!.userMetadata?['display_name'],
                  title: title,
                  content: content,
                  summary: summary
              );
              Fluttertoast.showToast(msg: 'Article created successfully.');
            }
          } catch (e) {
            Fluttertoast.showToast(msg: 'Failed to create article: $e');
            isUploading = false;
            return;
          }
          Get.back();
        },
        icon: Icon(Icons.send)
    );
  }
}