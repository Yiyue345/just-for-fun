import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtherUsersController extends GetxController {
  User currentWatchUser = Supabase.instance.client.auth.currentUser!;

  @override
  void onInit() {
    super.onInit();
    currentWatchUser = Supabase.instance.client.auth.currentUser!;
  }

  Future<void> updateWatchUser(User newUser) async {
    final supabase = Supabase.instance.client;


  }
}