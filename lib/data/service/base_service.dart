import 'dart:convert';

import 'package:city_watch/data/models/enums/e_http_method.dart';
import 'package:city_watch/views/pages/auth_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../helpers/authenticated_http.dart';
import '../../main.dart';

class BaseService {
  final AutheticatedHttp _autheticatedHttp = AutheticatedHttp(http.Client());

  Future<Response?> makeRequest({required String url, Map<String, dynamic>? parameters, required EHttpMethod method}) async {
    switch (method) {
      case EHttpMethod.get:
        {
          try {
            final response = await _autheticatedHttp.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

            final result = trataResponseApi(response);

            if (result) {
              return response;
            } else {
              return null;
            }
          } catch (e) {
            rethrow;
          }
        }
      case EHttpMethod.post:
        {
          try {
            final response =
                await _autheticatedHttp.post(Uri.parse(url), body: json.encode(parameters), headers: {'Content-Type': 'application/json'});

            final result = trataResponseApi(response);

            if (!result) {
              return response;
            } else {
              return null;
            }
          } catch (e) {
            rethrow;
          }
        }

      case EHttpMethod.put:
        try {
          final response = await _autheticatedHttp.put(Uri.parse(url), body: parameters, headers: {'Content-Type': 'application/json'});
          final result = trataResponseApi(response);
          if (!result) {
            return response;
          } else {
            return null;
          }
        } catch (e) {
          rethrow;
        }
      case EHttpMethod.delete:
        try {
          return await _autheticatedHttp.put(Uri.parse(url), body: parameters, headers: {'Content-Type': 'application/json'});
        } catch (e) {
          rethrow;
        }
    }
  }

  bool trataResponseApi(Response response) {
    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamedAndRemoveUntil(LoginPage.route, (route) => false);
        return false;
      }

      Map<String, dynamic> responseBody = json.decode(response.body);
      final mensagens = responseBody['message'] as List;
      List<String> erros = mensagens.map((e) => e.toString()).toList();
      throw Exception(erros);
    }
    return true;
  }
}
