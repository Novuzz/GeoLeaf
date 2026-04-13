import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_map_model.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
import 'package:geo_leaf/widgets/plants/plant_list.dart';

class PlantDrawer extends StatefulWidget {
  final Function(Plant)? onClick;

  const PlantDrawer({super.key, this.onClick});

  @override
  State<PlantDrawer> createState() => _PlantDrawerState();
}

class _PlantDrawerState extends State<PlantDrawer> {
  List<PlantMap>? plant;

  @override
  void initState() {
    super.initState();
    _getPlants();
  }

  @override
  Widget build(BuildContext context) {
    return PlantBox(
      padding: EdgeInsets.all(8),
      child: PlantList(plants: plant),
    );
  }

  void _getPlants() async {
    final result = await getPlants();

    setState(() {
      plant = result;
    });
  }
}
