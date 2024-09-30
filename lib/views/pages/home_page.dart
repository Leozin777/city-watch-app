import 'package:city_watch/views/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/home_bloc/home_bloc.dart';
import '../../bloc/home_bloc/home_event.dart';
import '../../bloc/home_bloc/home_state.dart';

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

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(HomeInitalEvent());
    super.initState();
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
            });
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
                markers: markers.toSet(),
                myLocationButtonEnabled: myLocationButtonEnabled,
                myLocationEnabled: myLocationEnabled,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.teal[900],
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
