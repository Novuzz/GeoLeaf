import 'package:flutter/material.dart';
import 'package:geo_leaf/pages/mapVisualizer.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapVisualizer(),
      appBar: AppBar(backgroundColor: Colors.green),
    );
  }
}
