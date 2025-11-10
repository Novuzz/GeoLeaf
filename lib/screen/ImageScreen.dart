import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final ImageProvider image;

  const ImageScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image(image: image)),
      bottomNavigationBar: FloatingActionButton(
        onPressed: () async {
          Navigator.pop(context, true);
        },
        child: Text("Confirm"),
      ),

      appBar: AppBar(backgroundColor: Colors.green),
    );
  }
}
