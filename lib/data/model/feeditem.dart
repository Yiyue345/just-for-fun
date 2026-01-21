enum FeedType {
  article,
  video,
  question,
}

abstract class FeedItem {
  final String id;
  final FeedType type;
  final String title;
  final String summary;
  final DateTime publishedTime;
  final String author;
  final String? coverUrl;

  FeedItem({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.publishedTime,
    required this.author,
    this.coverUrl,
  });
}

class ArticleFeed extends FeedItem {
  final String content;

  ArticleFeed({
    required super.id,
    required super.title,
    required super.summary,
    required super.publishedTime,
    super.coverUrl,
    required super.author,
    required this.content,
  }) : super(type: FeedType.article);
}

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
    required this.videoUrl,
    required this.duration,
  }) : super(type: FeedType.video);
}

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
    required this.question,
    required this.answers,
  }) : super(type: FeedType.question);
}