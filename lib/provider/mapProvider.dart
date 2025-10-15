import 'package:flutter/material.dart';

class MapProvider with ChangeNotifier {
  String style = "https://demotiles.maplibre.org/style.json";

  bool? styleEnabled = false;

  void changeStyle(bool? toggle) {
    styleEnabled = toggle;
    styleEnabled!
        ? style = "https://tiles.openfreemap.org/styles/bright"
        : style = "https://demotiles.maplibre.org/style.json";
    notifyListeners();
  }
}
