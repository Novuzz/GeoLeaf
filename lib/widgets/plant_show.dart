import 'package:flutter/material.dart';
import 'package:geo_leaf/models/User.dart';
import 'package:geo_leaf/widgets/plant_box.dart';

class PlantShow extends StatelessWidget {
  final String name;
  final String date;
  final ImageProvider? image;
  final User? user;

  const PlantShow(this.name, this.date, {super.key, this.image, this.user});

  @override
  Widget build(BuildContext context) {
    final List datef = date.split("T")[0].split("-");
    final String formattedDate = "${datef[2]}/${datef[1]}/${datef[0]}";

    return PlantBox(
      margin: EdgeInsets.symmetric(horizontal: 90, vertical: 50),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Text(
              name,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.center,
            child: Image(
              image: ResizeImage(image!, height: 400, allowUpscaling: true),
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
            child: Text(
              "Postado por: ${user != null ? user!.username : "nouser"}",
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: Text("Postado em $formattedDate"),
          ),
        ],
      ),
    );
  }
}
