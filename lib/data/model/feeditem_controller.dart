import 'package:get/get.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/data/model/feeditem.dart';

class FeedItemController extends GetxController {
  final feedItems = <FeedItem>[].obs;

  final loading = false.obs;
  final hasMore = true.obs;
  final page = 0.obs;

  final isEditingArticle = false.obs;
  ArticleFeed? editingArticle;
  
  Rx<ArticleFeed?> currentArticle = Rx<ArticleFeed?>(null);

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

    final newItems = await getArticles(reserve: true, page: page.value, perPage: 20);

    if (newItems.length < 20) {
      hasMore.value = false;
    }

    feedItems.addAll(newItems);
    page.value++;
    loading.value = false;
  }
  
  Future<void> reloadCurrentArticle() async {
    if (currentArticle.value == null) {
      return;
    }
    final updatedArticle = await getArticleByID(articleID: currentArticle.value!.id);
    if (updatedArticle != null) {
      currentArticle.value = updatedArticle;
      final replaceIndex = feedItems.indexWhere((article) => article.id == updatedArticle.id);
      if (replaceIndex != -1) {
        feedItems[replaceIndex] = updatedArticle;
      }
    }
  }
}