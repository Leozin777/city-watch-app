import 'package:city_watch/bloc/auth_bloc/register_bloc/register_event.dart';
import 'package:city_watch/bloc/auth_bloc/register_bloc/register_state.dart';
import 'package:city_watch/data/models/dtos/user_login_dto.dart';
import 'package:city_watch/data/models/dtos/user_register_dto.dart';
import 'package:city_watch/data/models/interface/iauthenticate_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final IAuthenticateService _authService = injecaoDeDepencia<IAuthenticateService>();

  RegisterBloc() : super(RegisterInitialState()) {
    on<RegisterButtonPressedEvent>((event, emmit) async {
      emmit(RegisterOpenLoadingState());
      try {
        final response = await _authService.registerUser(UserRegisterDto(name: event.name, email: event.email, password: event.password));
        emmit(RegisterCloseLoadingState());
        final responseLogin = await _authService.login(UserLoginDto(email: event.email, password: event.password));

        if (responseLogin) {
          emmit(RegisterCloseLoadingState());
          emmit(RegisterSuccessState(message: response));
        }
      } on Exception catch (e) {
        emmit(RegisterCloseLoadingState());
        emmit(RegisterFailureState(message: e.toString()));
      }
    });
  }
}
