import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/data/model/feeditem.dart';
import 'package:go_deeper/ui/pages/article_pages/article_page.dart';

import '../../core/network/user_controller.dart';
import '../../data/model/feeditem_controller.dart';

class SuggestionPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final feedItemController = Get.find<FeedItemController>();
    return Obx(() {
      if (userController.isLoggedIn.value) {
        return RefreshIndicator(
            onRefresh: () {
              return feedItemController.loadArticles(refresh: true);
            },
            child: feedItemController.loading.value
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
                itemCount: feedItemController.feedItems.length + 1,
                itemBuilder: (context, index) {
                  if (index == feedItemController.feedItems.length) {
                    if (feedItemController.hasMore.value) {
                      feedItemController.loadArticles();
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('No more suggestions.'),
                        ),
                      );
                    }
                  }
                  else {
                    final item = feedItemController.feedItems[feedItemController.feedItems.length - index - 1];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.summary),
                      onTap: () {
                        Get.to(() => ArticlePage(article: item as ArticleFeed));
                      },
                    );
                  }
                }
            )
        );
      }
      else {
        return Center(
          child: Text('Please log in to view more.'),
        );
      }
    });
  }
}