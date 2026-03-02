import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/ui/pages/article_pages/article_page.dart';
import 'package:go_deeper/ui/pages/article_pages/article_controller.dart';

void goToArticlePage({required int articleID, bool replace = false}) {
  Get.put(ArticleController(articleID: articleID), tag: articleID.toString());
  if (replace) {
    Get.off(() => ArticlePage(articleID: articleID));
  } else {
    Get.to(() => ArticlePage(articleID: articleID));
  }
}