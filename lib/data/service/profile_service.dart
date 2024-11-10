import 'package:city_watch/data/models/dtos/profile_edit_dto.dart';
import 'package:city_watch/data/models/enums/e_http_method.dart';
import 'package:city_watch/data/service/base_service.dart';

import '../../base_url_constante.dart';
import '../models/interface/iprofile_service.dart';

class ProfileService extends BaseService implements IProfileService {
  @override
  Future<void> editarPerfil(String id, ProfileEditDto perfil) async {
    final response = await makeRequest(
      url: "$baseUrl/user/$id",
      method: EHttpMethod.put,
      parameters: perfil.toJson(),
    );

    if (response == null) {
      throw Exception("Erro ao atualizar o perfil");
    }
  }
}
