import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/update.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/settings_page/change_language_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final checkingUpdate = false.obs;
}

class SettingsPage extends StatelessWidget {
  
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(msg: 'Could not launch $url');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsController = Get.find<SettingsController>();
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
            title: Text(l10n.checkForUpdates),
            onTap: () async {
              Fluttertoast.showToast(msg: l10n.checkingForUpdates);
              settingsController.checkingUpdate.value = true;
              bool update = await checkForUpdate();
              settingsController.checkingUpdate.value = false;
              if (update) {
                Fluttertoast.showToast(msg: l10n.updateAvailable);
                Map updates = await getUpdateURLAndDetails();
                String updateUrl = updates['link'] ?? '';
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.updateAvailableDialogTitle),
                      content: Text(updates['details'] ?? 'A new version of the app is available. Would you like to download it now?'),
                      actions: [
                        TextButton(
                            onPressed: () => Get.back(), 
                            child: Text(l10n.cancel)
                        ),
                        TextButton(
                            onPressed: () {
                              Get.back();
                              
                              _launchURL(updateUrl);
                            }, 
                            child: Text(l10n.download)
                        )
                      ],
                    )
                );
              }
              else {
                Fluttertoast.showToast(msg: l10n.noUpdateAvailable);
              }
            },
            trailing: Obx(() {
              if (settingsController.checkingUpdate.value) {
                return SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              } else {
                return Icon(Icons.chevron_right);
              }
            }),
          )
        ],
      ),
    );
  }
}