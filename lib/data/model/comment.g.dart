// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
  id: (json['id'] as num).toInt(),
  articleId: (json['article_id'] as num).toInt(),
  userId: json['user_id'] as String,
  userName: Comment._readUserNameFromProfiles(json, 'user_name') as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  parentId: (json['parent_id'] as num?)?.toInt(),
  profiles: json['profiles'] as Map<String, dynamic>?,
  parentUserName: json['parentUserName'] as String?,
);

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'article_id': instance.articleId,
  'user_name': instance.userName,
  'content': instance.content,
  'created_at': instance.createdAt.toIso8601String(),
  'parent_id': instance.parentId,
  'parentUserName': instance.parentUserName,
};
