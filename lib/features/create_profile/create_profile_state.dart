part of 'create_profile_notifier.dart';

enum CreateProfileStep {
  setDisplayName,
  setUsername,
  setProfilePicture,
  finalStep,
}

class CreateProfileState {
  const CreateProfileState({
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.isAlphanumeric = false,
    this.hasSpecialChars = false,
    this.profilePhotoPath,
    this.currentStep = CreateProfileStep.setDisplayName,
    this.isLoading = false,
    this.errorMessage,
  });

  final String firstName;
  final String lastName;
  final String username;
  final bool hasMinLength;
  final bool hasUppercase;
  final bool isAlphanumeric;
  final bool hasSpecialChars;
  final String? profilePhotoPath;
  final CreateProfileStep currentStep;
  final bool isLoading;
  final String? errorMessage;

  bool get isNamesStepValid =>
      firstName.trim().isNotEmpty && lastName.trim().isNotEmpty;

  bool get isUsernameValid =>
      hasMinLength && hasUppercase && isAlphanumeric && hasSpecialChars;

  bool get didSetDisplayName =>
      firstName.trim().isNotEmpty && lastName.trim().isNotEmpty;

  CreateProfileState copyWith({
    String? firstName,
    String? lastName,
    String? username,
    bool? hasMinLength,
    bool? hasUppercase,
    bool? isAlphanumeric,
    bool? hasSpecialChars,
    String? profilePhotoPath,
    CreateProfileStep? currentStep,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CreateProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      isAlphanumeric: isAlphanumeric ?? this.isAlphanumeric,
      hasSpecialChars: hasSpecialChars ?? this.hasSpecialChars,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
    );
  }
}
