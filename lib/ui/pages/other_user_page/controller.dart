import 'package:get/get.dart';
import 'package:go_deeper/core/network/profile.dart';
import 'package:go_deeper/data/model/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtherUsersController extends GetxController {

  Rx<Profile?> currentWatchUserProfile = Rx<Profile?>(null);

  Future<void> updateWatchUserProfile(String userUUID) async {
    final supabase = Supabase.instance.client;

    currentWatchUserProfile.value = null; // 先清空当前用户信息，显示加载状态

    currentWatchUserProfile.value = await getProfile(userUUID: userUUID);
  }
}