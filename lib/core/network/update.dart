import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateRemoteDataSource {
  Future<bool> checkForUpdate() async {
    final supabase = Supabase.instance.client;
    final packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    print(version);

    final response = await supabase
        .from('versions')
        .select()
        .eq('version_number', version);
    // print(response.toString());
    bool result = false;

    try {
      result = (response as List<Map>)[0]['can_update'] as bool;
    } catch(e) {
      print('Error checking for update: $e');
      result = false;
    }

    return result;
  }

  Future<Map<String, dynamic>> getUpdateURLAndDetails() async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('update_links')
        .select();

    return response[0];
  }
}

