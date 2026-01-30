import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../network/user_auth.dart';

String? getUserName() {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) {
    return null;
  }
  return user.userMetadata?['display_name'] as String?;
}

// 注册对话框
void showSignUpDialog(BuildContext context) {
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
                  if (password.length < 6) {
                    Fluttertoast.showToast(msg: 'Password must be at least 6 characters long.');
                    return;
                  }
                  try {
                    await signUp(email, password);
                    Fluttertoast.showToast(msg: 'Signed up successfully.');
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

void showSignInDialog(BuildContext context) {
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
                  showSignUpDialog(context);
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(
                      color: Colors.grey
                  ),
                )
            ),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Cancel')
            ),
            TextButton(
                onPressed: () async {
                  if (email.isEmpty || password.isEmpty) {
                    Fluttertoast.showToast(msg: 'Email and password cannot be empty.');
                    return;
                  }
                  try {
                    await signIn(email, password);
                    if (Supabase.instance.client.auth.currentUser != null) {
                      Fluttertoast.showToast(msg: 'Signed in successfully.');
                      Get.back();
                    }
                    else {
                      Fluttertoast.showToast(msg: 'Sign in failed.');
                    }
                  } catch (e) {
                    if (e is AuthException) {
                      if (e.message == 'Invalid login credentials') {
                        Fluttertoast.showToast(msg: 'Email or password is incorrect.');
                        return;
                      }
                      Fluttertoast.showToast(msg: e.message);
                      // debug 用
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //       content: TextButton(
                      //           onPressed: () async {
                      //             await Clipboard.setData(ClipboardData(text: e.message));
                      //           },
                      //           child: Text(e.message)
                      //       ),
                      //     )
                      // );
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

void showSignOutDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign out'),
          content: Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('Cancel')
            ),
            TextButton(
                onPressed: () async {
                  await signOut();
                  Fluttertoast.showToast(msg: 'Signed out successfully.');
                  Get.back();
                },
                child: Text('Sign out')
            ),
          ],
        );
      }
  );
}

void showSetUserNameDialog(BuildContext context) {
  TextEditingController controller = TextEditingController();
  controller.text = getUserName() ?? '';

  showDialog(
      context: context,
      builder: (context) {
        String displayName = '';
        return AlertDialog(
          title: Text('Set Display Name'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Display Name',
            ),
            onChanged: (value) {
              displayName = value;
            },
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
                  await setUserName(displayName);
                  Fluttertoast.showToast(msg: 'Display name updated.');
                  controller.dispose();
                  Get.back();
                },
                child: Text('Set')
            ),
          ],
        );
      }
  );
}