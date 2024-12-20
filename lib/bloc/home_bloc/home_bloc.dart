import 'package:city_watch/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/dtos/problema_response_dto.dart';
import '../../data/models/interface/ihome_service.dart';
import '../../data/service/NotificationService.dart';
import '../../helpers/calcula_distancia.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IHomeService _homeService = injecaoDeDepencia<IHomeService>();
  final NotificationService notificationService = injecaoDeDepencia<NotificationService>();
  List<ProblemaResponseDto> problemasAnteriores = [];
  Set<String> problemasNotificados = {};
  Map<String, DateTime> ultimaNotificacaoProblema = {};

  HomeBloc() : super(HomeInitialState()) {
    on<HomeInitalEvent>((event, emit) async {
      notificationService.init();
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(HomeLocationServiceDisabledState());
        return;
      }

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
    });
    on<HomeCriarProblemaEvent>((event, emit) async {
      try {
        await _homeService.criarProblema(event.problema);
        emit(HomeCriarProblemaSuccessState());
        add(HomeAtualizaTela());
      } catch (e) {
        emit(HomeFailureState(message: "Erro ao criar problema"));
      }
    });
    on<HomeAtualizaTela>((event, emit) async {
      try {
        final problemas = await _homeService.getProblemas();
        emit(HomeProblemasSuccessState(problemas: problemas));
      } catch (e) {
        emit(HomeFailureState(message: "Erro ao buscar problemas"));
      }
    });
    on<HomeBuscarProblemasEvent>((event, emit) async {
      try {
        final problemas = await _homeService.getProblemas();
        emit(HomeProblemasSuccessState(problemas: problemas));

        await _verificarProblemasProximos();
      } catch (e) {
        emit(HomeFailureState(message: "Erro ao buscar problemas"));
      }
    });

    on<HomeBuscarDatalhesDoProblema>((event, emit) async {
      try {
        final problema = await _homeService.buscarDetalhesDoProblema(event.idProblema);
        emit(HomeDetalhesDoProblemaSuccessState(problema: problema));
      } on Exception catch (e) {
        emit(HomeFailureState(message: "Erro ao buscar detalhes do problema"));
      }
    });
  }

  Future<void> _verificarProblemasProximos() async {
    Position position = await Geolocator.getCurrentPosition();
    double latitude = position.latitude;
    double longitude = position.longitude;

    final problemas = await _homeService.getProblemas();
    final problemasDentroDaDistancia = problemas.where((problema) {
      final distance = CalculaDistancia.calculateDistanceEntreDoisPontos(
        latitude,
        longitude,
        problema.latitude,
        problema.longitude,
      );
      return distance <= 0.5;
    }).toList();

    for (var problema in problemasDentroDaDistancia) {
      String chaveProblema = "${problema.latitude},${problema.longitude}";
      DateTime agora = DateTime.now();

      if (ultimaNotificacaoProblema.containsKey(chaveProblema)) {
        DateTime ultimaNotificacao = ultimaNotificacaoProblema[chaveProblema]!;
        Duration diferenca = agora.difference(ultimaNotificacao);
        if (diferenca.inMinutes < 5) {
          continue;
        }
      }

      notificationService.showNotification(
        'Problema Proximo',
        'Problema "${problema.nome}" à frente.',
      );
      ultimaNotificacaoProblema[chaveProblema] = agora;
    }
  }
}
