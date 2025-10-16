import 'package:flutter/material.dart';

class ImageVisualizer extends StatelessWidget {
  final ImageProvider image;

  const ImageVisualizer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image(image: image)),

      appBar: AppBar(backgroundColor: Colors.green),
    );
  }
}
