import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
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

Future<String> getClosestLocation(LatLng position) async
{
  String js = await rootBundle.loadString("assets/json/mapRuas.geojson");
  Map<String, dynamic> jsD = await json.decode(js);
  
  double minDistance = double.infinity;
  String closestBuilding = "";
  
  for(final feature in jsD["features"])
  {
    final buildingName = feature["properties"]["name"] ?? "Unknown";
    
    for(final coords in feature["geometry"]["coordinates"][0])
    {
      final distance = sqrt(pow(coords[0] - position.longitude, 2) + pow(coords[1] - position.latitude, 2));
      if(distance < minDistance)
      {
        minDistance = distance;
        closestBuilding = "$buildingName";
      }
    }
  }
  
  return closestBuilding;
}


Future<LatLng> determineLatLng() async {
  final pos = await determinePosition();
  return LatLng(pos.latitude, pos.longitude);
}
