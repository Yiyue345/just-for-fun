import 'package:go_deeper/data/model/comment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRemoteDataSource {
  final SupabaseClient supabase;

  CommentRemoteDataSource(this.supabase);

  Future<Comment> createComment({
    required int articleID,
    required String userID,
    required String content,
    int? parentID,
  }) async {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('comment').insert({
      'article_id': articleID,
      'user_id': userID,
      'content': content,
      'parent_id': parentID,
    }).select('''
    id,
    user_id,
    content,
    created_at,
    parent_id,
    article_id,
    profiles (
      username
    )
  ''')
        .single();

    final comment = Comment.fromJson(response);

    return comment;
  }

  Future<void> deleteComment({
    required int commentID,
  }) async {
    final supabase = Supabase.instance.client;

    await supabase.from('comment')
        .delete()
        .eq('id', commentID);
  }

  Future<List<Comment>> getComments({
    required int articleID
  }) {
    final supabase = Supabase.instance.client;

    return supabase.from('comment')
        .select('''
      id,
      user_id,
      content,
      created_at,
      parent_id,
      article_id,
      profiles (
        username
      )
      ''')
        .eq('article_id', articleID)
        .order('created_at', ascending: true)
        .then((data) {
      final comments = (data as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList();
      return comments;
    });
  }
}

