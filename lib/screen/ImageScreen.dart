import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_pytorch_lite/utils.dart';
import 'package:geo_leaf/utils/Ai.dart';

class ImageScreen extends StatelessWidget {
  final ImageProvider image;
  static final Ai helper = Ai();

  const ImageScreen({super.key, required this.image});
  
  @override
  StatelessElement createElement() {
    // TODO: implement createElement
        helper.initHelper().then((_) async {
          await helper.initHelper();
    });
    return super.createElement();
  }


  Future<Map<String, dynamic>> classified() async {
    
    ui.Image img = await TensorImageUtils.imageProviderToImage(image);
    return await helper.inferenceImage(img);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image(image: image)),
      bottomNavigationBar: FloatingActionButton(
        onPressed: () async {
          await helper.initHelper();
          final result = await classified();
          if(context.mounted)
          {
            Navigator.pop(context, [true, result]);
          }
        },
        child: Text("Confirm"),
      ),

      appBar: AppBar(backgroundColor: Colors.green),
    );
  }
}
