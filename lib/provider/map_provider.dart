import 'package:flutter/material.dart';
import 'package:geo_leaf/models/Plant.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapProvider with ChangeNotifier {
  String style = "https://demotiles.maplibre.org/style.json";
  bool? styleEnabled = false;
  bool scrollEnabled = true;
  MapLibreMapController? mapController;
  BuildContext? context;
  CameraPosition? lastPosition;

  int selectedId = 0;

  Map<String, dynamic> plantsSource = {
    'type': 'FeatureCollection',
    'features': [],
  };

  void setScroll(bool scroll) {
    scrollEnabled = scroll;
    notifyListeners();
  }

  void addPoint(LatLng coords) async {
    final template = {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "coordinates": [coords.longitude, coords.latitude],
        "type": "Point",
      },
    };
    final features = (plantsSource['features'] as List);
    features.add(template);
    selectedId = features.length - 1;
    await mapController!.setGeoJsonSource("plants-source", plantsSource);
    notifyListeners();
  }

  void savePoint(Plant plant) async {
    final features = plantsSource['features'] as List;
    final json = plant.toProperties();
    features[selectedId]['properties'] = json;//['name'] = plant.name;
    features[selectedId]['id'] = json['id'];//['name'] = plant.name;
    await mapController!.setGeoJsonSource("plants-source", plantsSource);
    print("test");
  }

  void removePoint() async {
    final features = plantsSource['features'] as List;
    features.removeLast();
    await mapController!.setGeoJsonSource("plants-source", plantsSource);
  }

  void changeStyle(bool? toggle) {
    styleEnabled = toggle;
    styleEnabled!
        ? style = "https://tiles.openfreemap.org/styles/bright"
        : style = "https://demotiles.maplibre.org/style.json";
    notifyListeners();
  }
}
