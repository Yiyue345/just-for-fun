// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotification _$UserNotificationFromJson(Map<String, dynamic> json) =>
    UserNotification(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['create_at'] as String),
      userID: json['user_id'] as String,
      type: json['type'] as String,
      articleID: (json['article_id'] as num).toInt(),
      commentID: (json['comment_id'] as num).toInt(),
      isRead: json['is_Read'] as bool,
    );

Map<String, dynamic> _$UserNotificationToJson(UserNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'create_at': instance.createdAt.toIso8601String(),
      'user_id': instance.userID,
      'type': instance.type,
      'article_id': instance.articleID,
      'comment_id': instance.commentID,
      'is_Read': instance.isRead,
    };
