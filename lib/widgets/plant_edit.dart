import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/plant_box.dart';

class PlantEdit extends StatefulWidget {
  final String id;

  const PlantEdit({super.key, required this.id});
  @override
  State<PlantEdit> createState() => _PlantEditState();
}

class _PlantEditState extends State<PlantEdit> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return PlantBox(
      margin: EdgeInsets.symmetric(horizontal: 100, vertical: 100),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.topRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Insira o nome",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Material(
                    child: TextField(
                      onChanged: (value) => name = value,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () async {
                    await updatePlant(widget.id, {"name": name});
                    if (mounted) {
                      Navigator.pop(context, name);
                    }
                  },
                  icon: Icon(Icons.check),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
