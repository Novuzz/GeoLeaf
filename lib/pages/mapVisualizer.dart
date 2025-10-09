import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geo_leaf/functions/numberF.dart';

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
      styleString: "https://demotiles.maplibre.org/style.json",
      onMapCreated: (controller)  {
        _mapController = controller;
      },
      onStyleLoadedCallback: () async {
        if (_mapController != null) {
          await addGJson(_mapController);
        }
      },
    );
  }

  Future<void> addGJson(MapLibreMapController? controller) async {
    String js = await rootBundle.loadString("assets/json/map.geojson");

    Map<String, dynamic> jsD = await json.decode(js);

    await controller!.addGeoJsonSource("buildings-source", jsD);

    await controller.addFillExtrusionLayer(
      "buildings-source",
      "buildings-3d",
      FillExtrusionLayerProperties(
        fillExtrusionHeight: ['get', 'height'] ?? 0,
        fillExtrusionBase: 0,
        fillExtrusionColor: ['get', 'color'] ?? '#BFD738',
        fillExtrusionOpacity: 0.9,
        fillExtrusionVerticalGradient: true,
      ),
    );

    Map<String, Object> data = {"type": "FeatureCollection", "features": [
       
      ],
    };
    /*

 */
    for (var points in jsD['features']) {
      var localPoints = points['geometry']['coordinates'][0];
      final center = getCenter(localPoints );
      var properties = points['properties'];
      (data["features"] as List).add({
        "type": "Feature",
        "properties": {"name": properties['name'], "color": properties['color']},
        "geometry": {
          "coordinates": center,
          "type": "Point",
        },
      });
    }
    await controller.addGeoJsonSource("marker-source", data);

    await controller.addCircleLayer(
      "marker-source",
      "marker-layer",
      CircleLayerProperties(
        circleColor: ['get', 'color'] ?? "#ff0000",
        circleRadius: 8.0,
        circleStrokeWidth: 2.0,
        circleStrokeColor: "#ffffff",
      ),
    );

    await controller.addSymbolLayer(
      "marker-source",
      "points_layer",
      SymbolLayerProperties(
        textField: ['get', 'name'],

        textSize: 14,
        textColor: '#ffffff',
        textHaloColor: ['get', 'color'],
        textHaloWidth: 1.5,
        textAnchor: 'top',
        textOffset: [0, 1.5],
        textAllowOverlap: true,
        textFont: ['Open Sans Regular', 'Arial Unicode MS Regular'],
      ),
      minzoom: 18
    );
    /*
    */
    await controller.animateCamera(
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
