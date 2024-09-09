import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../pages/problems_page.dart';
import '../repositories/problems_repository.dart';
import '../widgets/problems_details.dart';

class ProblemsController extends ChangeNotifier{
  double lat = 0.0;
  double long = 0.0;
  String erro = '';
  Set<Marker> markers = Set<Marker>();
  late GoogleMapController _mapsController;


 // ProblemsController(){
 //   getPosicao();
 // }

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    loadProblems();
  }

  loadProblems() {
    final problems = ProblemsRepository().problems;
    problems.forEach((problems) async {
      markers.add(
        Marker(
          markerId: MarkerId(problems.nome),
          position: LatLng(problems.latitude, problems.longitude),
          icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            'images/problems.png',
          ),
          onTap: () => {
            showModalBottomSheet(
              context: appKey.currentState!.context,
              builder: (context) => ProblemsDetails(problems: problems),
            )
          },
        ),
      );
    });
    notifyListeners();
  }

  getPosicao() async{
    try{
      Position posicao = await _posicaoAtual();
      lat = posicao.latitude;
      long = posicao.longitude;
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch(e){
      erro = e.toString();
    }

    notifyListeners();
  }

  Future<Position> _posicaoAtual() async{
    LocationPermission permissao;

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if(! ativado){
      return Future.error('Por favor, habilite a localicação no smartphone');
    }

    permissao = await Geolocator.checkPermission();
    if(permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso a localização');
      }
    }

    if(permissao == LocationPermission.deniedForever){
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }
}