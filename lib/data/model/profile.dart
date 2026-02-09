import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  @JsonKey(name: 'id')
  final String uuid;
  final String? username;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String? bio;
  final String email;

  Profile({
    required this.uuid,
    this.username,
    this.avatarUrl,
    this.bio,
    required this.email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

}