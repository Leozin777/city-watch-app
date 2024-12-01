class UserProfileDto {
  final String? nome;
  final String? email;
  final String? foto;

  UserProfileDto({this.nome, this.email, this.foto});

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(nome: json['name'], email: json['email'], foto: json['photo']);
  }

  Map<String, dynamic> toJson() {
    return {'name': nome, 'email': email, 'photo': foto};
  }
}
