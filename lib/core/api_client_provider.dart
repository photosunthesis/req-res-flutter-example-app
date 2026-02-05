import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:req_res_flutter/core/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final apiClientProvider = Provider<Dio>((ref) {
  // Typically this should be returned from a secure source, but for
  // this example app, we will simply use --dart-define to pass the API key.
  const xApiKey = String.fromEnvironment('X_API_KEY');

  assert(
    xApiKey.isNotEmpty,
    'X_API_KEY is not set. Please set it using --dart-define=X_API_KEY=your_api_key',
  );

  final dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://reqres.in/api',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (xApiKey.isNotEmpty) 'x-api-key': xApiKey,
            },
          ),
        )
        ..interceptors.addAll([
          ref.watch(_authInterceptorProvider),
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            requestHeader: true,
            responseHeader: true,
            error: true,
          ),
        ]);

  return dio;
});

final _authInterceptorProvider = Provider<_AuthInterceptor>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return _AuthInterceptor(prefs);
});

class _AuthInterceptor extends Interceptor {
  const _AuthInterceptor(this._prefs);

  final SharedPreferences _prefs;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _prefs.getString('auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
