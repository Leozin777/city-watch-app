import 'package:city_watch/bloc/auth_bloc/login_bloc/login_event.dart';
import 'package:city_watch/bloc/auth_bloc/login_bloc/login_state.dart';
import 'package:city_watch/data/models/interface/iauthenticate_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/dtos/user_login_dto.dart';
import '../../../main.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthenticateService _authService = injecaoDeDepencia<IAuthenticateService>();

  LoginBloc() : super(LoginInitialState()){
   on<LoginButtonPressedEvent>((event, emmit) async{
     emmit(LoginOpenLoadingState());
      if(event.email.isEmpty || event.senha.isEmpty){
        emmit(LoginCloseLoadingState());
        if(event.email.isEmpty){
          emmit(LoginEmailEhObrigatorioState());
        }
        if(event.senha.isEmpty){
          emmit(LoginSenhaEhObrigatorioState());
        }
        return;
      }

      try{
        final response = await _authService.login(UserLoginDto(email: event.email, password: event.senha));
        emmit(LoginCloseLoadingState());
        if(response){
          emmit(LoginSuccessState());
        }
      } on Exception catch(e){
        emmit(LoginCloseLoadingState());
        emmit(LoginFailureState(message: e.toString()));
      }
   });
  }
}
