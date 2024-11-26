import 'package:city_watch/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/interface/iproblems_service.dart';
import 'problems_event.dart';
import 'problems_state.dart';

class ProblemsBloc extends Bloc<ProblemsEvent, ProblemsState> {
  final IProblemaService _problemaservice = injecaoDeDepencia<IProblemaService>();
  ProblemsBloc() : super(ProblemsInitialState()) {
    on<BuscarDadosEvent>((event, emit) async{
      emit(OpenLoading());
      try {
        final dados = await _problemaservice.getProblemas();
        emit(CloseLoading());
        emit(BuscarDadosSucess(qtdProblemaDto: dados));
      } on Exception catch (e) {
        emit(CloseLoading());
        emit(OpenError(mensagem: e.toString()));
      }
    });

  }
}
