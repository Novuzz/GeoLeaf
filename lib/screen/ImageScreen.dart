import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final ImageProvider image;

  const ImageScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image(image: image)),

      appBar: AppBar(backgroundColor: Colors.green),
    );
  }
}
