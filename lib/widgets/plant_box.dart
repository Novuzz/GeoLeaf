import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class PlantBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const PlantBox({
    super.key,
    this.child,
    this.padding,
    this.height,
    this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(8.0),
      margin: margin,
      decoration: BoxDecoration(
        color: ui.Color.fromARGB(255, 70, 201, 37),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: child,
      ),
    );
  }
}
