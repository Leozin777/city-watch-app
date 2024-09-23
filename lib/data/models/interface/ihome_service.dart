import 'package:city_watch/data/models/dtos/problema_dto.dart';

abstract interface class IHomeService{
  Future<List<ProblemaDto>> getProblemas();
}