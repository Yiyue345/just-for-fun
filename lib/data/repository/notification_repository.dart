import 'package:go_deeper/core/network/user_notification.dart';
import 'package:go_deeper/data/model/user_notification.dart';

abstract class NotificationRepository {
  Future<List<UserNotification>> fetchUserNotifications({required String userID});
  Future<void> markNotificationAsRead({required int notificationID});
}

class NotificationRepositoryImpl implements NotificationRepository {
  final UserNotificationRemoteDataSource notificationRemoteDataSource;

  NotificationRepositoryImpl({
    required this.notificationRemoteDataSource,
  });

  @override
  Future<List<UserNotification>> fetchUserNotifications({required String userID}) {
    return notificationRemoteDataSource.getUserNotifications(userID: userID);
  }

  @override
  Future<void> markNotificationAsRead({required int notificationID}) {
    return notificationRemoteDataSource.markAsRead(notificationID: notificationID);
  }
}