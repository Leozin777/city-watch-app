class UserProfileExibicaoDto {
  final String uuid;
  final String nome;
  final String email;
  final String foto;

  UserProfileExibicaoDto({required this.uuid, required this.nome, required this.email, required this.foto});

  factory UserProfileExibicaoDto.fromJson(Map<String, dynamic> json) {
    return UserProfileExibicaoDto(
      uuid: json['_uuid'],
      nome: json['_name'],
      email: json['_email'],
      foto: json['_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_uuid': uuid, '_name': nome, '_email': email, '_photo': foto};
  }
}
