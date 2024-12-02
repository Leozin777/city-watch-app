class UserProblemDto {
  final String nome;
  final String? photo;

  UserProblemDto({required this.nome, this.photo});

  factory UserProblemDto.fromJson(Map<String, dynamic> json) {
    return UserProblemDto(
      nome: json['name'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nome,
      'photo': photo,
    };
  }
}
