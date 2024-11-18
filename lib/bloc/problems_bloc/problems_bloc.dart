import 'package:flutter_bloc/flutter_bloc.dart';
import 'problems_event.dart';
import 'problems_state.dart';

class ProblemsBloc extends Bloc<ProblemsEvent, ProblemsState> {
  ProblemsBloc() : super(ProblemsInitialState()) {
    on<OpenModalEvent>((event, emit) {
      emit(ModalOpenState());
    });

    on<CloseModalEvent>((event, emit) {
      emit(ProblemsInitialState());
    });
  }
}
