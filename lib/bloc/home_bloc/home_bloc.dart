import 'package:city_watch/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/interface/ihome_service.dart';
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
        try {
          final problemas = await _homeService.getProblemas();
          emit(HomeProblemasSuccessState(problemas: problemas));
        } on Exception catch (e) {
          emit(HomeFailureState());
        }
      }
    });
  }
}
