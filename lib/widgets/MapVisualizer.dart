import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:geo_leaf/widgets/AddSymbol.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geo_leaf/functions/numberF.dart';
import 'package:provider/provider.dart';

//Descrição: Classe encarregada de mostrar o mapa

class MapVisualizer extends StatefulWidget {
  static const CameraPosition _nullIsland = CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 2,
  );

  MapVisualizer({super.key});

  @override
  State<MapVisualizer> createState() => MapVisualizerState();
  OverlayEntry? entry;

  void addWindow(BuildContext context, {String? edited}) {
    entry = OverlayEntry(
      builder: (ctx) =>
          Positioned(left: 40, right: 30, top: 50, child: Addsymbol(map: this, id: edited,)),
    );
    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }

  void removeWindow() {
    entry?.remove();
    entry = null;
  }
}

class MapVisualizerState extends State<MapVisualizer> {
  bool canInteractWithMap = false;

  final GlobalKey _mapKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var mapPr = Provider.of<MapProvider>(context);

    mapPr.context = context;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerUp: (PointerUpEvent event) async {
            if (mapPr.mapController == null) return;

            try {
              final mapContext = _mapKey.currentContext;
              if (mapContext == null) return;
              final renderObj = mapContext.findRenderObject();
              if (renderObj == null) return;

              final local = (renderObj as RenderBox).globalToLocal(
                event.position,
              );
              final pixelRatio = MediaQuery.of(context).devicePixelRatio;
              final point = Point<double>(
                local.dx * pixelRatio,
                local.dy * pixelRatio,
              );

              final features = await mapPr.mapController!.queryRenderedFeatures(
                point,
                ["plants-layer"],
                null,
              );

              if (features.isNotEmpty) {
                final f = features.first;
                final g = f["geometry"]["coordinates"];
                await mapPr.mapController!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(g[1], g[0]),
                      zoom: 20.0,
                      tilt: 0.0,
                      bearing: 30.0,
                    ),
                  ),
                );
                mapPr.setScroll(false);
                widget.addWindow(context, edited: f["id"]);
              }
            } catch (e) {}
          },
          child: MapLibreMap(
            key: _mapKey,
            compassEnabled: false,

            scrollGesturesEnabled: mapPr.scrollEnabled,

            initialCameraPosition: MapVisualizer._nullIsland,
            styleString: mapPr.style,

            onMapLongClick: (point, coordinates) async {
              mapPr.lastPosition = CameraPosition(
                target: LatLng(-23.548177519867036, -46.65227339052233),
                zoom: 17.0,
                tilt: 60.0, // pitch to see the extrusion
                bearing: 30.0, // rotate a bit
              );
              await mapPr.mapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: coordinates,
                    zoom: 20.0,
                    tilt: 0.0,
                    bearing: 30.0,
                  ),
                ),
              );
              mapPr.setScroll(false);
              mapPr.addPoint(coordinates);
              widget.addWindow(context);
            },
            onStyleLoadedCallback: () async {
              if (mapPr.mapController != null) {
                await addGJson(mapPr.mapController);
              }
            },
            onMapCreated: (controller) async {
              mapPr.mapController = controller;
            },
          ),
        );
      },
    );
  }

  Future<void> addGJson(MapLibreMapController? controller) async {
    String js = await rootBundle.loadString("assets/json/mapRuas.geojson");
    String ln = await rootBundle.loadString("assets/json/lines.json");

    Map<String, dynamic> jsD = await json.decode(js);
    Map<String, dynamic> lines = await json.decode(ln);

    await controller!.addGeoJsonSource("buildings-source", jsD);
    await controller.addGeoJsonSource("lines-source", lines);

    await controller.addGeoJsonSource("plants-source", {
      'type': 'FeatureCollection',
      'features': [],
    });
    await controller.addFillExtrusionLayer(
      "buildings-source",
      "buildings-3d",
      FillExtrusionLayerProperties(
        fillExtrusionHeight: ['get', 'height'] ?? 0.1,
        fillExtrusionBase: 0,
        fillExtrusionColor: ['get', 'color'] ?? '#BFD738',
        fillExtrusionOpacity: 0.9,
        fillExtrusionVerticalGradient: true,
      ),
    );

    await controller.addLineLayer(
      "lines-source",
      "lines",
      LineLayerProperties(lineColor: '#F5F2F9', lineWidth: 12),
      belowLayerId: 'buildings-3d',
    );

    Map<String, Object> data = {"type": "FeatureCollection", "features": [
        
      ],
    };
    /*

 */
    for (var points in jsD['features']) {
      var properties = points['properties'];
      if (properties['exclude'] != null) continue;
      var localPoints = points['geometry']['coordinates'][0];
      final center = getCenter(localPoints);
      (data["features"] as List).add({
        "type": "Feature",
        "properties": {
          "name": properties['name'],
          "color": properties['color'],
        },
        "geometry": {"coordinates": center, "type": "Point"},
      });
    }
    await controller.addGeoJsonSource("marker-source", data);
    await controller.addCircleLayer(
      "marker-source",
      "marker-layer",
      CircleLayerProperties(
        circleColor: ['get', 'color'] ?? "#ff0000",
        circleRadius: 8.0,
        circleStrokeWidth: 2.0,
        circleStrokeColor: "#ffffff",
      ),
      minzoom: 18,
    );

    await controller.addSymbolLayer(
      "marker-source",
      "points_layer",
      SymbolLayerProperties(
        textField: ['get', 'name'],

        textSize: 14,
        textColor: '#ffffff',
        textHaloColor: ['get', 'color'],
        textHaloWidth: 1.5,
        textAnchor: 'top',
        textOffset: [0, 1.5],
        textAllowOverlap: true,
        textFont: ['Open Sans Regular', 'Arial Unicode MS Regular'],
      ),
      minzoom: 18,
    );

    await controller.addCircleLayer(
      "plants-source",
      "plants-layer",
      CircleLayerProperties(
        circleColor: "#50C878",
        circleRadius: 8.0,
        circleStrokeWidth: 2.0,
        circleStrokeColor: "#ffffff",
      ),
      minzoom: 0,
      enableInteraction: true,
    );
    await controller.addSymbolLayer(
      "plants-source",
      "plants-text",
      SymbolLayerProperties(
        textField: ['get', 'name'],

        textSize: 14,
        textColor: '#ffffff',
        textHaloColor: ['get', 'color'],
        textHaloWidth: 1.5,
        textAnchor: 'top',
        textOffset: [0, 1.5],
        textAllowOverlap: true,
        textFont: ['Open Sans Regular', 'Arial Unicode MS Regular'],
      ),
      minzoom: 0,
      enableInteraction: true,
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(-23.548177519867036, -46.65227339052233),
          zoom: 17.0,
          tilt: 60.0, // pitch to see the extrusion
          bearing: 30.0, // rotate a bit
        ),
      ),
    );
  }
}
