import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_pytorch_lite/utils.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/utils/ai.dart';
import 'package:geo_leaf/utils/gps.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';
import 'package:provider/provider.dart';

class ImageScreen extends StatefulWidget {
  final Image image;
  final Uint8List? rawImage;
  static final Ai helper = Ai();
  const ImageScreen({super.key, required this.image, this.rawImage});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  String name = "...";
  bool ready = false;
  @override
  Widget build(BuildContext context) {
    var logPr = Provider.of<LoginProvider>(context);
    _getNames();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(name),
            Image(image: widget.image.image),
          ],
        ),
      ),
      bottomNavigationBar: FloatingActionButton(
        onPressed: () async {
          //await ImageScreen.helper.initHelper();
          //final result = await classified();
          final point = await determinePosition();
          final closest = await getClosestLocation(LatLng(point.latitude, point.longitude));
          final plant = Plant(
            name: name,
            longitude: point.longitude,
            latitude: point.latitude,
            rawImage: widget.rawImage,
            location: closest,
            author: logPr.logged,
          );
          await postPlant(plant);
          if (context.mounted) {
            Navigator.pop(context, [true]);
          }
        },
        child: Text("Confirm"),
      ),

      appBar: AppBar(backgroundColor: Colors.green),
    );
  }

  void _getNames() async {
    await ImageScreen.helper.initHelper();
    ui.Image img = await TensorImageUtils.imageProviderToImage(
      widget.image.image,
    );
    final result = await ImageScreen.helper.getNames(img);
    if (mounted) {
      setState(() {
        name = result.first;
      });
    }
  }
}
