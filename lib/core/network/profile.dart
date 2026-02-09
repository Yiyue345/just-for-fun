import 'package:go_deeper/data/model/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Profile> getProfile({
  required String userUUID,
}) {
  final supabase = Supabase.instance.client;

  return supabase.from('profiles')
      .select()
      .eq('id', userUUID)
      .single()
      .then((response) => Profile.fromJson(response));
}