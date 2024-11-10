import 'package:flutter_bloc/flutter_bloc.dart';
import 'setting_event.dart';
import 'setting_state.dart';

class SettingsBloc extends Bloc<SettingEvent, SettingState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<SelectNotificationOptionEvent>((event, emit) {
      emit(NotificationOptionSelectedState(event.selectedOption));
    });

    on<ExitAppEvent>((event, emit) {
      emit(SettingsExitAppState());
    });
  }

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is ExitAppEvent) {
      yield SettingsExitAppState();
    }
  }
}
