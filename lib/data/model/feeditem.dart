import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feeditem.g.dart';

enum FeedType {
  article,
  video,
  question,
}

abstract class FeedItem {
  final int id;
  final FeedType type;
  final String title;
  final String summary;
  @JsonKey(name: 'created_at')
  final DateTime publishedTime;
  final String author;
  final String? coverUrl;
  final bool public;

  FeedItem({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.publishedTime,
    required this.author,
    required this.public,
    this.coverUrl,
  });
}

@JsonSerializable()
class ArticleFeed extends FeedItem {
  final String content;
  @JsonKey(name: 'author_name')
  final String? authorName;

  ArticleFeed({
    required super.id,
    required super.title,
    required super.summary,
    required super.publishedTime,
    super.coverUrl,
    required super.author,
    required super.public,
    required this.content,
    this.authorName
  }) : super(type: FeedType.article);

  factory ArticleFeed.fromJson(Map<String, dynamic> json) => _$ArticleFeedFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleFeedToJson(this);
}

@JsonSerializable()
class VideoFeed extends FeedItem {
  final String videoUrl;
  final Duration duration;

  VideoFeed({
    required super.id,
    required super.title,
    required super.summary,
    required super.publishedTime,
    required super.author,
    super.coverUrl,
    required super.public,
    required this.videoUrl,
    required this.duration,
  }) : super(type: FeedType.video);

  factory VideoFeed.fromJson(Map<String, dynamic> json) => _$VideoFeedFromJson(json);
  Map<String, dynamic> toJson() => _$VideoFeedToJson(this);
}

@JsonSerializable()
class QuestionFeed extends FeedItem {
  final String question;
  final List<String> answers;

  QuestionFeed({
    required super.id,
    required super.title,
    required super.summary,
    required super.publishedTime,
    required super.author,
    super.coverUrl,
    required super.public,
    required this.question,
    required this.answers,
  }) : super(type: FeedType.question);

  factory QuestionFeed.fromJson(Map<String, dynamic> json) => _$QuestionFeedFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionFeedToJson(this);
}