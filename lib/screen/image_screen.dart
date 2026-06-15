
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:blur/blur.dart';
import 'package:flutter_image_converter/flutter_image_converter.dart';
import 'package:geo_leaf/functions/numberF.dart';
import 'package:geo_leaf/utils/bilateral_filter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pytorch_lite/utils.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/utils/ai.dart';
import 'package:geo_leaf/utils/gps.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:provider/provider.dart';

class ImageScreen extends StatefulWidget {
  final Image image;
  final Uint8List? rawImage;
  final bool? disableFilter;
  static final Ai helper = Ai();
  const ImageScreen({super.key, required this.image, this.rawImage, this.disableFilter = false});
  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  String name = "...";
  bool ready = false;

  ImageProvider? image;  
  @override
  void initState() {
    super.initState();
    // _initializeImage();
    _getNames();
  }
  
  Future<void> _initializeImage() async {
    /*
     */
    final ImageProvider<Object> provider;
    if(widget.disableFilter!)
    {
      provider = widget.image.image;
    }
    else
    {
      provider = await _filterImage();
    }
    if (mounted) {
      setState(() {
        image = provider;
      });
    }
  }
  
  Future<ImageProvider<Object>> _filterImage() async
  {
    
    final imageImage = await widget.image.imageImage;
    //final bilateral = await BilateralProcessor.applyFilter(inputImage: await widget.image.uiImage, sigmaSpatial: 2.5, sigmaRange: 0.1);
    final gaussian =   img.gaussianBlur( imageImage, radius: 3);
    //final image = Image.memory(bilateral!);
    final contrast = img.contrast(gaussian, contrast: 120);

    final provider = await contrast.imageProvider;
    return provider;//await imageImage.imageProvider;//provider;
  }

  @override
  Widget build(BuildContext context) {
    var logPr = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(name),
            image == null ? Image(image: widget.image.image): Image(image: image!),
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
    /*
     */
    final provider = widget.disableFilter! ? widget.image.image : await _filterImage();
    setState(() {
      image = provider;
    });
    ui.Image uiImage = await TensorImageUtils.imageProviderToImage(
      provider
    );
    final result = await ImageScreen.helper.getNames(uiImage);
    if (mounted) {
      setState(() {
        name = result.first;
      });
    }
  }
}
