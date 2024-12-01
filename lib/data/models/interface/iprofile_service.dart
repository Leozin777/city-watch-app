import '../dtos/user_profile_edit_dto.dart';
import '../dtos/user_profile_exibicao_dto.dart';

abstract interface class IProfileService {
  Future<UserProfileExibicaoDto> getProfile();

  Future<void> updateProfile(UserProfileDto userDto);
}
