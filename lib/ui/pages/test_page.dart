import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_deeper/core/network/user_auth.dart';
import 'package:go_deeper/core/network/user_controller.dart';
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
                Text(userController.user.value!.id),
                SizedBox(height: 20,),
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
                    onPressed: _showSignUpDialog,
                    child: Text('Sign up')
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _showSignInDialog,
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



  // 注册对话框
  void _showSignUpDialog() {
    showDialog(
        context: context,
        builder: (context) {
          String email = '';
          String password = '';
          return AlertDialog(
            title: Text('Sign up'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Cancel')
              ),
              TextButton(
                  onPressed: () async {
                    try {
                      await signUp(email, password);
                      Get.back();
                    } catch (e) {
                      if (e is AuthException) {
                        print('e.message: ${e.message}');
                        if (e.message == 'Password should contain at least one character of each: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ, 0123456789.') {
                          Fluttertoast.showToast(msg: 'Password must include both letters and numbers.');
                          return;
                        }
                        else if (e.message == 'User already registered') {
                          Fluttertoast.showToast(msg: 'This email is already registered.');
                          return;
                        }
                        Fluttertoast.showToast(msg: e.message);
                      } else {
                        Fluttertoast.showToast(msg: 'An unexpected error occurred.');
                      }
                    }
                  },
                  child: Text('Sign up')
              ),
            ],
          );
        }
    );
  }

  void _showSignInDialog() {
    showDialog(
        context: context,
        builder: (context) {
          String email = '';
          String password = '';
          return AlertDialog(
            title: Text('Sign in'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Cancel')
              ),
              TextButton(
                  onPressed: () async {
                    try {
                      await signIn(email, password);
                      Get.back();
                    } catch (e) {
                      if (e is AuthException) {
                        if (e.message == 'Invalid login credentials') {
                          Fluttertoast.showToast(msg: 'Email or password is incorrect.');
                          return;
                        }
                        Fluttertoast.showToast(msg: e.message);
                      } else {
                        Fluttertoast.showToast(msg: 'An unexpected error occurred.');
                      }
                    }
                  },
                  child: Text('Sign in')
              ),
            ],
          );
        }
    );
  }
}