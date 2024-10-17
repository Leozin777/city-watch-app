import 'package:camera/camera.dart';
import 'package:city_watch/data/models/dtos/problema_request_dto.dart';
import 'package:city_watch/data/models/dtos/problema_response_dto.dart';
import 'package:city_watch/data/models/enums/e_tipo_problema.dart';
import 'package:city_watch/helpers/calcula_distancia.dart';
import 'package:city_watch/views/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/home_bloc/home_bloc.dart';
import '../../bloc/home_bloc/home_event.dart';
import '../../bloc/home_bloc/home_state.dart';
import '../../data/models/tipo_problema_dto.dart';
import '../widgets/bottom_sheet_generico.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  static String route = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _mapController;
  late LatLng _initialPosition = LatLng(latitude, longitude);
  late dynamic iconDoUsuario;
  bool myLocationButtonEnabled = false;
  bool myLocationEnabled = false;
  double latitude = 0;
  double longitude = 0;
  List<Marker> markers = [];
  late CameraController _cameraController;
  late TextEditingController _nomeDoProblemaController;
  late TextEditingController _descricaoDoProblemaController;
  Set<Marker> _userMarker = {};
  List<TipoProblemaDto> tiposDeProblema = [
    TipoProblemaDto(tipoEnum: ETipoProblema.FaltaDeEnergia, nome: "Falta de energia"),
    TipoProblemaDto(tipoEnum: ETipoProblema.SaneamentoBasico, nome: "Saneamento básico"),
    TipoProblemaDto(tipoEnum: ETipoProblema.Infraestrutura, nome: "Infraestrutura"),
    TipoProblemaDto(tipoEnum: ETipoProblema.AreaDeRisco, nome: "Segurança"),
    TipoProblemaDto(tipoEnum: ETipoProblema.Outros, nome: "Outros"),
  ];

  @override
  void initState() {
    _nomeDoProblemaController = TextEditingController();
    _descricaoDoProblemaController = TextEditingController();
    BlocProvider.of<HomeBloc>(context).add(HomeInitalEvent());
    _startLocationUpdates();
    super.initState();
  }

  @override
  dispose() {
    _nomeDoProblemaController.dispose();
    _descricaoDoProblemaController.dispose();
    super.dispose();
  }

  Future<void> _startLocationUpdates() async {
    iconDoUsuario = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/icons/navigation.png",
    );

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen((Position position) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;


        _userMarker = {
          Marker(
            markerId: MarkerId('userLocationMarker'),
            position: LatLng(latitude, longitude),
            icon: iconDoUsuario,
          ),
        };

        _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
      });
    });
  }

  inicializandoCamera() async {
    final cameras = await availableCameras();
    final cameraTraseira = cameras[1];

    _cameraController = CameraController(cameraTraseira, ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
    });
  }

  limpaControllesrs() {
    _nomeDoProblemaController.clear();
    _descricaoDoProblemaController.clear();
  }

  Future<String?> tirarFoto() async {
    try {
      await inicializandoCamera();
      final foto = await _cameraController.takePicture();

      if (!mounted) return null;

      _cameraController.dispose();
      return foto.path;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<String> retornaLocalizacaoDoUsuario(double lat, double lang) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}";
      }
    } on Exception catch (e) {
      return 'Endereço não encontrado';
    }
    return 'Endereço não encontrado';
  }

  bool _clicouNoCirculo(LatLng point, LatLng center, double radius) {
    final double distance = CalculaDistancia().calculaDistancia(point, center);
    return distance <= radius;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeOpenLoadingState) {
            showDialog(context: context, builder: (_) => const LoadingWidget());
          }

          if (state is HomeCloseLoadingState) {
            Navigator.of(context).pop();
          }

          if (state is HomeLocalizacaoDoUsuarioSuccessState) {
            setState(() {
              latitude = state.latitude;
              longitude = state.longitude;
              _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
              myLocationButtonEnabled = true;
              myLocationEnabled = true;

              // Atualiza o marcador com o ícone de navegação verde
              _userMarker = {
                Marker(
                  markerId: MarkerId('userLocationMarker'),
                  position: LatLng(latitude, longitude),
                  icon: iconDoUsuario, // Ícone de navegação verde
                ),
              };
            });

            BlocProvider.of<HomeBloc>(context).add(HomeBuscarProblemasEvent(latitude: latitude, longitude: longitude));
          }

          if (state is HomeProblemasSuccessState) {
            state.problemas.forEach((problema) async {
              final mark = Marker(
                  markerId: MarkerId(problema.id.toString()),
                  position: LatLng(problema.latitude, problema.longitude),
                  icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/icons/danger.png"),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("${problema.nome}, ${problema.endereco}"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(problema.descricao ?? ''),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(problema.likes.toString()),
                                        const SizedBox(width: 10),
                                        Icon(
                                          Icons.thumb_up,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Row(
                                      children: [
                                        Text(problema.deslikes.toString()),
                                        const SizedBox(width: 10),
                                        Icon(
                                          Icons.thumb_down,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(problema.foto!, width: 250, height: 250),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 100,
                                        ),
                                        Text(problema.nomeDoUsuario),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  });

              setState(() {
                markers.add(mark);
              });
            });
          }

          if (state is HomeCriarProblemaSuccessState) {
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green[700]!,
                content: const Text(
                  "Problema cadastrado com sucesso",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return SafeArea(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 18,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                markers: markers.toSet()..addAll(_userMarker),
              ),
            );
          },
        ),
      ),
    );
  }
}
