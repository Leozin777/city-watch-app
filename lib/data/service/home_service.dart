import 'dart:convert';

import 'package:city_watch/data/models/dtos/problema_request_dto.dart';
import 'package:city_watch/data/models/dtos/problema_response_dto.dart';
import 'package:city_watch/data/models/enums/e_http_method.dart';
import 'package:city_watch/data/models/interface/ihome_service.dart';
import 'package:city_watch/data/service/base_service.dart';

import '../../base_url_constante.dart';

class HomeService extends BaseService implements IHomeService {
  @override
  Future<List<ProblemaResponseDto>> getProblemas() async {
    final response = await makeRequest(url: "$baseUrl/problem", method: EHttpMethod.get);

    final data = jsonDecode(response!.body);
    final listaDeProblemasJson = data['data'] as List;

    if (listaDeProblemasJson.isEmpty) return [];

    final List<ProblemaResponseDto> listaDeProblemas =
        listaDeProblemasJson.map((problema) => ProblemaResponseDto.fromJson(problema)).toList();

    return listaDeProblemas;
  }

  @override
  criarProblema(ProblemaRequestDto problema) async {
    final response = await makeRequest(
      url: "$baseUrl/problem",
      method: EHttpMethod.post,
      parameters: problema.toJson(),
    );

    return response;
  }
}
