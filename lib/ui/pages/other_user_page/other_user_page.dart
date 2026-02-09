import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/other_user_page/controller.dart';

import '../article_pages/user_articles_page.dart';

class OtherUserPage extends GetView<OtherUsersController> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userProfile),
      ),
      body: Obx(() => controller.currentWatchUserProfile.value == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        padding: EdgeInsets.symmetric(horizontal: 8),
        children: [
          ListTile(
            title: Text(
                controller.currentWatchUserProfile.value!.username ?? l10n.noDisplayName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
          ),
          ListTile(
            subtitle: Text(controller.currentWatchUserProfile.value!.email ?? ''),
            minTileHeight: 8,
          ),
          ListTile(
              title: Text(l10n.articles),
              onTap: () {
                final userFeedController = Get.find<UserFeedItemsController>();
                userFeedController.userUUID = controller.currentWatchUserProfile.value!.uuid;
                userFeedController.userName = controller.currentWatchUserProfile.value!.username;
                Get.to(() => UserArticlesPage());
              }
          )
        ],
      )
      ),
    );
  }
}