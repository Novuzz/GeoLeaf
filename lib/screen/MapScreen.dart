import 'package:flutter/material.dart';
import 'package:geo_leaf/screen/CameraScreen.dart';
import 'package:geo_leaf/widgets/MapVisualizer.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    var mapPr = Provider.of<MapProvider>(context);
    final map = MapVisualizer();
    return Scaffold(
      body: map,
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CameraScreen()),
              );
            },
            icon: Icon(size: 64, Icons.camera_alt),
          ),
        ],
      ),
      floatingActionButton: Checkbox(
        value: mapPr.styleEnabled,
        onChanged: mapPr.changeStyle,
      ),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            map.removeWindow();
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
