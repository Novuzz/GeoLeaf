import 'package:flutter/material.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/provider/map_provider.dart';
import 'package:geo_leaf/screen/SplashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }
}
