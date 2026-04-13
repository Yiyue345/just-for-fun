import 'package:go_deeper/data/model/user_notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<UserNotification>> getUserNotifications({required String userID}) async {
  final supabase = Supabase.instance.client;
  final response = await supabase.from('notifications')
      .select('''
      id,
      create_at:created_at,
      user_id,
      type,
      article_id,
      comment_id,
      is_Read:is_read
      ''')
      .eq('user_id', userID)
      .order('created_at', ascending: false);

  final data = response as List<dynamic>;
  return data
      .map((item) => UserNotification.fromJson(item as Map<String, dynamic>))
      .toList();
}
