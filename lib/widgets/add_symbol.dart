import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/utils/gps.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/utils/map_render.dart';
import 'package:geo_leaf/widgets/map_visualizer.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Addsymbol extends StatefulWidget {
  final MapVisualizer map;
  final Function? onExit;
  final Function? onConfirm;
  final String? id;
  final List<dynamic>? name;
  Addsymbol({
    super.key,
    required this.map,
    this.onExit,
    this.onConfirm,
    this.id,
    this.name,
  });

  @override
  State<Addsymbol> createState() => _AddsymbolState();
}

class _AddsymbolState extends State<Addsymbol> {
  String value = "";

  @override
  Widget build(BuildContext context) {
    var mapPr = Provider.of<MapProvider>(context);
    var loginPr = Provider.of<LoginProvider>(context);

    return Card(
      child: SizedBox(
        child: Column(
          children: [
            BackButton(
              onPressed: () async {
                widget.onExit!();
              },
            ),
            Text(widget.name!.first),
            FloatingActionButton(
              onPressed: () async {
                final pos = await determinePosition();
                print(
                  await postPlant(
                    Plant(
                      name: widget.name!.first,
                      longitude: pos.longitude,
                      latitude: pos.latitude,
                      author: loginPr.logged,
                      image: null,
                    ),
                  ),
                );
                await updatePlants(mapPr.mapController);
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
