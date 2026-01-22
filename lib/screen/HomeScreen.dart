import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geo_leaf/models/Plant.dart';
import 'package:geo_leaf/provider/login_provider.dart';
//import 'package:flutter_pytorch_lite/utils.dart';
import 'package:geo_leaf/screen/MapScreen.dart';
import 'package:geo_leaf/utils/Ai.dart';
import 'package:geo_leaf/utils/HttpRequest.dart';
import 'package:geo_leaf/widgets/ImagePicker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final assetImage = AssetImage('assets/images/dahlias.jpg');

  Map<String, double>? classification;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var logPr = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => Column(
            children: [
              Imagepicker(),
              FloatingActionButton(child: Text("Post Data"),onPressed: (){
                postPlant(Plant(name: "test", longitude: -46.6524433, latitude: -23.5474283, author: logPr.logged));
              })
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text(
            "Geoleaf",
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.map),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
