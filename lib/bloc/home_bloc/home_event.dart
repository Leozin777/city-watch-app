import 'package:city_watch/data/models/dtos/problema_request_dto.dart';
import 'package:city_watch/data/models/dtos/problema_response_dto.dart';

abstract class HomeEvent {}

class HomeInitalEvent extends HomeEvent {}

class HomeBuscarProblemasEvent extends HomeEvent {}

class HomeCriarProblemaEvent extends HomeEvent {
  final ProblemaRequestDto problema;

  HomeCriarProblemaEvent({required this.problema});
}

class HomeAtualizaTela extends HomeEvent{}
