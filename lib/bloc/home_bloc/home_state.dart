import '../../data/models/dtos/problema_dto.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeOpenLoadingState extends HomeState {}

class HomeCloseLoadingState extends HomeState {}

class HomeFailureState extends HomeState {}

class HomeLocalizacaoNegadaState extends HomeState {}

class HomeLocalizacaoDoUsuarioSuccessState extends HomeState {
  double latitude;
  double longitude;

  HomeLocalizacaoDoUsuarioSuccessState({required this.latitude, required this.longitude});
}

class HomeLocationServiceDisabledState extends HomeState {}

class HomeProblemasSuccessState extends HomeState {
  List<ProblemaDto> problemas;

  HomeProblemasSuccessState({required this.problemas});
}
