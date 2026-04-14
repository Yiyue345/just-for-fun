import 'package:go_deeper/core/network/article.dart';
import 'package:go_deeper/core/network/comment.dart';
import 'package:go_deeper/data/model/comment.dart';
import 'package:go_deeper/data/model/feeditem.dart';

class ArticleDetailData {
  final ArticleFeed? article;
  final List<Comment> comments;

  ArticleDetailData({
    required this.article,
    required this.comments,
  });
}

abstract class ArticleRepository {
  Future<List<ArticleFeed>> fetchArticles({int page = 0, int pageSize = 20});
  Future<List<ArticleFeed>> fetchUserArticles({required String userID, int page = 0, int pageSize = 20});
  Future<ArticleFeed?> fetchArticle({required int articleID});
  Future<ArticleDetailData> fetchArticleDetail({required int articleID});
  Future<ArticleFeed> createArticle({
    required String authorUUID,
    required String title,
    required String content,
    String? summary,
    bool public = true
  });
  Future<ArticleFeed> updateArticle({
    required int articleID,
    String? title,
    String? content,
    String? summary,
    bool? public
  });
  Future<void> deleteArticle({required int articleID});
  Future<Comment> createComment({
    required int articleID,
    required String userID,
    required String content,
    int? parentID,
  });
}

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource articleRemoteDataSource;
  final CommentRemoteDataSource commentRemoteDataSource;

  ArticleRepositoryImpl({
    required this.articleRemoteDataSource,
    required this.commentRemoteDataSource,
  });

  @override
  Future<ArticleFeed?> fetchArticle({required int articleID}) {
    return articleRemoteDataSource.getArticleByID(articleID: articleID);
  }

  @override
  Future<ArticleFeed> createArticle({required String authorUUID, required String title, required String content, String? summary, bool public = true}) {
    return articleRemoteDataSource.createArticle(authorUUID: authorUUID, title: title, content: content, summary: summary, public: public);
  }

  @override
  Future<Comment> createComment({required int articleID, required String userID, required String content, int? parentID}) {
    return commentRemoteDataSource.createComment(articleID: articleID, userID: userID, content: content, parentID: parentID);
  }

  @override
  Future<void> deleteArticle({required int articleID}) {
    return articleRemoteDataSource.deleteArticle(articleID: articleID);
  }

  @override
  Future<ArticleDetailData> fetchArticleDetail({required int articleID}) {
    return Future.wait([
      articleRemoteDataSource.getArticleByID(articleID: articleID),
      commentRemoteDataSource.getComments(articleID: articleID),
    ]).then((results) {
      final article = results[0] as ArticleFeed?;
      final comments = results[1] as List<Comment>;
      return ArticleDetailData(article: article, comments: comments);
    });
  }

  @override
  Future<List<ArticleFeed>> fetchArticles({int page = 0, int pageSize = 20}) {
    return articleRemoteDataSource.getArticles(page: page, perPage: pageSize);
  }

  @override
  Future<List<ArticleFeed>> fetchUserArticles({required String userID, int page = 0, int pageSize = 20}) {
    return articleRemoteDataSource.getArticles(authorUUID: userID, page: page, perPage: pageSize);
  }

  @override
  Future<ArticleFeed> updateArticle({required int articleID, String? title, String? content, String? summary, bool? public}) {
    return articleRemoteDataSource.updateArticle(articleID: articleID, title: title, content: content, summary: summary, public: public);
  }
}