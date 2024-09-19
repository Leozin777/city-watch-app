import 'package:city_watch/bloc/auth_bloc/login_bloc/login_event.dart';
import 'package:city_watch/bloc/auth_bloc/login_bloc/login_state.dart';
import 'package:city_watch/data/models/interface/iauthenticate_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthenticateService _authService = injecaoDeDepencia<IAuthenticateService>();

  LoginBloc() : super(LoginInitialState()){
   on<LoginButtonPressedEvent>((event, emmit) async{
     emmit(LoginOpenLoadingState());
   });
  }
}
