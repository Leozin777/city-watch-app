import 'dart:async';

import 'package:camera/camera.dart';
import 'package:city_watch/data/models/dtos/problema_request_dto.dart';
import 'package:city_watch/data/models/enums/e_tipo_problema.dart';
import 'package:city_watch/helpers/calcula_distancia.dart';
import 'package:city_watch/helpers/popup_helper.dart';
import 'package:city_watch/views/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/home_bloc/home_bloc.dart';
import '../../bloc/home_bloc/home_event.dart';
import '../../bloc/home_bloc/home_state.dart';
import '../../data/models/tipo_problema_dto.dart';
import '../widgets/bottom_sheet_generico.dart';

class HomePage extends StatefulWidget {
  static String route = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<Position>? _locationSubscription;
  GoogleMapController? _mapController;
  late LatLng _initialPosition;
  bool myLocationButtonEnabled = false;
  bool myLocationEnabled = false;
  double latitude = 0;
  double longitude = 0;
  List<Marker> markers = [];
  late CameraController _cameraController;
  late TextEditingController _nomeDoProblemaController;
  late TextEditingController _descricaoDoProblemaController;
  Set<Circle> _rangeDoUsuario = {};
  List<TipoProblemaDto> tiposDeProblema = [
    TipoProblemaDto(tipoEnum: ETipoProblema.FaltaDeEnergia, nome: "Falta de energia"),
    TipoProblemaDto(tipoEnum: ETipoProblema.SaneamentoBasico, nome: "Saneamento básico"),
    TipoProblemaDto(tipoEnum: ETipoProblema.Infraestrutura, nome: "Infraestrutura"),
    TipoProblemaDto(tipoEnum: ETipoProblema.AreaDeRisco, nome: "Segurança"),
    TipoProblemaDto(tipoEnum: ETipoProblema.Outros, nome: "Outros"),
  ];

  @override
  void initState() {
    super.initState();
    _initialPosition = LatLng(latitude, longitude);
    _nomeDoProblemaController = TextEditingController();
    _descricaoDoProblemaController = TextEditingController();
    BlocProvider.of<HomeBloc>(context).add(HomeInitalEvent());
    _startLocationUpdates();
  }

  @override
  dispose() {
    _nomeDoProblemaController.dispose();
    _descricaoDoProblemaController.dispose();
    _locationSubscription?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;

          _rangeDoUsuario = {
            Circle(
              circleId: CircleId('userLocationCircle'),
              center: LatLng(latitude, longitude),
              radius: 70,
              fillColor: Colors.green[800]!.withOpacity(0.1),
              strokeColor: Colors.blue,
              strokeWidth: 1,
            ),
          };

          if (_mapController != null) {
            _mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
          }
        });
        BlocProvider.of<HomeBloc>(context).add(HomeBuscarProblemasEvent(latitude: latitude, longitude: longitude));
      }
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

  limpaControllers() {
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
    } on Exception {
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
    } on Exception {
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
            PopupHelper.fecharPopup(context);
          }

          if (state is HomeLocalizacaoDoUsuarioSuccessState) {
            setState(() {
              latitude = state.latitude;
              longitude = state.longitude;
              _mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
              myLocationButtonEnabled = true;
              myLocationEnabled = true;

              _rangeDoUsuario = {
                Circle(
                  circleId: CircleId('userLocationCircle'),
                  center: LatLng(latitude, longitude),
                  radius: 70,
                  // Radius in meters
                  fillColor: Colors.green[800]!.withOpacity(0.1),
                  strokeColor: Colors.blue,
                  strokeWidth: 1,
                ),
              };
            });

            BlocProvider.of<HomeBloc>(context).add(HomeBuscarProblemasEvent(latitude: latitude, longitude: longitude));
          }

          if (state is HomeProblemasSuccessState) {
            state.problemas.forEach((problema) async {
              final mark = Marker(
                  markerId: MarkerId(problema.nome),
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
                                    if (problema.foto!.isNotEmpty) Image.network(problema.foto!, width: 250, height: 250),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 100,
                                        ),
                                        Text(problema.nomeDoUsuario ?? "Teste"),
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
            PopupHelper.fecharPopup(context);

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

          if (state is HomeFailureState) {
            PopupHelper.fecharPopup(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red[700]!,
                content: Text(
                  state.message,
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
                onMapCreated: (GoogleMapController controller) async {
                  _mapController = controller;

                  String style = await rootBundle.loadString('assets/config/map-style.json');
                  _mapController!.setMapStyle(style);
                },
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                markers: markers.toSet(),
                onTap: (value) async {
                  if (!_clicouNoCirculo(value, LatLng(latitude, longitude), 70)) {
                    return;
                  }
                  TipoProblemaDto? tipoDeProblemaSelecionado;
                  final endereco = await retornaLocalizacaoDoUsuario(value.latitude, value.longitude);
                  String? caminhoDaFoto;

                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => BottomSheetGenerico(
                      widgetBottomSheet: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF388E3C),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Center(
                              child: Text(
                                "Cadastrar problema",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<TipoProblemaDto>(
                            value: tipoDeProblemaSelecionado,
                            items: tiposDeProblema
                                .map((TipoProblemaDto tipoDeProblema) => DropdownMenuItem<TipoProblemaDto>(
                                      value: tipoDeProblema,
                                      child: Text(tipoDeProblema.nome),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                tipoDeProblemaSelecionado = value as TipoProblemaDto;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Tipo de problema",
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: const InputDecoration(labelText: "Nome do problema"),
                            controller: _nomeDoProblemaController,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: const InputDecoration(labelText: "Descrição do problema"),
                            controller: _descricaoDoProblemaController,
                          ),
                          const SizedBox(height: 20),
                          Text(endereco),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: () async {
                              caminhoDaFoto = await tirarFoto();
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Adicione uma foto do problema"),
                                SizedBox(width: 8),
                                Icon(Icons.camera_alt),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  PopupHelper.fecharPopup(context);
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.arrow_back),
                                    SizedBox(width: 8),
                                    Text("Voltar"),
                                  ],
                                ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  BlocProvider.of<HomeBloc>(context).add(
                                    HomeCriarProblemaEvent(
                                      problema: ProblemaRequestDto(
                                        nome: _nomeDoProblemaController.text,
                                        descricao: _descricaoDoProblemaController.text,
                                        tipoDoProblema: tipoDeProblemaSelecionado!.tipoEnum,
                                        localizacao: endereco,
                                        foto: caminhoDaFoto,
                                        latitude: value.latitude,
                                        longitude: value.longitude,
                                      ),
                                    ),
                                  );
                                  limpaControllers();
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Cadastrar"),
                                    SizedBox(width: 8),
                                    Icon(Icons.check),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                  limpaControllers();
                },
                myLocationButtonEnabled: myLocationButtonEnabled,
                myLocationEnabled: myLocationEnabled,
                circles: _rangeDoUsuario,
              ),
            );
          },
        ),
      ),
    );
  }
}
