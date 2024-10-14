import 'package:city_watch/data/models/dtos/problema_request_dto.dart';

abstract class HomeEvent {}

class HomeInitalEvent extends HomeEvent {}

class HomeBuscarProblemasEvent extends HomeEvent {
  final double latitude;
  final double longitude;

  HomeBuscarProblemasEvent({required this.latitude, required this.longitude});
}

class HomeCriarProblemaEvent extends HomeEvent {
  final ProblemaRequestDto problema;

  HomeCriarProblemaEvent({required this.problema});
}

class HomeAtualizaTela extends HomeEvent{}
