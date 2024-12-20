import 'dart:convert';

import 'package:city_watch/data/models/dtos/problema_request_dto.dart';
import 'package:city_watch/data/models/dtos/problema_response_dto.dart';
import 'package:city_watch/data/models/enums/e_http_method.dart';
import 'package:city_watch/data/models/interface/ihome_service.dart';
import 'package:city_watch/data/service/base_service.dart';
import '../../helpers/staticos.dart';
import '../models/dtos/problem_details_dto.dart';

class HomeService extends BaseService implements IHomeService {
  @override
  Future<List<ProblemaResponseDto>> getProblemas() async {
    try {
      final response = await makeRequest(url: "${Staticos.baseUrl}/problem", method: EHttpMethod.get);

      final data = jsonDecode(response!.body);
      final listaDeProblemasJson = data['data'] as List;

      if (listaDeProblemasJson.isEmpty) return [];

      final List<ProblemaResponseDto> listaDeProblemas =
          listaDeProblemasJson.map((problema) => ProblemaResponseDto.fromJson(problema)).toList();

      return listaDeProblemas;
    } on Exception catch (e) {
      rethrow;
    }
  }

  @override
  criarProblema(ProblemaRequestDto problema) async {
    try {
      final response = await makeRequest(
        url: "${Staticos.baseUrl}/problem",
        method: EHttpMethod.post,
        parameters: problema.toJson(),
      );

      return response;
    } on Exception catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProblemDetailsDto> buscarDetalhesDoProblema(String idProblema) async {
    try {
      final response = await makeRequest(url: "${Staticos.baseUrl}/problem/$idProblema/detail", method: EHttpMethod.get);
      final data = jsonDecode(response!.body);
      final problema = ProblemDetailsDto.fromJson(data);
      return problema;
    } catch (e) {
      rethrow;
    }
  }
}
