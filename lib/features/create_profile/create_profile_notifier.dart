import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:req_res_flutter/core/image_picker_provider.dart';
import 'package:req_res_flutter/data/repositories/profile_repository.dart';

part 'create_profile_state.dart';

final createProfileNotifierProvider =
    NotifierProvider<CreateProfileNotifier, CreateProfileState>(
      CreateProfileNotifier.new,
    );

class CreateProfileNotifier extends Notifier<CreateProfileState> {
  late final _profileRepository = ref.read(profileRepositoryProvider);

  @override
  CreateProfileState build() => const CreateProfileState();

  Future<void> setDisplayName(String firstName, String lastName) async {
    state = state.copyWith(firstName: firstName, lastName: lastName);
    await _profileRepository.setDisplayName(firstName, lastName);
  }

  void setUsername(String username) {
    state = state.copyWith(
      username: username,
      hasMinLength: username.length >= 8,
      hasUppercase: RegExp(r'[A-Z]').hasMatch(username),
      isAlphanumeric: RegExp(r'^[a-zA-Z0-9_\-\.]+$').hasMatch(username),
      hasSpecialChars: RegExp(r'[_\-\.]').hasMatch(username),
    );
  }

  Future<void> submitUsername() async {
    if (!state.isUsernameValid) return;

    try {
      state = state.copyWith(isLoading: true);
      await _profileRepository.setUsername(state.username);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void setProfilePhoto(String? path) {
    state = state.copyWith(profilePhotoPath: path);
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ref.read(imagePickerProvider);
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/${pickedFile.name}';
      final savedImage = await File(pickedFile.path).copy(newPath);
      setProfilePhoto(savedImage.path);
    }
  }

  Future<void> submitProfilePicture() async {
    if (state.profilePhotoPath == null) return;

    try {
      state = state.copyWith(isLoading: true);
      await _profileRepository.setProfilePicture(state.profilePhotoPath!);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void setCurrentStep(CreateProfileStep step) {
    state = state.copyWith(currentStep: step);
  }
}
