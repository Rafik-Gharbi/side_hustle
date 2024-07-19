class LoginDTO {
  final String? token;
  final String? refreshToken;

  LoginDTO({
    required this.token,
    required this.refreshToken,
  });

  factory LoginDTO.fromJson(Map<String, dynamic> json) => LoginDTO(token: json['token'], refreshToken: json['refreshToken']);
}
