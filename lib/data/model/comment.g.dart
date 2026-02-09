// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) =>
    Comment(
        id: (json['id'] as num).toInt(),
        userId: json['user_id'] as String,
        userName:
            Comment._readUserNameFromProfiles(json, 'user_name') as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        parentId: (json['parent_id'] as num?)?.toInt(),
        profiles: json['profiles'] as Map<String, dynamic>?,
      )
      ..replies = (json['replies'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'user_name': instance.userName,
  'content': instance.content,
  'created_at': instance.createdAt.toIso8601String(),
  'parent_id': instance.parentId,
  'replies': instance.replies,
};
