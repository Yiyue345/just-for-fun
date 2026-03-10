import 'package:json_annotation/json_annotation.dart';

part 'user_notification.g.dart';
/// [type] 可以是 'comment' 或者什么别的东西
@JsonSerializable()
class UserNotification {

  // todo: 记得加外键
  final int id;
  @JsonKey(name: 'create_at')
  final DateTime createdAt;
  @JsonKey(name: 'user_id')
  final String userID;
  final String type;
  @JsonKey(name: 'article_id')
  final int articleID;
  @JsonKey(name: 'comment_id')
  final int commentID;
  @JsonKey(name: 'is_Read')
  bool isRead;

  UserNotification({
    required this.id,
    required this.createdAt,
    required this.userID,
    required this.type,
    required this.articleID,
    required this.commentID,
    required this.isRead
});

  factory UserNotification.fromJson(Map<String, dynamic> json) => _$UserNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$UserNotificationToJson(this);
}