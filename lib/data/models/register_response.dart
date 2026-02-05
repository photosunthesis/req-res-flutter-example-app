class RegisterResponse {
  const RegisterResponse({required this.id, required this.token});

  final int id;
  final String token;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(id: json['id'], token: json['token']);
  }
}
