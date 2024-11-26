import 'dart:convert';

import 'package:city_watch/data/models/dtos/qtd_problema_dto.dart';

import '../../base_url_constante.dart';
import '../models/enums/e_http_method.dart';
import '../models/interface/iproblems_service.dart';
import 'base_service.dart';

class ProblemaService extends BaseService implements IProblemaService{
  @override
  Future<QtdProblemaDto> getProblemas() async {

    try {
      final response = await makeRequest(url: "$baseUrl/problem", method: EHttpMethod.get);
      final data = jsonDecode(response!.body);
      return QtdProblemaDto.fromJson(data);
    } on Exception catch (e) {
      rethrow;
    }
  }
}