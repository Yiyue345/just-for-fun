import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/core/utils/article_utils.dart';
import 'package:go_deeper/data/model/feeditem.dart';
import 'package:go_deeper/data/repository/article_repository.dart';
import 'package:go_deeper/ui/pages/article_pages/article_page.dart';

import '../../../data/model/feeditem_controller.dart';
import '../../../l10n/app_localizations.dart';

class UserFeedItemsController extends GetxController {
  final feedItems = <FeedItem>[].obs;
  final loading = false.obs;
  final hasMore = true.obs;
  final page = 0.obs;

  String userUUID = '';
  String? userName;

  final repository = Get.find<ArticleRepositoryImpl>();

  Future<void> loadUserFeedItems({bool refresh = false}) async {
    if (refresh) {
      page.value = 0;
      feedItems.clear();
      hasMore.value = true;
    }

    if (!hasMore.value || loading.value) {
      return;
    }

    loading.value = true;

    final newItems = await repository.fetchUserArticles(
      userID: userUUID,
      page: page.value,
      pageSize: 20,
    );

    if (newItems.length < 20) {
      hasMore.value = false;
    }

    feedItems.addAll(newItems);
    page.value++;
    loading.value = false;
  }
}

class UserArticlesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userFeedItemsController = Get.find<UserFeedItemsController>();
    userFeedItemsController.loadUserFeedItems(refresh: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            userFeedItemsController.userName != null
                ? l10n.whoseArticles(userFeedItemsController.userName!)
                : l10n.whoseArticles(l10n.user)
        ),
      ),
      body: Obx(() => RefreshIndicator(
          onRefresh: () {
            return userFeedItemsController.loadUserFeedItems(refresh: true);
          },
          child: userFeedItemsController.feedItems.isEmpty
              ? userFeedItemsController.hasMore.value
                ? Center(
            child: CircularProgressIndicator(
              // value: 0.6,
              strokeWidth: 3.3,
            ),
          )
                : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article, size: 80, color: Colors.grey),
              Center(child: Text('No articles found.') ),
            ],
          )
              : ListView.builder(
              itemCount: userFeedItemsController.feedItems.length + 1,
              itemBuilder: (context, index) {
                if (index == userFeedItemsController.feedItems.length) {
                  if (userFeedItemsController.hasMore.value) {
                    userFeedItemsController.loadUserFeedItems();
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('No more articles.'),
                      ),
                    );
                  }
                } else {
                  final item = userFeedItemsController.feedItems[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.summary),
                    onTap: () {
                      goToArticlePage(articleID: item.id);
                    },
                  );
                }
              }
          )
      )),
    );
  }
}