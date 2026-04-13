import 'package:flutter/material.dart';
import 'package:geo_leaf/models/user_model.dart';
import 'package:geo_leaf/widgets/plant_box.dart';

class PlantContainer extends StatelessWidget {
  final String name;
  final Widget? center;
  final Function? onClicked;

  const PlantContainer({
    super.key,
    required this.name,
    this.center,
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
              ],
            ),
            ?center,
          ],
        ),
      ),
    );
  }
}
