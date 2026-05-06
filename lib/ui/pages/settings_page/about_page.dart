import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/core/network/update.dart';
import 'package:go_deeper/data/repository/update_repository.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/settings_page/settings_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  Future<void> _launchURL(String url, AppLocalizations l10n) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Fluttertoast.showToast(msg: l10n.couldNotLaunchUrl(url));
    }
  }

  // todo: 更新的下载和安装
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsController = Get.find<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              title: Text(l10n.checkForUpdates),
              onTap: () async {
                Fluttertoast.showToast(msg: l10n.checkingForUpdates);
                settingsController.checkingUpdate.value = true;
                UpdateRepositoryImpl repository = UpdateRepositoryImpl(updateRemoteDataSource: UpdateRemoteDataSource());
                final UpdateModel updateInfo = await repository.checkForUpdate();
                bool update = updateInfo.canUpdate;
                settingsController.checkingUpdate.value = false;
                if (update) {
                  Fluttertoast.showToast(msg: l10n.updateAvailable);
                  String updateUrl = updateInfo.link!;
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.updateAvailableDialogTitle),
                        content: Text(updateInfo.details ?? l10n.updateAvailableDialogContent),
                        actions: [
                          TextButton(
                              onPressed: () => Get.back(),
                              child: Text(l10n.cancel)
                          ),
                          TextButton(
                              onPressed: () {
                                Get.back();

                                _launchURL(updateUrl, l10n);
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
            ),
            Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
              child: Obx(() => Text(
                l10n.currentVersion(settingsController.version.value),
                style: TextStyle(
                  fontSize: 16,
                ),
              )),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
