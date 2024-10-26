import 'dart:convert';

import 'package:city_watch/data/models/enums/e_http_method.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../helpers/authenticated_http.dart';

class BaseService {
  final AutheticatedHttp _autheticatedHttp = AutheticatedHttp(http.Client());

  Future<Response> makeRequest(
      {required String url,
      Map<String, dynamic>? parameters,
      required EHttpMethod method}) async {
    switch (method) {
      case EHttpMethod.get:
        {
          try {
            return await _autheticatedHttp.get(Uri.parse(url),
                headers: {'Content-Type': 'application/json'});
          } catch (e) {
            rethrow;
          }
        }
      case EHttpMethod.post:
        {
          try {
            return await _autheticatedHttp.post(Uri.parse(url),
                body: json.encode(parameters),
                headers: {'Content-Type': 'application/json'});
          } catch (e) {
            rethrow;
          }
        }

      case EHttpMethod.put:
        try {
          return await _autheticatedHttp.put(Uri.parse(url),
              body: parameters, headers: {'Content-Type': 'application/json'});
        } catch (e) {
          rethrow;
        }
      case EHttpMethod.delete:
        try {
          return await _autheticatedHttp.put(Uri.parse(url),
              body: parameters, headers: {'Content-Type': 'application/json'});
        } catch (e) {
          rethrow;
        }
    }
  }
}
