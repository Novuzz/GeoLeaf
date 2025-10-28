import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geo_leaf/functions/EaseFunctions.dart';


//Descrição: A logo que aparece no começo
class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return Opacity(
          opacity: sine(_controller.value),
          child: SvgPicture.asset("assets/images/splash/GEOLEAFLOGO.svg"),
        );
      },
    );
  }
}
