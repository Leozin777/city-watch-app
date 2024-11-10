class ProfileEditDto {
  final String name;
  final String email;
  final String password;

  ProfileEditDto({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
