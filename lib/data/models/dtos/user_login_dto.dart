class UserLoginDto {
  final String email;
  final String password;

  UserLoginDto({required this.email, required this.password});

  factory UserLoginDto.fromJson(Map<String, dynamic> json) {
    return UserLoginDto(email: json['email'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}