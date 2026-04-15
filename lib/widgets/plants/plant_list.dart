import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_map_model.dart';

class PlantList extends StatefulWidget {
  final List<PlantMap>? plants;
  final Widget Function(BuildContext, int) element;
  final Function(PlantMap)? onClick;
  final Function? reload;

  const PlantList({
    super.key,
    required this.element,
    this.plants,
    this.onClick,
    this.reload,
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
      itemBuilder: widget.element
    );
  }
}
