import 'package:go_deeper/data/model/feeditem.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> createArticle({
  required String authorUUID,
  required String title,
  required String content,
  String? summary,
  bool public = true
}) async {
  final supabase = Supabase.instance.client;
  await supabase
      .from('article')
      .insert({'author': authorUUID, 'title': title, 'content': content, 'summary': summary, 'public': public, 'created_at': DateTime.now().toIso8601String()});
}

Future<void> updateArticle({
  required String articleID,
  String? title,
  String? content,
  String? summary,
  bool? public
}) async {
  final supabase = Supabase.instance.client;
  final updates = <String, dynamic>{};
  if (title != null) {
    updates['title'] = title;
  }
  if (content != null) {
    updates['content'] = content;
  }
  if (summary != null) {
    updates['summary'] = summary;
  }
  if (public != null) {
    updates['public'] = public;
  }
  await supabase
      .from('article')
      .update(updates)
      .eq('id', articleID);
}

Future<void> deleteArticle({
  required String articleID,
}) async {
  final supabase = Supabase.instance.client;
  await supabase
      .from('article')
      .delete()
      .eq('id', articleID);
}

Future<List<ArticleFeed>> getArticles({
  String? authorUUID,
  int startIndex = 0,
  int count = 20,
  bool reserve = false
}) async {
  final supabase = Supabase.instance.client;
  late var query;
  if (authorUUID != null) {
    query = supabase
        .from('article')
        .select()
        .eq('author', authorUUID)
        .order('created_at', ascending: reserve)
        .range(startIndex, startIndex + count - 1);
  }
  else {
    query = supabase
        .from('article')
        .select()
        .order('created_at', ascending: reserve)
        .range(startIndex, startIndex + count - 1);
  }
  final response = await query;
  final data = response as List<dynamic>;
  return data.map((e) => ArticleFeed.fromJson(e as Map<String, dynamic>)).toList();
}
