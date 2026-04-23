import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_deeper/l10n/app_localizations.dart';
import 'package:go_deeper/ui/pages/other_user_page/controller.dart';
import 'package:go_deeper/ui/pages/other_user_page/other_user_page.dart';
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

void goToOtherUserPage({required String userUUID}) {
  Get.put(OtherUsersController(), tag: userUUID);
  Get.find<OtherUsersController>(tag: userUUID).updateWatchUserProfile(userUUID);
  Get.to(() => OtherUserPage(userUUID: userUUID));
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
                    Fluttertoast.showToast(msg: l10n.passwordMinLength);
                    return;
                  }
                  try {
                    await signUp(email, password);
                    Fluttertoast.showToast(msg: l10n.signUpSuccess);
                    Get.back();
                  } catch (e) {
                    if (e is AuthException) {
                      print('e.message: ${e.message}');
                      if (e.message == 'Password should contain at least one character of each: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ, 0123456789.') {
                        Fluttertoast.showToast(msg: l10n.passwordLettersNumbers);
                        return;
                      }
                      else if (e.message == 'User already registered') {
                        Fluttertoast.showToast(msg: l10n.emailAlreadyRegistered);
                        return;
                      }
                      Fluttertoast.showToast(msg: e.message);
                    } else {
                      Fluttertoast.showToast(msg: l10n.unexpectedError);
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
                  l10n.signup,
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
                    Fluttertoast.showToast(msg: l10n.emailPasswordRequired);
                    return;
                  }
                  try {
                    await signIn(email, password);
                    if (Supabase.instance.client.auth.currentUser != null) {
                      Fluttertoast.showToast(msg: l10n.signInSuccess);
                      Get.back();
                    }
                    else {
                      Fluttertoast.showToast(msg: l10n.signInFailed);
                    }
                  } catch (e) {
                    if (e is AuthException) {
                      if (e.message == 'Invalid login credentials') {
                        Fluttertoast.showToast(msg: l10n.invalidLoginCredentials);
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
                      Fluttertoast.showToast(msg: l10n.unexpectedError);
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
                  Fluttertoast.showToast(msg: l10n.signOutSuccess);
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
                    Fluttertoast.showToast(msg: l10n.displayNameUnchanged);
                    return;
                  }
                  await setUserName(displayName);
                  Fluttertoast.showToast(msg: l10n.displayNameUpdated);
                  Get.back();

                },
                child: Text(l10n.set)
            ),
          ],
        );
      }
  );
}
