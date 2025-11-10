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
  CameraPosition? lastPosition = CameraPosition(
    target: LatLng(-23.548177519867036, -46.65227339052233),
    zoom: 17.0,
    tilt: 60.0, // pitch to see the extrusion
    bearing: 30.0,
  );
  Circle? userPoint;

  int selectedId = 0;

  Map<String, dynamic> plantsSource = {
    'type': 'FeatureCollection',
    'features': [],
  };
  //Se falso o usuário não pode mover a camera, se verdadeiro pode
  void setScroll(bool scroll) {
    scrollEnabled = scroll;
    notifyListeners();
  }
  //muda a posição da camera
  void changePosition(LatLng pos) async {
    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 20.0, tilt: 0.0, bearing: 30.0),
      ),
    );
    notifyListeners();
  }
  //Muda a posição do usuário no mapa
  void setUserPosition(LatLng coords) async {
    await mapController!.setGeoJsonSource("user-source", {
      'type': 'FeatureCollection',
      'features': [
        {
          "type": "Feature",
          "geometry": {
            "coordinates": [coords.longitude, coords.latitude],
            "type": "Point",
          },
        },
      ],
    });
    notifyListeners();
  }
  //Atualiza o os pontos, use depois que adicionar ou quando quiser mostrar os pontos
  void update() async
  {
    await mapController!.setGeoJsonSource("plants-source", plantsSource);
    notifyListeners();

  }
  //Adiciona um ponto de planta no mapa dada as coordenadas
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
    update();
  }
  //O Adiciona o ponto apenas a primeiro momento adiciona o ponto mas não salva
  //E o savePoint salva dada o objeto
  void savePoint(Plant plant) async {
    final features = plantsSource['features'] as List;
    final json = plant.toProperties();
    features[selectedId]['properties'] = json; 
    features[selectedId]['id'] = json['id']; 
    await mapController!.setGeoJsonSource("plants-source", plantsSource);
    print("test");
  }
  //apenas remove o último ponto
  void removePoint() async {
    final features = plantsSource['features'] as List;
    features.removeLast();
    await mapController!.setGeoJsonSource("plants-source", plantsSource);
  }
  //Muda de estilo simples para detalhado
  void changeStyle(bool? toggle) {
    styleEnabled = toggle;
    styleEnabled!
        ? style = "https://tiles.openfreemap.org/styles/bright"
        : style = "https://demotiles.maplibre.org/style.json";
    notifyListeners();
  }
}
