import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/utils/map_render.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/widgets/plants/plant_show.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
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
}

class MapVisualizerState extends State<MapVisualizer> {
  bool canInteractWithMap = false;
  bool isLoaded = false;
  MapLibreMapController? _controller;

  final GlobalKey _mapKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var mapPr = Provider.of<MapProvider>(context);

    mapPr.context = context;

    //Carrega o mapa
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
              print("Features: ${features}");
              print(features.isNotEmpty);

              if (features.isNotEmpty) {
                final f = features.first;

                Plant? plant = await getPlantById(f["properties"]["id"]);
                print(plant);
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (context) => PlantShow(
                      plant!,
                      onClose: updatePlants(mapPr.mapController),
                    ),
                  );
                }
              }
            } catch (e) {}
          },
          child: Stack(
            children: [
              MapLibreMap(
                key: _mapKey,
                compassEnabled: false,
                myLocationEnabled: true,
                scrollGesturesEnabled: mapPr.scrollEnabled,

                initialCameraPosition: MapVisualizer._nullIsland,
                styleString: mapPr.style,
                onStyleLoadedCallback: () async {
                  if (mapPr.mapController != null) {
                    isLoaded = await addGJson(mapPr.mapController, mapPr);
                    //mapPr.update();
                  }
                },
                onMapCreated: (controller) async {
                  mapPr.mapController = controller;
                  _controller = controller;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> changeCamera(LatLng position) async {
    if (_controller != null) {
      _controller!.animateCamera(CameraUpdate.newLatLng(position));
    }
  }
}
