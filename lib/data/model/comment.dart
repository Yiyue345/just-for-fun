import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final int id;
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(
      name: 'user_name',
      readValue: _readUserNameFromProfiles
  )
  final String userName;

  final String content;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'parent_id')
  final int? parentId;
  String? parentUserName;

  @JsonKey(includeFromJson: true, includeToJson: false)
  final Map<String, dynamic>? profiles;

  List<Comment> replies = [];

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.profiles,
    this.parentUserName,
  });

  static Object? _readUserNameFromProfiles(
      Map<dynamic, dynamic> json,
      String key,
  ) {
    final p = json['profiles'];
    if (p is Map) return p['username'];
    return null;
  }

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}