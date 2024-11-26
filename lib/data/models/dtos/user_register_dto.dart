class UserRegisterDto {
  final String name;
  final String email;
  final String password;
  final String photo;

  UserRegisterDto({required this.name, required this.email, required this.password, this.photo = ''});

  factory UserRegisterDto.fromJson(Map<String, dynamic> json) {
    return UserRegisterDto(name: json['name'], email: json['email'], password: json['password'], photo: json['photo']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password, 'photo': photo};
  }
}
