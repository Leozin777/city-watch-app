import '../../data/models/dtos/problema_response_dto.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeFailureState extends HomeState {
  String message;

  HomeFailureState({required this.message});
}

class HomeLocalizacaoNegadaState extends HomeState {}

class HomeLocalizacaoDoUsuarioSuccessState extends HomeState {
  double latitude;
  double longitude;

  HomeLocalizacaoDoUsuarioSuccessState({required this.latitude, required this.longitude});
}

class HomeLocationServiceDisabledState extends HomeState {}

class HomeProblemasSuccessState extends HomeState {
  List<ProblemaResponseDto> problemas;

  HomeProblemasSuccessState({required this.problemas});
}

class HomeCriarProblemaSuccessState extends HomeState {}
