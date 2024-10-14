import 'package:city_watch/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/interface/ihome_service.dart';
import '../../helpers/calcula_distancia.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  IHomeService _homeService = injecaoDeDepencia<IHomeService>();

  HomeBloc() : super(HomeInitialState()) {
    on<HomeInitalEvent>((event, emit) async {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(HomeLocationServiceDisabledState());
      } else {
        final permissao = await Geolocator.checkPermission();
        if (permissao == LocationPermission.denied) {
          final permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
            emit(HomeLocalizacaoNegadaState());
            return;
          }
        }

        Position position = await Geolocator.getCurrentPosition();
        emit(HomeLocalizacaoDoUsuarioSuccessState(latitude: position.latitude, longitude: position.longitude));
      }
    });

    on<HomeCriarProblemaEvent>((event, emit) async {
      emit(HomeOpenLoadingState());
      try {
        await _homeService.criarProblema(event.problema);
        emit(HomeCloseLoadingState());
        emit(HomeCriarProblemaSuccessState());
      } on Exception catch (e) {
        emit(HomeCloseLoadingState());
        emit(HomeFailureState());
      }
    });

    on<HomeAtualizaTela>((event, emit) async {
      emit(HomeOpenLoadingState());
      try {
        final problemas = await _homeService.getProblemas();
        emit(HomeCloseLoadingState());
        emit(HomeProblemasSuccessState(problemas: problemas));
      } on Exception catch (e) {
        emit(HomeCloseLoadingState());
        emit(HomeFailureState());
      }
    });

    on<HomeBuscarProblemasEvent>((event, emit) async {
      emit(HomeOpenLoadingState());
      try {
        final problemas = await _homeService.getProblemas();
        final problemasDentroDaDistancia = problemas.where((problema) {
          final distance = CalculaDistancia.calculateDistanceEntreDoisPontos(
            event.latitude,
            event.longitude,
            problema.latitude,
            problema.longitude,
          );
          return distance <= 2;
        }).toList();
        emit(HomeCloseLoadingState());
        emit(HomeProblemasSuccessState(problemas: problemasDentroDaDistancia));
      } on Exception catch (e) {
        emit(HomeCloseLoadingState());
        emit(HomeFailureState());
      }
    });
  }
}
