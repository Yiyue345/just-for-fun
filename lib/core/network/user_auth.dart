import 'package:get/get.dart';
import 'package:go_deeper/core/network/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signUp(
    String email,
    String password
    ) async {
  final userController = Get.find<UserController>();
  if (email.isEmpty || !email.contains('@') || password.isEmpty || password.length < 6) {
    return;
  }
  final supabase = Supabase.instance.client;
  AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password
  );
  print('Sign up successful');
  Session? session = res.session;
  User? user = res.user;

  userController.user.value = user;
  userController.session.value = session;
  userController.isLoggedIn.value = user != null;
  print('Sign up successful: ${user?.email}');
}

Future<void> signIn(
    String email,
    String password
    ) async {
  final userController = Get.find<UserController>();
  if (email.isEmpty || !email.contains('@') || password.isEmpty || password.length < 6) {
    return;
  }
  final supabase = Supabase.instance.client;
  AuthResponse res = await supabase.auth.signInWithPassword(
      email: email,
      password: password
  );
  print('Sign in successful');

  Session? session = res.session;
  User? user = res.user;

  userController.user.value = user;
  userController.session.value = session;
  userController.isLoggedIn.value = user != null;

  print('sign in successful: ${user?.email}');
}

Future<void> signOut() async {
  final userController = Get.find<UserController>();
  final supabase = Supabase.instance.client;
  await supabase.auth.signOut();
  userController.user.value = supabase.auth.currentUser;
  userController.session.value = supabase.auth.currentSession;
  userController.isLoggedIn.value = false;
  print('Sign out successful');
}