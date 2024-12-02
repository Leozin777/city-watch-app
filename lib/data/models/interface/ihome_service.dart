import 'package:city_watch/data/models/dtos/problema_request_dto.dart';
import 'package:city_watch/data/models/dtos/problema_response_dto.dart';

import '../dtos/problem_details_dto.dart';

abstract interface class IHomeService {
  Future<List<ProblemaResponseDto>> getProblemas();

  criarProblema(ProblemaRequestDto problema);

  Future<ProblemDetailsDto> buscarDetalhesDoProblema(String idProblema);
}
