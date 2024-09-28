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
    return BlocListener<HomeBloc, HomeState>(
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
          setState(() {
            markers = state.problemas
                .map((e) => Marker(
                      markerId: MarkerId(e.id.toString()),
                      position: LatLng(e.latitude, e.longitude),
                      infoWindow: InfoWindow(
                        title: e.nome,
                        snippet: e.descricao,
                      ),
                    ))
                .toList();
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
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              markers: markers.toSet(),
              myLocationButtonEnabled: myLocationButtonEnabled,
              myLocationEnabled: myLocationEnabled,
            ),
          );
        },
      ),
    );
  }
}
