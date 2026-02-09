import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final String name = "";

  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int i = 0;

  void _increment() {
    setState(() {
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: _increment, child: const Text("+")),
        Text(i.toString()),
      ],
    );
  }
}
