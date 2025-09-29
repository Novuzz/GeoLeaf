import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapVisualizer extends StatefulWidget {
  final String _geoJsonId = '43f36e14-e3f5-43c1-84c0-50a9c80dc5c7';
  final String _layerId = 'buildings-3d';

  static const CameraPosition _nullIsland = CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 2,
  );

  const MapVisualizer({super.key});

  @override
  State<MapVisualizer> createState() => MapVisualizerState();
}

class MapVisualizerState extends State<MapVisualizer> {
  MapLibreMapController? _mapController;
  bool canInteractWithMap = false;

  @override
  Widget build(BuildContext context) {
    return MapLibreMap(
      initialCameraPosition: MapVisualizer._nullIsland,
      styleString: "https://tiles.openfreemap.org/styles/bright",
      onMapCreated: (controller) async {
        _mapController = controller;
        await addGJson(_mapController);
      },
    );
  }

  Future<void> addGJson(MapLibreMapController? controller) async {

    String js = await rootBundle.loadString("assets/json/newCoords.json");

    Map<String, dynamic> jsD = json.decode(js);

    await controller!.addGeoJsonSource("buildings-source", jsD);

    await controller!.addFillExtrusionLayer("buildings-source", "buildings-3d", 
      FillExtrusionLayerProperties(
        // fillExtrusionHeight can be an expression, here we read the 'height' property
        fillExtrusionHeight: 70,
        fillExtrusionBase: 0,
        fillExtrusionColor: '#aaaaaa',
        fillExtrusionOpacity: 0.9,
        // optional: vertical gradient for nicer look
        fillExtrusionVerticalGradient: true,
      ),
      // optional: show above other layers
      belowLayerId: null,
    );

    await controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(-23.548177519867036, -46.65227339052233),
          zoom: 17.0,
          tilt: 60.0, // pitch to see the extrusion
          bearing: 30.0, // rotate a bit
        ),
      ),
    );
  }
}
