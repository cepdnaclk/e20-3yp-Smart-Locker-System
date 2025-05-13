import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:secure_x/utils/custom_app_bar.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body:content(),
    );
  }

  Widget content(){
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(7.25249899, 80.591330968),
        initialZoom: 11,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.doubleTapZoom
        )
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(markers: [
          Marker(
            point: LatLng(7.25249899, 80.591330968),
            width: 60,
            height: 60,
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.location_pin,
              size:60,
              color: Colors.red
            )
          )           
        ],
        )
          
        
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer=> TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // For demonstration only
  userAgentPackageName: 'dev.fleafleft.flutter_map.example',
);