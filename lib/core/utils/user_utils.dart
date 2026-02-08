import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
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
void showSignUpDialog() {
  final context = Get.context!;
  final l10n = AppLocalizations.of(context)!;
  showDialog(
      context: context,
      builder: (context) {
        String email = '';
        String password = '';
        return AlertDialog(
          title: Text(l10n.signup),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: l10n.emailAddress,
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: l10n.password,
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
                child: Text(l10n.cancel)
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
                child: Text(l10n.signup)
            ),
          ],
        );
      }
  );
}

void showSignInDialog() {
  final context = Get.context!;
  final l10n = AppLocalizations.of(context)!;
  showDialog(
      context: context,
      builder: (context) {
        String email = '';
        String password = '';
        return AlertDialog(
          title: Text(l10n.signIn),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: l10n.emailAddress,
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: l10n.password,
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
                  showSignUpDialog();
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
                child: Text(l10n.cancel)
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
                child: Text(l10n.signIn)
            ),
          ],
        );
      }
  );
}

void showSignOutDialog() {
  final context = Get.context!;
  final l10n = AppLocalizations.of(context)!;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.signOutTitle),
          content: Text(l10n.signOutMessage),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(l10n.cancel)
            ),
            TextButton(
                onPressed: () async {
                  await signOut();
                  Fluttertoast.showToast(msg: 'Signed out successfully.');
                  Get.back();
                },
                child: Text(l10n.signOut)
            ),
          ],
        );
      }
  );
}

Future<void> showSetUserNameDialog(BuildContext context, TextEditingController controller) async {
  controller.text = getUserName() ?? '';
  final l10n = AppLocalizations.of(context)!;

  await showDialog(
      context: context,
      builder: (context) {
        String displayName = controller.text;
        return AlertDialog(
          title: Text(l10n.setDisplayNameTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.displayName,
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
                child: Text(l10n.cancel)
            ),
            TextButton(
                onPressed: () async {
                  if (displayName == getUserName()) {
                    Fluttertoast.showToast(msg: 'Display name is unchanged.');
                    return;
                  }
                  await setUserName(displayName);
                  Fluttertoast.showToast(msg: 'Display name updated.');
                  Get.back();

                },
                child: Text(l10n.set)
            ),
          ],
        );
      }
  );

}