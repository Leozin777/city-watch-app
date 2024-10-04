import '../enums/e_tipo_problema.dart';

class ProblemaResponseDto {
  final int id;
  final String nome;
  final String endereco;
  final String? descricao;
  final String? foto;
  final double latitude;
  final double longitude;
  final ETipoProblema tipoProblema;
  final int likes;
  final int deslikes;
  final String nomeDoUsuario;

  ProblemaResponseDto(
      {required this.id,
      required this.nome,
      required this.endereco,
      this.descricao,
      this.foto,
      required this.latitude,
      required this.longitude,
      required this.tipoProblema,
      required this.likes,
      required this.deslikes,
      required this.nomeDoUsuario});

  factory ProblemaResponseDto.fromJson(Map<String, dynamic> json) {
    return ProblemaResponseDto(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      descricao: json['descricao'],
      foto: json['foto'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      tipoProblema: ETipoProblema.values[json['tipoProblema']],
      likes: json['likes'],
      deslikes: json['deslikes'],
      nomeDoUsuario: json['nomeDoUsuario'],
    );
  }
}
