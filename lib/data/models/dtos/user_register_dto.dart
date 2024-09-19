class UserRegisterDto {
  final String name;
  final String email;
  final String password;

  UserRegisterDto({required this.name, required this.email, required this.password});

  factory UserRegisterDto.fromJson(Map<String, dynamic> json) {
    return UserRegisterDto(name: json['name'], email: json['email'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }
}
