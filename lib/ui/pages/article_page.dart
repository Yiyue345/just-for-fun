import 'package:flutter/material.dart';
import 'package:go_deeper/data/model/feeditem.dart';

class ArticlePage extends StatelessWidget {

  final ArticleFeed article;

  ArticlePage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
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
            Text(
              article.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}