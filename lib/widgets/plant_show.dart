import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
import 'package:geo_leaf/widgets/plant_edit.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class PlantShow extends StatefulWidget {
  final Plant plant;

  const PlantShow(this.plant, {super.key});

  @override
  State<StatefulWidget> createState() => _PlantShow();
}

class _PlantShow extends State<PlantShow> {
  @override
  Widget build(BuildContext context) {
    final logPr = Provider.of<LoginProvider>(context);
    final List datef = widget.plant.date!.split("T")[0].split("-");
    final String formattedDate = "${datef[2]}/${datef[1]}/${datef[0]}";

    return PlantBox(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Text(
              widget.plant.name,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
          ),
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
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Postado por: ${widget.plant.author != null ? widget.plant.author!.username : "nouser"}",
                ),
                Text("Postado em $formattedDate"),
              ],
            ),
          ),
          if (widget.plant.author!.id == logPr.logged!.id)
            Align(
              alignment: AlignmentGeometry.bottomRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text("Deletar"),
                    onPressed: () {
                      deletePlant(widget.plant.id!, logPr.logged!.id);
                      Navigator.pop(context);
                    },
                  ),
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
                ],
              ),
            ),
        ],
      ),
    );
  }
}
