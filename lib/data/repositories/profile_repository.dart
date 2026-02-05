import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:req_res_flutter/core/shared_preferences_provider.dart';
import 'package:req_res_flutter/data/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProfileRepository(prefs);
});

class ProfileRepository {
  const ProfileRepository(this._prefs);

  final SharedPreferences _prefs;

  Future<void> setDisplayName(String firstName, String lastName) async {
    await Future.wait([
      _prefs.setString('first_name', firstName),
      _prefs.setString('last_name', lastName),
    ]);
  }

  Future<void> setUsername(String username) async {
    await _prefs.setString('username', username);
  }

  Future<void> setProfilePicture(String profilePicturePath) async {
    await _prefs.setString('profile_picture', profilePicturePath);
  }

  Future<UserProfile> getUserProfile() async {
    return UserProfile(
      firstName: _prefs.getString('first_name'),
      lastName: _prefs.getString('last_name'),
      username: _prefs.getString('username'),
      profilePicturePath: _prefs.getString('profile_picture'),
    );
  }

  Future<void> clearProfile() async {
    final profilePicturePath = _prefs.getString('profile_picture');

    if (profilePicturePath != null) {
      final file = File(profilePicturePath);
      if (await file.exists()) await file.delete();
    }

    await Future.wait([
      _prefs.remove('first_name'),
      _prefs.remove('last_name'),
      _prefs.remove('username'),
      _prefs.remove('profile_picture'),
    ]);
  }

  Future<void> initiateProfile() async {
    await Future.wait([
      _prefs.setString('first_name', 'Eve'),
      _prefs.setString('last_name', 'Holt'),
      _prefs.setString('username', 'eve.holt'),
    ]);
  }
}
