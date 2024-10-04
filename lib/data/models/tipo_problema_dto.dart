import 'package:city_watch/data/models/enums/e_tipo_problema.dart';

class TipoProblemaDto {
  final ETipoProblema tipoEnum;
  final String nome;

  TipoProblemaDto({
    required this.tipoEnum,
    required this.nome,
  });
}
