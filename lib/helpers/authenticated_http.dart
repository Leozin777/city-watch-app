import 'package:city_watch/data/models/interface/ilocal_storage_helper.dart';
import 'package:city_watch/main.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class AutheticatedHttp extends http.BaseClient {
  final _localStorage = injecaoDeDepencia<ILocalStorageHelper>();
  final http.Client _client;

  AutheticatedHttp(this._client);

  Future<String?> getToken() async {
    return await _localStorage.getStringSecureStorage(keyTokenLogin);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    String? token = await getToken();

    request.headers['Authorization'] = 'Bearer $token';
    return _client.send(request);
  }
}
