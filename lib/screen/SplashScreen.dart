import 'package:flutter/material.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/screen/HomeScreen.dart';
import 'package:geo_leaf/screen/LoginScreen.dart';
import 'package:geo_leaf/widgets/SplashWidget.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    Future.delayed(const Duration(seconds: 4), _delayInit);
  }

  void _delayInit() {
    var mapPr = Provider.of<LoginProvider>(context, listen: false);
    late Widget screen;

    mapPr.logged == null ? screen = LoginScreen() : screen = HomeScreen();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashWidget(),
      backgroundColor: Colors.white,
    );
  }
}
