import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/utils/article_utils.dart';
import 'package:go_deeper/data/model/feeditem.dart';
import 'package:go_deeper/data/repository/article_repository.dart';
import 'package:go_deeper/ui/widgets/article_feed_card.dart';

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
  const UserArticlesPage({super.key});

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
              : l10n.whoseArticles(l10n.user),
        ),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () {
            return userFeedItemsController.loadUserFeedItems(refresh: true);
          },
          child: userFeedItemsController.feedItems.isEmpty
              ? _buildEmptyState(l10n, userFeedItemsController)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
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
                      }

                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(l10n.noMoreArticles),
                        ),
                      );
                    }

                    final item = userFeedItemsController.feedItems[index];
                    return ArticleFeedCard(
                      item: item,
                      showAuthor: false,
                      onTap: () {
                        goToArticlePage(articleID: item.id);
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    AppLocalizations l10n,
    UserFeedItemsController controller,
  ) {
    if (controller.hasMore.value) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 3.3,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.article, size: 80, color: Colors.grey),
        Center(
          child: Text(l10n.noArticlesFound),
        ),
      ],
    );
  }
}
