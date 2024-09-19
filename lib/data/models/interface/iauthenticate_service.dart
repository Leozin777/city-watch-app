import 'package:city_watch/data/models/dtos/user_login_dto.dart';

import '../dtos/user_register_dto.dart';

abstract interface class IAuthenticateService {
  Future<bool> isAutheticated();

  Future<String> registerUser(UserRegisterDto user);

  Future<bool> login(UserLoginDto user);
}
