import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
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
        //await addGJson(_mapController);
      },
      onStyleLoadedCallback: () async {
        if (_mapController != null) {
          await addGJson(_mapController);
        }
        /*
         
         */
      },
    );
  }

  Future<void> addGJson(MapLibreMapController? controller) async {
    String js = await rootBundle.loadString("assets/json/map.geojson");

    Map<String, dynamic> jsD = await json.decode(js);

    await controller!.addGeoJsonSource("buildings-source", jsD);
    final byteData = await rootBundle.load("assets/icon.png");
    await controller.addImage("iconHolder", byteData.buffer.asUint8List());

    /*
    */
    /*
    await _mapController?.addSymbol(
      SymbolOptions(
        geometry: LatLng(-23.548177519867036, -46.65227339052233),
        iconImage: "iconHolder",
        iconSize: 0.2,
      ),
    );
    */
    await controller.addFillExtrusionLayer(
      "buildings-source",
      "buildings-3d",
      FillExtrusionLayerProperties(
        // fillExtrusionHeight can be an expression, here we read the 'height' property
        fillExtrusionHeight: ['get', 'height'] ?? 0,
        fillExtrusionBase: 0,
        fillExtrusionColor: ['get', 'color'] ?? '#BFD738',
        fillExtrusionOpacity: 0.9,
        // optional: vertical gradient for nicer look
        fillExtrusionVerticalGradient: true,
      ),
      // optional: show above other layers
      belowLayerId: null,
    );

    Map<String, Object> data = {
      "type": "FeatureCollection",
      "features": [
       
      ],
    };
/*

 */
   for (var points in jsD['features']) {
      var localPoints = points['geometry']['coordinates'][0];
      double x = 0.0;
      double y = 0.0;
      int n = localPoints.length;
      for(var p in localPoints)
      {
        x += (p[0] as double);
        y += (p[1] as double);
      }
      x /= n;
      y /= n;
      var color = points['properties']['color'];
      (data["features"] as List).add({
        "type": "Feature",
        "properties": 
        {
          "color": color
        },
        "geometry": {
          "coordinates": [x, y],
          "type": "Point",
        },
      });
    
    }
    /*
    (data["features"] as List).add({
      "type": "Feature",
      "properties": {},
      "geometry": {
        "coordinates": [-46.651471612718495, -23.546917037871992],
        "type": "Point",
      },
    });
*/
    print(data["features"]);
    await controller.addGeoJsonSource("marker-source", data);

    await controller!.addCircleLayer(
      "marker-source",
      "marker-layer",
      CircleLayerProperties(
        circleColor: ['get', 'color'] ?? "#ff0000",
        circleRadius: 8.0,
        circleStrokeWidth: 2.0,
        circleStrokeColor: "#ffffff",
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
  }
}
