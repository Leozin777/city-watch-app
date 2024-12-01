import 'package:city_watch/bloc/profile_bloc/profile_event.dart';
import 'package:city_watch/bloc/profile_bloc/profile_state.dart';
import 'package:city_watch/data/models/interface/iprofile_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileService _profileService = injecaoDeDepencia<IProfileService>();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileBuscarDadosDoUsuario>((event, emit) async {
      try {
        final result = await _profileService.getProfile();
        emit(ProfileCarregadoSuccess(result));
      } on Exception catch (e) {
        emit(ProfileFailure(e.toString()));
      }
    });

    on<ProfileEditarDadosDoUsuario>((event, emit) async {
      try {
        await _profileService.updateProfile(event.userProfileDto);
        emit(ProfileEditadoSuccess());
      } on Exception catch (e) {
        emit(ProfileFailure(e.toString()));
      }
    });
  }
}
