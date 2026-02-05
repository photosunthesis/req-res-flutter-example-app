part of 'create_password_notifier.dart';

class CreatePasswordState {
  const CreatePasswordState({
    this.email = '',
    this.password = '',
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.isAlphanumeric = false,
    this.hasSpecialChars = false,
    this.isLoading = false,
    this.didSignUp = false,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool hasMinLength;
  final bool hasUppercase;
  final bool isAlphanumeric;
  final bool hasSpecialChars;
  final bool isLoading;
  final bool didSignUp;
  final String? errorMessage;

  bool get isPasswordValid =>
      hasMinLength && hasUppercase && isAlphanumeric && hasSpecialChars;

  CreatePasswordState copyWith({
    String? email,
    String? password,
    bool? hasMinLength,
    bool? hasUppercase,
    bool? isAlphanumeric,
    bool? hasSpecialChars,
    bool? isLoading,
    bool? didSignUp,
    String? errorMessage,
  }) {
    return CreatePasswordState(
      email: email ?? this.email,
      password: password ?? this.password,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      isAlphanumeric: isAlphanumeric ?? this.isAlphanumeric,
      hasSpecialChars: hasSpecialChars ?? this.hasSpecialChars,
      isLoading: isLoading ?? this.isLoading,
      didSignUp: didSignUp ?? this.didSignUp,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
