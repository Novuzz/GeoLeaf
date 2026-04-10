
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
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1 ),
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: child,
      ),
    );
  }
}
