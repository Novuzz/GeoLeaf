import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_map_model.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/utils/map_render.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
import 'package:provider/provider.dart';

class PlantShow extends StatefulWidget {
  final PlantMap? plant;

  final Widget? center;

  final Future<void>? onClose;

  const PlantShow({super.key, this.plant, this.onClose, this.center});

  @override
  State<StatefulWidget> createState() => _PlantShow();
}

class _PlantShow extends State<PlantShow> {
  @override
  Widget build(BuildContext context) {
    var mapPr = Provider.of<MapProvider>(context);

    return PlantBox(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Text(
              widget.plant == null ? "": widget.plant!.name,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.center,
            child: widget.center,
          ),
          Align(
            alignment: AlignmentGeometry.topRight,
            child: IconButton(
              onPressed: () async {
                try {
                  await updatePlants(mapPr.mapController);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              icon: Icon(Icons.close),
            ),
          ),

          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
