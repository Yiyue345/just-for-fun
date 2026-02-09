import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/update.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/settings_page/about_page.dart';
import 'package:go_deeper/ui/pages/settings_page/change_language_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final checkingUpdate = false.obs;
  final version = ''.obs;

  Future<void> checkAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  @override
  void onInit() {
    super.onInit();
    checkAppVersion();
  }
}

class SettingsPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // final settingsController = Get.find<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),

      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.user),
            subtitle: Text(l10n.settingUserSubtitle),
            // leading: Icon(Icons.person),
            onTap: () {

            }
          ),
          ListTile(
            title: Text(l10n.languageTitle),
            subtitle: Text(l10n.languageSubtitle),
            onTap: () {
              Get.to(() => ChangeLanguagePage());
            },
          ),
          ListTile(
            title: Text(l10n.about),
            onTap: () {
              Get.to(() => AboutPage());
            },
          )
        ],
      ),
    );
  }
}