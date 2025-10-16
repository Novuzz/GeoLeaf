import 'package:flutter/material.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/widgets/MapVisualizer.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';

class Addsymbol extends StatelessWidget {
  MapVisualizer map;
  String name = "";
  Addsymbol({super.key, required this.map});

  Future<void> _exit(MapProvider mapPr) async {
    map.removeWindow();
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
                mapPr.savePoint(name);
                await _exit(mapPr);
              },
            ),
          ],
        ),
      ),
    );
  }
}
