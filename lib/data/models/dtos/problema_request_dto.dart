import 'package:city_watch/data/models/enums/e_tipo_problema.dart';

class ProblemaRequestDto {
  final String nome;
  final String descricao;
  final ETipoProblema tipoDoProblema;
  final String localizacao;
  final String? foto;
  final double latitude;
  final double longitude;

  ProblemaRequestDto(
      {required this.nome,
      required this.descricao,
      required this.tipoDoProblema,
      required this.localizacao,
      required this.foto,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'tipoDoProblema': tipoDoProblema.index,
      'localizacao': localizacao,
      'foto': foto,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
