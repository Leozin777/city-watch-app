import 'package:city_watch/data/models/dtos/user_problem_dto.dart';

import '../enums/e_tipo_problema.dart';

class ProblemDetailsDto {
  final String id;
  final String nome;
  final String endereco;
  final String? descricao;
  final String? foto;
  final ETipoProblema tipoProblema;
  final UserProblemDto? userProblem;

  ProblemDetailsDto(
      {required this.id,
      required this.nome,
      required this.endereco,
      this.descricao,
      this.foto,
      required this.tipoProblema,
      this.userProblem});

  factory ProblemDetailsDto.fromJson(Map<String, dynamic> json) {
    return ProblemDetailsDto(
      id: json['uuid'],
      nome: json['name'],
      endereco: json['address'],
      descricao: json['description'],
      foto: json['photo'],
      tipoProblema: ETipoProblema.fromValue(int.parse(json['problemType'].toString())),
      userProblem: json['user'] != null ? UserProblemDto.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': id,
      'name': nome,
      'address': endereco,
      'description': descricao,
      'photo': foto,
      'problemType': tipoProblema.value,
      'user': userProblem?.toJson(),
    };
  }
}
