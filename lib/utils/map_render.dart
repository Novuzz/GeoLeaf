import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geo_leaf/functions/numberF.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

Future<void> addImageFromAsset(
  MapLibreMapController controller,
  String name,
  String assetName,
) async {
  final bytes = await rootBundle.load(assetName);
  final list = bytes.buffer.asUint8List();
  return controller.addImage(name, list);
}

Future<void> updatePlants(
  MapLibreMapController? controller, {
  Plant? id,
  bool delete = false,
}) async {
  print(delete);
  if (delete) {
    print("delete");
    await deletePlant(id!.id!, id.author!.id);
  }
  final plantGeojson = {'type': 'FeatureCollection', 'features': []};
  final plants = await getPlants();
  for (var plantMap in plants) {
    for (var plant in plantMap.registeredPlants!) {
      (plantGeojson["features"] as List).add({
        "type": "Feature",
        "properties": {"name": plant.name, "id": plant.id},
        "geometry": {
          "coordinates": [plant.longitude, plant.latitude],
          "type": "Point",
        },
      });
    }
  }
  await controller!.setGeoJsonSource("plants-source", plantGeojson);
}

Future<bool> addGJson(
  MapLibreMapController? controller,
  MapProvider? mapr,
) async {
  String js = await rootBundle.loadString("assets/json/mapRuas.geojson");
  Map<String, dynamic> jsD = await json.decode(js);

  String ln = await rootBundle.loadString("assets/json/lines.json");
  Map<String, dynamic> lines = await json.decode(ln);

  await controller!.addGeoJsonSource("buildings-source", jsD);
  await controller.addGeoJsonSource("lines-source", lines);
  await controller.addGeoJsonSource("user-source", {
    'type': 'FeatureCollection',
    'features': [],
  });

  await controller.addGeoJsonSource("plants-source", {
    'type': 'FeatureCollection',
    'features': [],
  });

  await updatePlants(controller);

  await controller.addFillExtrusionLayer(
    "buildings-source",
    "buildings-3d",
    FillExtrusionLayerProperties(
      fillExtrusionHeight: ['get', 'height'],
      fillExtrusionBase: 0,
      fillExtrusionColor: ['get', 'color'],
      fillExtrusionVerticalGradient: true,
      fillExtrusionOpacity: 0.9,
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
      "properties": {"name": properties['name'], "color": properties['color']},
      "geometry": {"coordinates": center, "type": "Point"},
    });
  }
  await controller.addGeoJsonSource("marker-source", data);
  await controller.addCircleLayer(
    "marker-source",
    "marker-layer",
    CircleLayerProperties(
      circleColor: ['get', 'color'],
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

  await addImageFromAsset(
    controller,
    'plant-marker',
    'assets/images/icons/geoleaf-marker.png',
  );

  //Adiciona a camada de plantas de textos das plantas
  await controller.addSymbolLayer(
    "plants-source",
    "plants-layer",
    SymbolLayerProperties(
      iconImage: "plant-marker",
      iconSize: 0.1,

      textField: ['get', 'name'],

      textSize: 14,
      textColor: '#ffffff',
      textHaloColor: ['get', 'color'],
      textHaloWidth: 1.5,
      textAnchor: 'top',
      textOffset: [0, 2.5],
      textAllowOverlap: true,
      textFont: ['Open Sans Regular', 'Arial Unicode MS Regular'],
    ),
    minzoom: 18,
    enableInteraction: true,
  );

  await controller.addCircleLayer(
    "user-source",
    "user-layer",
    CircleLayerProperties(
      circleColor: '#1671c4',
      circleRadius: 5,
      circleStrokeColor: '#ffffff',
      circleStrokeWidth: 4,
    ),
    minzoom: 0,
    enableInteraction: true,
  );

  await controller.moveCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(-23.548674724964076, -46.652320940886455),
        zoom: 17.0,
        tilt: 60.0, // pitch to see the extrusion
        bearing: 30.0, // rotate a bit
      ),
    ),
  );
  return true;
}
