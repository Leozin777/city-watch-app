import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../controllers/problems_controller.dart';

final appKey = GlobalKey();

class ProblemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Center(
          child: Text('CITY WATCH',
        style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        )
        )
      ),
      ),
      body: ChangeNotifierProvider<ProblemsController>(
        create: (context) => ProblemsController(),
        child: Builder(builder: (context) {
          final local = context.watch<ProblemsController>();

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(local.lat, local.long),
              zoom: 18,
            ),
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            myLocationEnabled: true,
            onMapCreated: local.onMapCreated,
            markers: local.markers,
          );
        }),
      ),
    );
  }
}