import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/utils/map_render.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
import 'package:geo_leaf/widgets/plants/plant_edit.dart';
import 'package:provider/provider.dart';

class PlantShow extends StatefulWidget {
  final Plant plant;

  final Future<void>? onClose;

  const PlantShow(this.plant, {super.key, this.onClose});

  @override
  State<StatefulWidget> createState() => _PlantShow();
}

class _PlantShow extends State<PlantShow> {
  @override
  Widget build(BuildContext context) {
    final logPr = Provider.of<LoginProvider>(context);
    var mapPr = Provider.of<MapProvider>(context);
    final List datef = widget.plant.date!.split("T")[0].split("-");
    final String formattedDate = "${datef[2]}/${datef[1]}/${datef[0]}";

    return PlantBox(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Text(
              widget.plant.name,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
          ),
          if(widget.plant.image != null)
          Align(
            alignment: AlignmentGeometry.center,
            child: Image(
              image: ResizeImage(
                widget.plant.image!.image,
                height: 400,
                allowUpscaling: true,
              ),
            ), //Image(image: image!),
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
            alignment: AlignmentGeometry.bottomLeft,
            child: Text("Postado em $formattedDate"),
          ),

          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.plant.author != null &&
                    widget.plant.author!.id == logPr.logged!.id)
                  TextButton(
                    child: Text("Deletar"),
                    onPressed: () async {
                      print("delete");
                      try {
                        if (mapPr.mapController != null) {
                          await updatePlants(
                            mapPr.mapController,
                            id: widget.plant,
                            delete: true,
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      } catch (e) {
                        await deletePlant(
                          widget.plant.id!,
                          widget.plant.author!.id,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                if (widget.plant.author != null &&
                    widget.plant.author!.id == logPr.logged!.id)
                  TextButton(
                    child: Text("Atualizar"),
                    onPressed: () async {
                      String? name = await showDialog(
                        context: context,
                        builder: (context) => PlantEdit(id: widget.plant.id!),
                      );
                      setState(() {
                        if (name != null) {
                          widget.plant.name = name;
                        }
                      });
                    },
                  ),
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
