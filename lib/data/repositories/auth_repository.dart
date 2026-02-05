import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:req_res_flutter/core/api_client_provider.dart';
import 'package:req_res_flutter/core/shared_preferences_provider.dart';
import 'package:req_res_flutter/data/models/register_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(apiClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthRepository(dio, prefs);
});

class AuthRepository {
  const AuthRepository(this._dio, this._prefs);

  final Dio _dio;
  final SharedPreferences _prefs;

  Future<int> registerAndSignIn(String email, String password) async {
    // Because ReqRes only allows specific accounts to register, we'll have to use a
    // hardcoded email and password for now so the API doesn't return an error.
    email = 'eve.holt@reqres.in';
    password = 'pistol';

    final response = await _dio.post(
      '/register',
      data: {'email': email, 'password': password},
    );

    final registerResponse = RegisterResponse.fromJson(response.data);

    await _prefs.setString('auth_token', registerResponse.token);

    return registerResponse.id;
  }

  Future<void> login(String email, String password) async {
    // Same as register, use a hardcoded email and password for now so the API doesn't return an error.
    email = 'eve.holt@reqres.in';
    password = 'pistol';

    final response = await _dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    final token = response.data['token'] as String;
    await _prefs.setString('auth_token', token);
  }

  Future<void> logout() async {
    await _prefs.remove('auth_token');
  }
}
