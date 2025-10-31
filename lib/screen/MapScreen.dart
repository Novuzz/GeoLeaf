import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_leaf/screen/CameraScreen.dart';
import 'package:geo_leaf/widgets/MapVisualizer.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      takePos(context);
      _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
        final pos = await _determinePosition();
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

  Future<void> takePos(BuildContext mapPr) async {
    final pos = await _determinePosition();
    Provider.of<MapProvider>(
      context,
      listen: false,
    ).changePosition(LatLng(pos.latitude, pos.longitude));
    print("Pos: ${pos.latitude}, ${pos.longitude}");
  }

  Future<Position> _determinePosition() async {
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
