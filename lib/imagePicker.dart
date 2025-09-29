import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geo_leaf/pages/imageVisualizer.dart';

class Imagepicker extends StatefulWidget {
  const Imagepicker({super.key});

  @override
  State<Imagepicker> createState() => _ImagepickerState();
}

class _ImagepickerState extends State<Imagepicker> {
  Image image = Image.asset(width: 150, height: 150, "assets/NoImage.png");

  Future<void> _open() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        image = Image.file(
          width: 150,
          height: 150,
          File(result.files.single.path!),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _open,
            style: ButtonStyle(),
            child: Text("Add File"),
          ),
          GestureDetector(
            onTap: () {
              print("tap");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageVisualizer(image: image.image),
                ),
              );
            },
            child: image,
          ),
        ],
      ),

      /*
        Scaffold(
          body: Center(
            child: 
          ),
        )
          */
    );
  }
}
