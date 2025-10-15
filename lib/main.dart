import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_leaf/pages/mapPage.dart';
import 'package:geo_leaf/provider/mapProvider.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geo_leaf/imagePicker.dart';
import 'package:geo_leaf/pages/mapVisualizer.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => MapProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  OverlayEntry? entry;

  MyApp({super.key});

  void test(BuildContext context) {
    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        left: 40,
        right: 30,
        child: ElevatedButton(
          onPressed: () => print("press"),
          child: Text("data"),
        ),
      ),
    );
    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Column(
            children: [
              Imagepicker(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Mappage()),
                  );
                },
                child: Text("Open Map"),
              ),
              ElevatedButton(
                onPressed: () => test(context),
                child: Text("Test"),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Text(
              "Geoleaf",
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
