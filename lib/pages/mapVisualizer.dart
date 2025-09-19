import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapVisualizer extends StatefulWidget {
  final String _geoJsonId = 'buildings-source';
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
    return Expanded(
      child: MapLibreMap(
        styleString: "https://demotiles.maplibre.org/style.json",
        onMapCreated: (controller) async {
          _mapController = controller;
          final geojson = {
            "type": "FeatureCollection",
            "features": [
              {
                "type": "Feature",
                "properties": {"height": 60},
                "geometry": {
                  "type": "Polygon",
                  "coordinates": [
                    [
                      [-74.0066, 40.7135],
                      [-74.0060, 40.7135],
                      [-74.0060, 40.7139],
                      [-74.0066, 40.7139],
                      [-23.548177519867036, -46.65227339052233],
                    ],
                  ],
                },
              },
            ],
          };

          await _mapController!.addGeoJsonSource(widget._geoJsonId, geojson);

          await _mapController!.addFillExtrusionLayer(
            widget._geoJsonId,
            widget._layerId,
            FillExtrusionLayerProperties(
              fillExtrusionHeight: ['get', 'height'],
              fillExtrusionBase: 0,
              fillExtrusionColor: '#aaaaaa',
              fillExtrusionOpacity: 0.9,
              // optional: vertical gradient for nicer look
              fillExtrusionVerticalGradient: true,
            ),
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
        },
        initialCameraPosition: MapVisualizer._nullIsland,
        onStyleLoadedCallback: () => setState(() => canInteractWithMap = true),
      ),
    );
  }

  void _moveCameraToNullIsland() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(MapVisualizer._nullIsland),
      );
    }
  }
}
