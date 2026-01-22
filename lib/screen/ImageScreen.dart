import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_pytorch_lite/utils.dart';
import 'package:geo_leaf/utils/Ai.dart';

class ImageScreen extends StatelessWidget {
  final ImageProvider image;
  static final Ai helper = Ai();

  const ImageScreen({super.key, required this.image});
  /*
  */
  @override
  StatelessElement createElement() {
    // TODO: implement createElement
        helper.initHelper().then((_) async {
          await helper.initHelper();
    });
    return super.createElement();
  }


  Future<Map<String, dynamic>> classified() async {
    
    ui.Image img = await TensorImageUtils.imageProviderToImage(AssetImage("assets/images/dahlias.jpg"));
    return await helper.inferenceImage(img);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image(image: image)),
      bottomNavigationBar: FloatingActionButton(
        onPressed: () async {
          await helper.initHelper();
          //final result = await classified();
          ui.Image img = await TensorImageUtils.imageProviderToImage(image);
          final result = await helper.getNames(img);
          if(context.mounted)
          {

           print("Plants $result");

            //print("Plants: ${result.entries.map((e) => e.key)}");
            //print("Names: ${result.entries.map((e) => e.value)}");
            /*
            */
           Navigator.pop(context, [true, result]);
          }
        },
        child: Text("Confirm"),
      ),

      appBar: AppBar(backgroundColor: Colors.green),
    );
  }
}
