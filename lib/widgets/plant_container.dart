import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geo_leaf/models/User.dart';
import 'package:geo_leaf/widgets/plant_box.dart';

class PlantContainer extends StatelessWidget {
  final String name;
  final User? user;
  final Image? image;
  final Function? onClicked;

  const PlantContainer({
    super.key,
    required this.name,
    this.user,
    this.image,
    this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClicked!(),

      child: PlantBox(
        height: 128,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                Text(user == null ? "nouser" : user!.username),
              ],
            ),
            if (image != null) Image(image: image!.image),
          ],
        ),
      ),
    );
  }
}
