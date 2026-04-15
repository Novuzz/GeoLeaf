import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_map_model.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
import 'package:geo_leaf/widgets/plants/plant_container.dart';
import 'package:geo_leaf/widgets/plants/plant_grid.dart';
import 'package:geo_leaf/widgets/plants/plant_list.dart';
import 'package:geo_leaf/widgets/plants/plant_show.dart';

class PlantDrawer extends StatefulWidget {
  final Function(Plant)? onClick;

  const PlantDrawer({super.key, this.onClick});

  @override
  State<PlantDrawer> createState() => _PlantDrawerState();
}

class _PlantDrawerState extends State<PlantDrawer>  with TickerProviderStateMixin  {
  List<PlantMap>? plant;
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getPlants();
  }

  @override
  Widget build(BuildContext context) {
    final _plant = PlantList(
      plants: plant,
      element: (context, index) {
        final currentPlant = plant![index];
        return PlantContainer(
          name: currentPlant.name,
          onClicked: () async {
            await showDialog(
              context: context,
              builder: (context) => PlantShow(
                currentPlant,
                center: PlantGrid(
                  name: currentPlant.name,
                  plants: currentPlant.registeredPlants!,
                ),
              ),
            );
          },
        );
      },
    );

    return Stack(
      children: [
        PlantBox(),

          Column(
            children: [
              TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: "Todos"),
                  Tab(text: "Por local"),
                ],
              ), //PlantBox(padding: EdgeInsets.all(8), child: _plant);
              Expanded(child: 
              
              TabBarView(
                controller: _tabController,
                children: [
                Center(child: _plant),
                Center(child: Text("Local")),
              ])
              ),
            ],
          ), 
      ],
    );
  }

  void _getPlants() async {
    final result = await getPlantsByLocation("Predio");

    setState(() {
      plant = result;
    });
  }
}
