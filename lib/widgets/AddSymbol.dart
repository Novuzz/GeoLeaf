import 'package:flutter/material.dart';
import 'package:geo_leaf/models/Plant.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/widgets/MapVisualizer.dart';
import 'package:provider/provider.dart';

class Addsymbol extends StatefulWidget {
  final MapVisualizer map;
  final Function? onExit;
  final String? id;
  Addsymbol({super.key, required this.map, this.onExit, this.id});
  @override
  State<Addsymbol> createState() => _AddsymbolState();
}

class _AddsymbolState extends State<Addsymbol> {
  String name = "";


  @override
  Widget build(BuildContext context) {
    var mapPr = Provider.of<MapProvider>(context);

    return Card(
      child: SizedBox(
        child: Column(
          children: [
            BackButton(
              onPressed: () async {
                if (widget.id == null) {
                  mapPr.removePoint();
                }
                widget.onExit!();
              },
            ),
            const Text("Flower"),
            TextField(onChanged: (value) => name = value),
            FloatingActionButton(
              onPressed: () async {
                if (widget.id == null) {
                  mapPr.savePoint(
                    Plant(
                      name: name,
                      createdTime: DateTime(2025),
                      editedTime: DateTime(2025),
                      author: null,
                    ),
                  );
                } else {
                  int i = 0;
                  for (var element in mapPr.plantsSource["features"] as List) {
                    if (element["id"] == widget.id) {
                      mapPr.plantsSource["features"][i]["properties"]["name"] = name;
                      
                      await mapPr.mapController!.setGeoJsonSource("plants-source", mapPr.plantsSource);
                      break;
                    }
                    i++;
                  }
                }
                widget.onExit!();
                //await _exit(mapPr);
              },
            ),
          ],
        ),
      ),
    );
  }
}
