import 'package:city_watch/data/models/dtos/user_profile_edit_dto.dart';

abstract class ProfileEvent {}

class ProfileEditarDadosDoUsuario extends ProfileEvent {
  final UserProfileDto userProfileDto;

  ProfileEditarDadosDoUsuario(this.userProfileDto);
}

class ProfileBuscarDadosDoUsuario extends ProfileEvent {}
