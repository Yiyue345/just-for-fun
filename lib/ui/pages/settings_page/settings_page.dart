import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/update.dart';
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
    final settingsController = Get.find<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),

      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('User'),
            subtitle: Text('User settings and preferences'),
            // leading: Icon(Icons.person),
            onTap: () {

            }
          ),
          ListTile(
            title: Text('Check for updates'),
            onTap: () async {
              Fluttertoast.showToast(msg: 'Checking for updates...');
              settingsController.checkingUpdate.value = true;
              bool update = await checkForUpdate();
              settingsController.checkingUpdate.value = false;
              if (update) {
                Fluttertoast.showToast(msg: 'A new update is available!');
                String updateUrl = await getUpdateURL();
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Update available'),
                      content: Text('A new version of the app is available. Would you like to update it?'),
                      actions: [
                        TextButton(
                            onPressed: () => Get.back(), 
                            child: Text('Cancel')
                        ),
                        TextButton(
                            onPressed: () {
                              Get.back();
                              
                              _launchURL(updateUrl);
                            }, 
                            child: Text('Download')
                        )
                      ],
                    )
                );
              }
              else {
                Fluttertoast.showToast(msg: 'You are using the latest version.');
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