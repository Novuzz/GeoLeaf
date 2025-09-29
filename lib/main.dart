import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_leaf/pages/mapPage.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geo_leaf/imagePicker.dart';
import 'package:geo_leaf/pages/mapVisualizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Column(
            children: [
              Imagepicker(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Mappage()),
                  );
                },
                child: Text("Open Map"),
              ),
            ],
          ),
        ),
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
    );
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
    return Scaffold(body: MapVisualizer());
  }
}
