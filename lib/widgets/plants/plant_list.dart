import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_map_model.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/widgets/plants/plant_container.dart';
import 'package:geo_leaf/widgets/plants/plant_grid.dart';
import 'package:geo_leaf/widgets/plants/plant_show.dart';

class PlantList extends StatefulWidget {
  final List<PlantMap>? plants;
  final Widget? center;
  final Function(PlantMap)? onClick;
  final Function? reload;
  const PlantList({
    super.key,
    this.plants,
    this.onClick,
    this.reload,
    this.center,
  });
  @override
  State<PlantList> createState() => _PlantListState();
}

class _PlantListState extends State<PlantList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const SizedBox(height: 20);
      },
      itemCount: widget.plants == null ? 0 : widget.plants!.length,
      addAutomaticKeepAlives: false,
      itemBuilder: (context, index) {
        final currentPlant = widget.plants![index];
        return PlantContainer(
          name: currentPlant.name,
          onClicked: () async {
            if (widget.onClick == null) {
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
            } else {
              widget.onClick!(currentPlant);
            }
            if (widget.reload != null) {
              widget.reload!();
            }
          },
        );
      },
    );
  }
}
