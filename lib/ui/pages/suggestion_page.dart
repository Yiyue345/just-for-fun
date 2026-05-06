import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/utils/article_utils.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/widgets/article_feed_card.dart';

import '../../data/model/feeditem_controller.dart';
import 'user_page/user_controller.dart';

class SuggestionPage extends StatelessWidget {
  const SuggestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userController = Get.find<UserController>();
    final feedItemController = Get.find<FeedItemController>();

    return Obx(() {
      if (!userController.isLoggedIn.value) {
        return Center(
          child: Text(l10n.suggestionLoginRequired),
        );
      }

      return RefreshIndicator(
        onRefresh: () {
          return feedItemController.loadArticles(refresh: true);
        },
        child: feedItemController.loading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
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

                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(l10n.suggestionNoMore),
                      ),
                    );
                  }

                  final item = feedItemController.feedItems[
                      feedItemController.feedItems.length - index - 1];
                  return ArticleFeedCard(
                    item: item,
                    onTap: () {
                      goToArticlePage(articleID: item.id);
                    },
                  );
                },
              ),
      );
    });
  }
}
