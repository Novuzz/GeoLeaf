import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapVisualizer extends StatelessWidget {
  const MapVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: MapController(
        initPosition: GeoPoint(latitude: 47, longitude: 8)
      ),
      osmOption: OSMOption(
        userTrackingOption: UserTrackingOption(
          enableTracking: true,
          unFollowUser: false
        ),
        zoomOption:  ZoomOption(
          initZoom: 8,
          minZoomLevel: 3,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
      ),
    );
  }
}