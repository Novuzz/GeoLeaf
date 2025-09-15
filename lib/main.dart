import 'package:flutter/material.dart';
import 'package:geo_leaf/imagePicker.dart';
import 'package:geo_leaf/pages/mapVisualizer.dart';

void main()
{
  runApp(
    MyApp()
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          
          child: Column(
            children: [
              Imagepicker(),
              MapVisualizer()
            ],
          )
        ),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Text(
              "Geoleaf",
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic
              ),
            ),
          ) 
        ),
        
      )
    );
  }
}

