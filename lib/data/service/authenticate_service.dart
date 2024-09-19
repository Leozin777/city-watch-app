import 'dart:convert';

import 'package:city_watch/data/models/dtos/user_login_dto.dart';
import 'package:city_watch/data/models/dtos/user_register_dto.dart';
import 'package:city_watch/data/models/interface/iauthenticate_service.dart';
import 'package:city_watch/data/models/interface/ilocal_storage_helper.dart';
import 'package:city_watch/main.dart';
import 'package:http/http.dart' as http;

import '../../base_url_constante.dart';
import '../../utils/constants.dart';

class AuthenticateService implements IAuthenticateService {
  final ILocalStorageHelper _localStorageHelper = injecaoDeDepencia<ILocalStorageHelper>();

  @override
  Future<String> registerUser(UserRegisterDto user) async {
    try {
      final response = await http.post((Uri.parse("$baseUrl/auth/register")), body: {
        "name": user.name,
        "email": user.email,
        "password": user.password,
      }, headers: {
        'Content-Type': 'application/json'
      });

      final decodedJson = json.decode(response.body);
      return decodedJson['message'];
    } on Exception catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isAutheticated() async {
    final isAuth = await _localStorageHelper.getStringSecureStorage(keyTokenLogin);
    return isAuth != null;
  }

  @override
  Future<bool> login(UserLoginDto user) async {
    try {
      final response = await http.post((Uri.parse("$baseUrl/auth/login")), body: {
        "email": user.email,
        "password": user.password,
      }, headers: {
        'Content-Type': 'application/json'
      });

      final decodedJson = json.decode(response.body);
      final token = decodedJson['access_token'];

      if (token != null) {
        _localStorageHelper.setStringSecureStorage(keyTokenLogin, token);
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      rethrow;
    }
  }
}
