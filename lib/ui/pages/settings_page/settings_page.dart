import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
          )
        ],
      ),
    );
  }
}