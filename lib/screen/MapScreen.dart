import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_leaf/screen/CameraScreen.dart';
import 'package:geo_leaf/widgets/AddSymbol.dart';
import 'package:geo_leaf/widgets/MapVisualizer.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';
import 'package:geo_leaf/utils/Gps.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      takePos(context);
      _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
        final pos = await determinePosition();
        if (!mounted) return;
        Provider.of<MapProvider>(
          context,
          listen: false,
        ).setUserPosition(LatLng(pos.latitude, pos.longitude));
        print("Pos: ${pos.latitude}, ${pos.longitude}");
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  final map = MapVisualizer();

  @override
  Widget build(BuildContext context) {
    var mapPr = Provider.of<MapProvider>(context);

    return Stack(
      children: [
        Scaffold(
          body: map,
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CameraScreen()),
                  );
                  if (result != null) {
                    final pos = await determinePosition();

                    if (context.mounted) {
                      _locked = true;
                      mapPr.addPoint(LatLng(pos.latitude, pos.longitude));
                    }
                  }
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
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.green,
          ),
        ),
        if (_locked) ModalBarrier(dismissible: false),
        if (_locked)
          Positioned(
            left: 40,
            right: 30,
            top: 50,
            child: Addsymbol(
              map: map,
              onExit: () {
                setState(() {
                  _locked = false;
                });
              },
            ),
          ),
      ],
    );
  }

  Future<void> takePos(BuildContext mapPr) async {
    final pos = await determinePosition();
    if (!mounted) return;
    Provider.of<MapProvider>(
      context,
      listen: false,
    ).changePosition(LatLng(pos.latitude, pos.longitude));
    //print("Pos: ${pos.latitude}, ${pos.longitude}");
  }
}
