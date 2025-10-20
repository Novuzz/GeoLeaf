import 'package:flutter/material.dart';
import 'package:geo_leaf/models/Plant.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/widgets/MapVisualizer.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';

class Addsymbol extends StatefulWidget {

  final MapVisualizer map;
  Addsymbol({super.key, required this.map});
  @override
  State<Addsymbol> createState() => _AddsymbolState();
}

class _AddsymbolState extends State<Addsymbol> {

  String name = "";

  Future<void> _exit(MapProvider mapPr) async {
    widget.map.removeWindow();
    await mapPr.mapController!.animateCamera(
      CameraUpdate.newCameraPosition(mapPr.lastPosition!),
    );
    mapPr.setScroll(true);
  }

  @override
  Widget build(BuildContext context) {
    var mapPr = Provider.of<MapProvider>(context);

    return Card(
      child: SizedBox(
        child: Column(
          children: [
            BackButton(
              onPressed: () async {
                mapPr.removePoint();
                await _exit(mapPr);
              },
            ),
            const Text("Flower"),
            TextField(onChanged: (value) => name = value),
            FloatingActionButton(
              onPressed: () async {
                mapPr.savePoint(Plant(name: name, createdTime: DateTime(2025), editedTime: DateTime(2025), author: null));
                await _exit(mapPr);
              },
            ),
          ],
        ),
      ),
    );
  }
}
