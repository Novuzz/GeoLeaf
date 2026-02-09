import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geo_leaf/models/Plant.dart';
import 'package:geo_leaf/utils/HttpRequest.dart';
import 'package:geo_leaf/utils/MapRender.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/widgets/plant_show.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

              if (features.isNotEmpty) {
                final f = features.first;

                Plant? plant = await getPlantById(f["properties"]["id"]);
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => PlantShow(plant!),
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
                },
              ),

              if (!isLoaded) ModalBarrier(dismissible: false),

              if (!isLoaded)
                Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 1000,
                        height: 1000,
                        child: ColoredBox(color: Colors.white),
                      ),
                      Center(
                        child: LoadingAnimationWidget.waveDots(
                          color: Colors.green,
                          size: 100,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
