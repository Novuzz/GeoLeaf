import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoWidget extends StatelessWidget {
  final bool? inBottom;
  final double? width;
  final double? height;

  const LogoWidget({super.key, this.inBottom, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final image = SvgPicture.asset(
      "assets/images/splash/GEOLEAFLOGO.svg",
      width: width ?? 64,
      height: height ?? 64,
    );

    return inBottom == null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              Text("Geoleaf", style: TextStyle(fontWeight: FontWeight.w900)),
            ],
          )
        : Column(
            children: [
              image,
              Text(
                "Geoleaf",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: (width! + height!) * 0.1,
                ),
              ),
            ],
          );
  }
}
