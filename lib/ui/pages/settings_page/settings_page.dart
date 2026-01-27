import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/update.dart';

class SettingsController extends GetxController {
  final checkingUpdate = false.obs;
}

class SettingsPage extends StatelessWidget {
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
              Fluttertoast.showToast(msg: update.toString());
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