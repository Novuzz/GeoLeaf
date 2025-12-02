import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_pytorch_lite/utils.dart';
import 'package:geo_leaf/screen/MapScreen.dart';
import 'package:geo_leaf/utils/Ai.dart';
import 'package:geo_leaf/widgets/ImagePicker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const assetImage = AssetImage('assets/images/lotus.jpg');

  Ai helper = Ai();
  Map<String, double>? classification;

  @override
  void initState() {
    ();
    super.initState();
    helper.initHelper().then((_) {
      classified();
      print(classification);
    });
    super.initState();
    _controller = AnimationController(vsync: this);
  }
  
  Future<void> classified() async {
    ui.Image image = await TensorImageUtils.imageProviderToImage(assetImage);
    classification = await helper.inferenceImage(image);

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(builder: (context) => Column(children: [Imagepicker()])),
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
