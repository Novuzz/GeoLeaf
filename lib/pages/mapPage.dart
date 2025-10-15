import 'package:flutter/material.dart';
import 'package:geo_leaf/pages/mapVisualizer.dart';
import 'package:geo_leaf/provider/mapProvider.dart';
import 'package:provider/provider.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {


  @override
  Widget build(BuildContext context) {
    var mapPr = Provider.of<MapProvider>(context);
    final map = MapVisualizer();
    return Scaffold(
      body: map,
      floatingActionButton: Checkbox(value: mapPr.styleEnabled, onChanged: mapPr.changeStyle),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            map.removeWindow(context);
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
