class TipoProbleDto {
  final int id;
  final String nome;
  final String descricao;

  TipoProbleDto({required this.id, required this.nome, required this.descricao});

  factory TipoProbleDto.fromJson(Map<String, dynamic> json) {
    return TipoProbleDto(id: json['id'], nome: json['nome'], descricao: json['descricao']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'descricao': descricao};
  }
}
