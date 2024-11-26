import 'dart:ffi';

import 'package:city_watch/data/models/dtos/problema_response_dto.dart';

class QtdProblemaDto{
  final int size;
  final List<ProblemaResponseDto> data;
  
  const QtdProblemaDto({required this.data, required this.size});
  
  factory QtdProblemaDto.fromJson(Map<String, dynamic> json){
    final listaDeProblemasJson = json['data'] as List;
    List<ProblemaResponseDto>listaDeProblemas = listaDeProblemasJson.map((problema) => ProblemaResponseDto.fromJson(problema)).toList();
    return QtdProblemaDto(
        data: listaDeProblemas,
        size: json['size'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson(){
    return{
      'data': data,
      'size': size,
    };
  }
}