import 'package:city_watch/data/models/dtos/problema_request_dto.dart';
import 'package:city_watch/data/models/dtos/problema_response_dto.dart';
import 'package:city_watch/data/models/dtos/qtd_problema_dto.dart';

abstract interface class IProblemaService {
  Future<QtdProblemaDto> getProblemas();
}