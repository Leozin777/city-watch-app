import 'dart:convert';

import 'package:city_watch/data/models/dtos/user_profile_edit_dto.dart';
import 'package:city_watch/data/models/dtos/user_profile_exibicao_dto.dart';
import 'package:city_watch/data/models/enums/e_http_method.dart';
import 'package:city_watch/data/models/interface/ilocal_storage_helper.dart';
import 'package:city_watch/data/models/interface/iprofile_service.dart';
import 'package:city_watch/data/service/base_service.dart';
import 'package:city_watch/helpers/staticos.dart';
import 'package:city_watch/main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../utils/constants.dart';

class ProfileService extends BaseService implements IProfileService {
  ILocalStorageHelper _localStorageHelper = injecaoDeDepencia<ILocalStorageHelper>();

  @override
  Future<UserProfileExibicaoDto> getProfile() async {
    final token = await _localStorageHelper.getStringSecureStorage(keyTokenLogin);
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String id = decodedToken['sub'];
    final response = await makeRequest(url: "${Staticos.baseUrl}/user/$id", method: EHttpMethod.get);
    final decodedJson = jsonDecode(response!.body);
    return UserProfileExibicaoDto.fromJson(decodedJson);
  }

  @override
  Future<void> updateProfile(UserProfileDto userDto) async {
    try {
      final token = await _localStorageHelper.getStringSecureStorage(keyTokenLogin);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      String id = decodedToken['sub'];
      await makeRequest(url: "${Staticos.baseUrl}/user/$id", parameters: userDto.toJson(), method: EHttpMethod.put);
    } on Exception catch (e) {
      rethrow;
    }
  }
}
