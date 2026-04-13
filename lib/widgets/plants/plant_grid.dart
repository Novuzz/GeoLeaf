import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
import 'package:geo_leaf/widgets/plants/plant_show.dart';

class PlantGrid extends StatefulWidget {
  final String name;
  final List<Plant> plants;

  const PlantGrid({super.key, required this.name, required this.plants});

  @override
  State<PlantGrid> createState() => _PlantGridState();
}

class _PlantGridState extends State<PlantGrid> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 64),
          child: ClipRect(
            child: SingleChildScrollView(
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(widget.plants.length, (index) {
                  return GestureDetector(
                    onTap: () async {
                      final currentPlant = widget.plants[index];
                      await showDialog(
                        context: context,
                        builder: (context) => PlantBox(
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentGeometry.center,
                                child: Image.asset("assets/images/lotus.jpg"),
                              ),
                              Align(
                                alignment: AlignmentGeometry.topEnd,
                                child: IconButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: PlantBox(
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentGeometry.bottomCenter,
                            child: Text(widget.plants[index].name),
                          ),
                          Align(
                            alignment: AlignmentGeometry.topCenter,
                            child: Image.asset("assets/images/lotus.jpg"),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
