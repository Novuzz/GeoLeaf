import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/screen/drawer/account_drawer.dart';
import 'package:geo_leaf/screen/camera_screen.dart';
import 'package:geo_leaf/utils/map_render.dart';
import 'package:geo_leaf/widgets/logo_widget.dart';
import 'package:geo_leaf/widgets/map_visualizer.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/screen/drawer/plant_drawer.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Timer? _timer;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  final map = MapVisualizer();

  @override
  Widget build(BuildContext context) {
    final mapPr = Provider.of<MapProvider>(context);
    return Stack(
      children: [
        Scaffold(
          body: map,
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CameraScreen()),
                  );
                  await updatePlants(mapPr.mapController);
                },
                icon: Icon(size: 64, Icons.camera_alt),
              ),
              Builder(
                builder: (context) => IconButton(
                  iconSize: 64,
                  onPressed: () => _clickMenu(mapPr.mapController, context),
                  icon: Icon(Icons.yard),
                ),
              ),
              Builder(
                builder: (context) => IconButton(
                  iconSize: 64,
                  onPressed: () => _clickAccount(mapPr.mapController, context),
                  icon: Icon(Icons.person),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            title: LogoWidget(),
            centerTitle: true,
            automaticallyImplyLeading: true,
          ),
        ),

        if (_locked) ModalBarrier(dismissible: false),
      ],
    );
  }

  void _clickMenu(MapLibreMapController? mapController, BuildContext context) {
    if (!Navigator.canPop(context)) {
      Scaffold.of(context).showBottomSheet(
        (context) => PlantDrawer(onClick: (plant) => _clickPlant),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _clickAccount(MapLibreMapController? mapController, BuildContext context)
  {

    if (!Navigator.canPop(context)) {
      Scaffold.of(context).showBottomSheet(
        (context) => AccountDrawer(),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _clickPlant(
    MapLibreMapController mapController,
    BuildContext context,
    Plant plant,
  ) {
    Navigator.pop(context);
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(plant.latitude, plant.longitude), 20),
    );
  }
}
