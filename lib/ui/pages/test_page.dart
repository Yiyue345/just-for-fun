import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/core/network/user_auth.dart';
import 'package:go_deeper/core/network/user_controller.dart';
import 'package:go_deeper/core/utils/user_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Obx(() {
        if (userController.isLoggedIn.value) {
          // 难道是 getx 的特性吗。。。不用 SizeBox.expand 就不能覆盖整个父组件的宽度
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(userController.user.value!.email ?? 'No Email'),
                SizedBox(height: 20),
                Text(getUserName() ?? ''),
                SizedBox(height: 20),
                Text(userController.user.value!.id),
                SizedBox(height: 20,),
                Text(userController.session.value?.expiresIn.toString() ?? ''),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      await setUserName('1112223333');
                    },
                    child: Text('Change display name')
                ),
                ElevatedButton(onPressed: () async {
                  await getArticles();
                },
                  child: Text('Get articles'),
                ),
                ElevatedButton(onPressed: () async {
                  signOut();
                },
                    child: Text('Sign out')
                )
              ],
            ),
          );
        }
        else {
          return SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => showSignUpDialog(context),
                    child: Text('Sign up')
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => showSignInDialog(context),
                    child: Text('Sign in')
                ),
                ElevatedButton(onPressed: () {
                  Fluttertoast.showToast(msg: '111');
                }, child: Text('show toast'))
              ],
            ),
          );
        }

      }),
    );
  }

}