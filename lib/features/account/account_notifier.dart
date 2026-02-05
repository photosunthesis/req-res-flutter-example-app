import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:req_res_flutter/core/is_signed_in_provider.dart';
import 'package:req_res_flutter/data/repositories/auth_repository.dart';
import 'package:req_res_flutter/data/repositories/profile_repository.dart';
import 'package:req_res_flutter/features/account/account_state.dart';

final accountNotifierProvider = NotifierProvider<AccountNotifier, AccountState>(
  AccountNotifier.new,
);

class AccountNotifier extends Notifier<AccountState> {
  late final _authRepository = ref.read(authRepositoryProvider);
  late final _profileRepository = ref.read(profileRepositoryProvider);

  @override
  AccountState build() {
    fetchProfile();
    return const AccountState.loading();
  }

  Future<void> fetchProfile() async {
    state = const AccountState.loading();
    try {
      final profile = await _profileRepository.getUserProfile();
      state = AccountState.data(profile);
    } catch (e, st) {
      state = AccountState.error(e, st);
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    ref.invalidate(isSignedInProvider);
    await _profileRepository.clearProfile();
  }
}
