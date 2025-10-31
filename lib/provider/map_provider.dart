import 'package:flutter/material.dart';
import 'package:geo_leaf/models/Plant.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapProvider with ChangeNotifier {
  String style = "https://demotiles.maplibre.org/style.json";
  bool? styleEnabled = false;
  bool scrollEnabled = true;
  MapLibreMapController? mapController;
  BuildContext? context;
  LatLng userPosition = LatLng(0, 0);
  CameraPosition? lastPosition;
  Circle? userPoint;

  int selectedId = 0;

  Map<String, dynamic> plantsSource = {
    'type': 'FeatureCollection',
    'features': [],
  };

  void setScroll(bool scroll) {
    scrollEnabled = scroll;
    notifyListeners();
  }

  void changePosition(LatLng pos) async {
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 20.0, tilt: 0.0, bearing: 30.0),
      ),
    );
    notifyListeners();
  }

  void setUserPosition(LatLng coords) async {
    if (userPoint == null) {
      userPoint = await mapController!.addCircle(
        CircleOptions(
          circleColor: '#1671c4',
          circleRadius: 5,
          circleStrokeColor: '#ffffff',
          circleStrokeWidth: 4,
          geometry: coords,
        ),
      );
    } else {
      await mapController!.updateCircle(userPoint!, CircleOptions(
        circleColor: '#1671c4',
          circleRadius: 5,
          circleStrokeColor: '#ffffff',
          circleStrokeWidth: 4,
          geometry: coords,
      ));
    }
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
    features[selectedId]['properties'] = json; //['name'] = plant.name;
    features[selectedId]['id'] = json['id']; //['name'] = plant.name;
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
