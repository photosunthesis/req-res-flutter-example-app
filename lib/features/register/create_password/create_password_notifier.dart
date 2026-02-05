import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:req_res_flutter/core/is_signed_in_provider.dart';
import 'package:req_res_flutter/data/repositories/auth_repository.dart';

part 'create_password_state.dart';

final createPasswordNotifierProvider =
    NotifierProvider<CreatePasswordNotifier, CreatePasswordState>(
      CreatePasswordNotifier.new,
    );

class CreatePasswordNotifier extends Notifier<CreatePasswordState> {
  late final _authRepository = ref.read(authRepositoryProvider);

  @override
  CreatePasswordState build() => CreatePasswordState();

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final isAlphanumeric =
        password.contains(RegExp(r'[a-zA-Z]')) &&
        password.contains(RegExp(r'[0-9]'));
    final hasSpecialChars = password.contains(RegExp(r'[!@#$&-]'));

    state = state.copyWith(
      password: password,
      hasMinLength: hasMinLength,
      hasUppercase: hasUppercase,
      isAlphanumeric: isAlphanumeric,
      hasSpecialChars: hasSpecialChars,
    );
  }

  Future<void> signUp() async {
    try {
      state = state.copyWith(isLoading: true);
      await _authRepository.registerAndSignIn(state.email, state.password);
      ref.invalidate(isSignedInProvider);
      state = state.copyWith(didSignUp: true);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
