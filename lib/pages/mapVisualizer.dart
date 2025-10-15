import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:geo_leaf/pages/addSymbol.dart';
import 'package:geo_leaf/provider/mapProvider.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geo_leaf/functions/numberF.dart';
import 'package:provider/provider.dart';

class MapVisualizer extends StatefulWidget {

  static const CameraPosition _nullIsland = CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 2,
  );

  MapVisualizer({super.key});

  @override
  State<MapVisualizer> createState() => MapVisualizerState();
  OverlayEntry? entry;




  void addWindow(BuildContext context) {
    entry = OverlayEntry(
      builder: (ctx) => Positioned(left: 40, right: 30, top: 50, child: Addsymbol()),
    );
    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }

  void removeWindow(BuildContext context)
  {
    entry?.remove();
    entry = null;
  }


}

class MapVisualizerState extends State<MapVisualizer> {
  MapLibreMapController? _mapController;
  bool canInteractWithMap = false;



  @override
  Widget build(BuildContext context) {

    var mapPr = Provider.of<MapProvider>(context);
    
    return MapLibreMap(
      initialCameraPosition: MapVisualizer._nullIsland,
      styleString: mapPr.style,
      onMapCreated: (controller) {
        _mapController = controller;
      },
      onMapLongClick: (point, coordinates) async {
        print(coordinates);
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: coordinates,
              zoom: 20.0,
              tilt: 0.0,
              bearing: 30.0,
            ),
          ),
        );
        widget.addWindow(context);
      },
      onStyleLoadedCallback: () async {
        if (_mapController != null) {
          await addGJson(_mapController);
        }
      },
    );
  }

  Future<void> addGJson(MapLibreMapController? controller) async {
    String js = await rootBundle.loadString("assets/json/mapRuas.geojson");
    String ln = await rootBundle.loadString("assets/json/lines.json");

    Map<String, dynamic> jsD = await json.decode(js);
    Map<String, dynamic> lines = await json.decode(ln);

    await controller!.addGeoJsonSource("buildings-source", jsD);
    await controller!.addGeoJsonSource("lines-source", lines);

    await controller.addFillExtrusionLayer(
      "buildings-source",
      "buildings-3d",
      FillExtrusionLayerProperties(
        fillExtrusionHeight: ['get', 'height'] ?? 0.1,
        fillExtrusionBase: 0,
        fillExtrusionColor: ['get', 'color'] ?? '#BFD738',
        fillExtrusionOpacity: 0.9,
        fillExtrusionVerticalGradient: true,
      ),
    );

    await controller.addLineLayer(
      "lines-source",
      "lines",
      LineLayerProperties(lineColor: '#F5F2F9', lineWidth: 12),
      belowLayerId: 'buildings-3d',
    );

    Map<String, Object> data = {"type": "FeatureCollection", "features": [
       
      ],
    };
    /*

 */
    for (var points in jsD['features']) {
      var properties = points['properties'];
      if (properties['exclude'] != null) continue;
      var localPoints = points['geometry']['coordinates'][0];
      final center = getCenter(localPoints);
      (data["features"] as List).add({
        "type": "Feature",
        "properties": {
          "name": properties['name'],
          "color": properties['color'],
        },
        "geometry": {"coordinates": center, "type": "Point"},
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
      minzoom: 18,
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
      minzoom: 18,
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
