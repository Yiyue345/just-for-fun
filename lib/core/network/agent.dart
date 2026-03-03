import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> getReply(String prompt) async {
  final supabase = Supabase.instance.client;
  final res = await supabase.functions.invoke(
    'generate-ai-response',
    body: {
      'prompt': prompt,
    },
  );

  return res.data['reply'] as String;
}