import 'package:flutter/material.dart';
import 'package:geo_leaf/models/Plant.dart';
import 'package:geo_leaf/widgets/plant_box.dart';

class PlantShow extends StatelessWidget {
  final Plant plant;

  const PlantShow(this.plant, {super.key});

  @override
  Widget build(BuildContext context) {
    final List datef = plant.date!.split("T")[0].split("-");
    final String formattedDate = "${datef[2]}/${datef[1]}/${datef[0]}";

    return PlantBox(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Text(
              plant.name,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.center,
            child: Image(
              image: ResizeImage(
                plant.image!.image,
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
                  "Postado por: ${plant.author != null ? plant.author!.username : "nouser"}",
                ),
                Text("Postado em $formattedDate"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
