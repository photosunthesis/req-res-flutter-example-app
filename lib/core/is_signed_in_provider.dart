import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:req_res_flutter/core/shared_preferences_provider.dart';

final isSignedInProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.containsKey('auth_token');
});
