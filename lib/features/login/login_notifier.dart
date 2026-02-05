import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:req_res_flutter/core/is_signed_in_provider.dart';
import 'package:req_res_flutter/data/repositories/auth_repository.dart';
import 'package:req_res_flutter/data/repositories/profile_repository.dart';
import 'package:req_res_flutter/features/login/login_state.dart';

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);

class LoginNotifier extends Notifier<LoginState> {
  late final _authRepository = ref.read(authRepositoryProvider);
  late final _profileRepository = ref.read(profileRepositoryProvider);

  @override
  LoginState build() => const LoginState();

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.login(email, password);
      await _profileRepository.initiateProfile();
      ref.invalidate(isSignedInProvider);
      state = state.copyWith(isSuccess: true);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ??
          e.message ??
          'An unexpected error occurred.';
      state = state.copyWith(errorMessage: errorMessage);
    } catch (e) {
      state = state.copyWith(errorMessage: 'An unexpected error occurred.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
