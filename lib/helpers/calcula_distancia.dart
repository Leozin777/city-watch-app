import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class CalculaDistancia{

  double calculaDistancia(LatLng point1, LatLng point2) {
    const double raioDaTerraEmMetros = 6371000;
    final double dLat = _grauParaRadianos(point2.latitude - point1.latitude);
    final double dLng = _grauParaRadianos(point2.longitude - point1.longitude);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_grauParaRadianos(point1.latitude)) * math.cos(_grauParaRadianos(point2.latitude)) *
            math.sin(dLng / 2) * math.sin(dLng / 2);
    final num c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return raioDaTerraEmMetros * c;
  }

  static double calculateDistanceEntreDoisPontos(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    final double dLat = _grauParaRadianos(lat2 - lat1);
    final double dLon = _grauParaRadianos(lon2 - lon1);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_grauParaRadianos(lat1)) * cos(_grauParaRadianos(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }


  static double _grauParaRadianos(double degrees) {
    return degrees * math.pi / 180;
  }
}