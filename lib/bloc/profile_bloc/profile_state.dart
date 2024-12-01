import 'package:city_watch/data/models/dtos/user_profile_exibicao_dto.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure(this.error);
}

class ProfileEditadoSuccess extends ProfileState {}

class ProfileCarregadoSuccess extends ProfileState {
  final UserProfileExibicaoDto userProfileExibicaoDto;

  ProfileCarregadoSuccess(this.userProfileExibicaoDto);
}
