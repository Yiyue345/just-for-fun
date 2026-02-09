// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  uuid: json['id'] as String,
  username: json['username'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  bio: json['bio'] as String?,
  email: json['email'] as String,
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'id': instance.uuid,
  'username': instance.username,
  'avatar_url': instance.avatarUrl,
  'bio': instance.bio,
  'email': instance.email,
};
