import 'package:city_watch/data/models/dtos/qtd_problema_dto.dart';

abstract class ProblemsState {
}

class ProblemsInitialState extends ProblemsState {}


class OpenLoading extends ProblemsState{}

class CloseLoading extends ProblemsState{}

class OpenError extends ProblemsState{
  final String mensagem;

  OpenError({required this.mensagem});
}

class BuscarDadosSucess extends ProblemsState{
  final QtdProblemaDto qtdProblemaDto;

  BuscarDadosSucess({required this.qtdProblemaDto});

}
