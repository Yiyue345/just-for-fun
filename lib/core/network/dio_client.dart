import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DioClient {
  DioClient._internal();
  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;

  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
  ));

  /// 获取 Supabase Edge Function 的基础 URL
  String get functionsBaseUrl {
    final restUrl = Supabase.instance.client.rest.url;
    return restUrl.replaceAll('/rest/v1', '/functions/v1');
  }

  /// 构建带鉴权的通用 headers
  Map<String, String> get authHeaders {
    final supabase = Supabase.instance.client;
    final token = supabase.auth.currentSession?.accessToken ?? '';
    final apikey = supabase.rest.headers['apikey'] ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'apikey': apikey,
    };
  }
}

