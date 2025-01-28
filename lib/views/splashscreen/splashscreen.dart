import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splashscreen/splashscreencontroller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
      init: SplashScreenController(),
      builder: (controller) {
        return Scaffold(
            body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(color: Color(0xFFfbfbfb)),
            ),
            Center(
                widthFactor: 20.0,
                heightFactor: 20.0,
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                ))
          ],
        ));
      },
    );
  }
}
