import 'package:get/get.dart';
import 'package:go_deeper/data/repository/notification_repository.dart';

class NotificationsController extends GetxController {
  final NotificationRepositoryImpl repository = Get.find<NotificationRepositoryImpl>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}