import '../enums/e_tipo_problema.dart';

class ProblemaResponseDto {
  final String nome;
  final String endereco;
  final String? descricao;
  final String? foto;
  final double latitude;
  final double longitude;
  final ETipoProblema tipoProblema;
  final int? likes;
  final int? deslikes;
  final String? nomeDoUsuario;

  ProblemaResponseDto(
      {required this.nome,
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
      nome: json['name'],
      endereco: json['address'],
      descricao: json['description'],
      foto: json['photo'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      tipoProblema: ETipoProblema.values[json['problemType']],
      likes: json['likes'],
      deslikes: json['deslikes'],
      nomeDoUsuario: json['nomeDoUsuario'],
    );
  }
}
