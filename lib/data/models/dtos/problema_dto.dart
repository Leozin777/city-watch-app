class ProblemaDto {
  final int id;
  final String nome;
  final String endereco;
  final String? descricao;
  final String? foto;
  final double latitude;
  final double longitude;

  ProblemaDto(
      {required this.id,
      required this.nome,
      required this.endereco,
      this.descricao,
      this.foto,
      required this.latitude,
      required this.longitude});

  factory ProblemaDto.fromJson(Map<String, dynamic> json) {
    return ProblemaDto(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      descricao: json['descricao'],
      foto: json['foto'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
