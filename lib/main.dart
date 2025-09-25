import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geo_leaf/imagePicker.dart';
import 'package:geo_leaf/pages/mapVisualizer.dart';

const _nullIsland = CameraPosition(target: LatLng(0, 0), zoom: 4.0);
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:  MapLibre());
    /*MaterialApp(
      home: Scaffold(
        body: Center(child: Column(children: [Imagepicker(), MapVisualizer()])),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Text(
              "Geoleaf",
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );*/
  }
}

class MapLibre extends StatefulWidget {
  const MapLibre({super.key});

  @override
  State<MapLibre> createState() => _MapLibreState();
}

class _MapLibreState extends State<MapLibre> {
  final Completer<MapLibreMapController> mapController = Completer();
  bool canInteractWithMap = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapVisualizer()
    );
  }
  void _moveCameraToNullIsland() => mapController.future.then(
      (c) => c.animateCamera(CameraUpdate.newCameraPosition(_nullIsland)));
}

