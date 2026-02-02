import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_leaf/models/Plant.dart';
import 'package:geo_leaf/provider/login_provider.dart';
//import 'package:flutter_pytorch_lite/utils.dart';
import 'package:geo_leaf/screen/MapScreen.dart';
import 'package:geo_leaf/utils/HttpRequest.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<Plant>? plants;
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _getPlants();
    //plants = await getPlants();
  }

  void _getPlants() async {
    final result = await getPlants();
    setState(() {
      plants = result;
    });
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
              SizedBox(
                height: 64,

                child: Text(
                  "Seja bem vindo(a) ${logPr.logged!.username} 👋",
                  style: TextStyle(
                    color: ui.Color.fromARGB(255, 11, 133, 58),
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FloatingActionButton(
                child: Text("Post Plant"),
                onPressed: () async {
                await postPlant(Plant(name: "Rosa", longitude: 0.5, latitude: 0.5, author: logPr.logged, image: null));
              }),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 20);
                  },
                  itemCount: plants == null ? 0 : plants!.length,
                  addAutomaticKeepAlives: false,
                  itemBuilder: (context, index) {
                    final currentPlant = plants![index];
                    return Container(
                      height: 128,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: ui.Color.fromARGB(255, 70, 201, 37),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentPlant.name,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  currentPlant.author == null
                                      ? "nouser"
                                      : currentPlant.author!.username,
                                ),
                              ],
                            ),
                            if(currentPlant.image != null)
                            Image(image: currentPlant.image!.image),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _getPlants();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
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
