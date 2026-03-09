import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  var user = Rx<User?>(null);
  var session = Rx<Session?>(null);

  var isLoggedIn = false.obs;

  final TextEditingController usernameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final supabase = Supabase.instance.client;
    user.value = supabase.auth.currentUser;
    session.value = supabase.auth.currentSession;
    isLoggedIn.value = user.value != null;
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }
}