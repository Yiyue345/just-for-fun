import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({super.key});

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {

  String title = '';
  String summary = '';
  String content = '';
  bool publicArticle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Article'),
        actions: [
          IconButton(
              onPressed: () async {
                if (title.isEmpty) {
                  Fluttertoast.showToast(msg: 'Title cannot be empty.');
                  return;
                }
                if (content.isEmpty) {
                  Fluttertoast.showToast(msg: 'Content cannot be empty.');
                  return;
                }
                await createArticle(
                    authorUUID: Supabase.instance.client.auth.currentUser!.id,
                    title: title,
                    content: content,
                    summary: summary
                );
                Fluttertoast.showToast(msg: 'Article created successfully.');
                Get.back();
              },
              icon: Icon(Icons.send)
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
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
              },
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Summary',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey
                )
              ),
              onChanged: (value) {
                summary = value;
              },
            ),
            CheckboxListTile(
                value: publicArticle,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('Public Article'),
                onChanged: (value) {
                  setState(() {
                    publicArticle = value ?? true;
                  });
                }
            ),
            Expanded(
                child: TextField(
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
              },
            ))
          ],
        ),
      ),
    );
  }
}