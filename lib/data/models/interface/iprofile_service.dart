import 'package:city_watch/data/models/dtos/profile_edit_dto.dart';

abstract interface class IProfileService {
  Future<void> editarPerfil(String id, ProfileEditDto perfil);
}
