// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeditem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleFeed _$ArticleFeedFromJson(Map<String, dynamic> json) => ArticleFeed(
  id: json['id'] as String,
  title: json['title'] as String,
  summary: json['summary'] as String,
  publishedTime: DateTime.parse(json['created_at'] as String),
  coverUrl: json['coverUrl'] as String?,
  author: json['author'] as String,
  public: json['public'] as bool,
  content: json['content'] as String,
);

Map<String, dynamic> _$ArticleFeedToJson(ArticleFeed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'created_at': instance.publishedTime.toIso8601String(),
      'author': instance.author,
      'coverUrl': instance.coverUrl,
      'public': instance.public,
      'content': instance.content,
    };

VideoFeed _$VideoFeedFromJson(Map<String, dynamic> json) => VideoFeed(
  id: json['id'] as String,
  title: json['title'] as String,
  summary: json['summary'] as String,
  publishedTime: DateTime.parse(json['created_at'] as String),
  author: json['author'] as String,
  coverUrl: json['coverUrl'] as String?,
  public: json['public'] as bool,
  videoUrl: json['videoUrl'] as String,
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
);

Map<String, dynamic> _$VideoFeedToJson(VideoFeed instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'summary': instance.summary,
  'created_at': instance.publishedTime.toIso8601String(),
  'author': instance.author,
  'coverUrl': instance.coverUrl,
  'public': instance.public,
  'videoUrl': instance.videoUrl,
  'duration': instance.duration.inMicroseconds,
};

QuestionFeed _$QuestionFeedFromJson(Map<String, dynamic> json) => QuestionFeed(
  id: json['id'] as String,
  title: json['title'] as String,
  summary: json['summary'] as String,
  publishedTime: DateTime.parse(json['created_at'] as String),
  author: json['author'] as String,
  coverUrl: json['coverUrl'] as String?,
  public: json['public'] as bool,
  question: json['question'] as String,
  answers: (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$QuestionFeedToJson(QuestionFeed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'created_at': instance.publishedTime.toIso8601String(),
      'author': instance.author,
      'coverUrl': instance.coverUrl,
      'public': instance.public,
      'question': instance.question,
      'answers': instance.answers,
    };
