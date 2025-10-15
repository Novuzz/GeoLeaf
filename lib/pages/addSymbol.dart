import 'package:flutter/material.dart';

class Addsymbol extends StatelessWidget {
  const Addsymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(child: Column(children: [Text("Flower"), TextField()])),
    );
  }
}
