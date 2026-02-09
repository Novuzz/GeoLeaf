import 'package:flutter/material.dart';
import 'package:geo_leaf/models/Plant.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/utils/Gps.dart';
import 'package:geo_leaf/utils/HttpRequest.dart';
import 'package:geo_leaf/utils/MapRender.dart';
import 'package:geo_leaf/widgets/MapVisualizer.dart';
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
