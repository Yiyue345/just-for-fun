import 'package:get/get.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/data/model/feeditem.dart';

import 'package:go_deeper/data/repository/article_repository.dart';

/// 应该是全局存在的
class FeedItemController extends GetxController {
  final feedItems = <FeedItem>[].obs;

  final loading = false.obs;
  final hasMore = true.obs;
  final page = 0.obs;

  final isEditingArticle = false.obs;
  ArticleFeed? editingArticle;

  final renderMarkdown = false.obs;

  final repository = Get.find<ArticleRepositoryImpl>();

  // Rx<ArticleFeed?> currentArticle = Rx<ArticleFeed?>(null);

  Future<void> loadFeeds({bool refresh = false}) async {

  }

  @override
  void onInit() {
    super.onInit();
    loadArticles(refresh: true);
  }

  Future<void> loadArticles({bool refresh = false}) async {
    if (refresh) {
      page.value = 0;
      feedItems.clear();
      hasMore.value = true;
    }

    if (!hasMore.value || loading.value) {
      return;
    }

    loading.value = true;

    final newItems = await repository.fetchArticles(page: page.value, pageSize: 20, reserve: true);

    if (newItems.length < 20) {
      hasMore.value = false;
    }

    feedItems.addAll(newItems);
    page.value++;
    loading.value = false;
  }
  

}