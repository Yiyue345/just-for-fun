import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/ui/pages/article_pages/article_page.dart';
import 'package:go_deeper/ui/pages/article_pages/article_controller.dart';
import 'package:go_deeper/ui/pages/agent_page/agent_controller.dart';

void goToArticlePage({required int articleID, bool replace = false}) {
  Get.put(ArticleController(articleID: articleID), tag: articleID.toString());
  final agentTag = 'agent_article_$articleID';
  if (!Get.isRegistered<AgentController>(tag: agentTag)) {
    Get.put(
      AgentController(contextType: 'article_view', articleId: articleID),
      tag: agentTag,
    );
  }
  if (replace) {
    Get.off(() => ArticlePage(articleID: articleID));
  } else {
    Get.to(() => ArticlePage(articleID: articleID));
  }
}