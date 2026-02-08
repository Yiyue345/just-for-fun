import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/core/network/user_controller.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/article_pages/user_articles_page.dart';

class UserPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userController = Get.find<UserController>();
    return Obx(() => ListView(
      padding: EdgeInsets.symmetric(horizontal: 8),
      children: userController.isLoggedIn.value
          ? [
        ListTile(
          title: Text(
              getUserName() ?? l10n.noDisplayName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          trailing: IconButton(
              onPressed: () async {
                await showSetUserNameDialog(context, userController.usernameController);
              },
              icon: Icon(Icons.edit)
          ),
        ),
        ListTile(
          subtitle: Text(userController.user.value!.email!),
          minTileHeight: 8,
        ),
        ListTile(
          title: Text(l10n.articles),
          onTap: () {
            final userFeedController = Get.find<UserFeedItemsController>();
            userFeedController.userUUID = userController.user.value!.id;
            userFeedController.userName = getUserName();
            Get.to(() => UserArticlesPage());
          }
        )
      ]
          : [
        Text(l10n.noLoggedIn)
      ],
    ));
  }

}