import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/landingpage/landingpagecontroller.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LandingPageController>(
      init: LandingPageController(),
      builder: (lpc) {
        return Scaffold(
            body: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Color(0xFFfbfbfb)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/appbar_bg.png",
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                              color: Color(0xFF2a2a2a),
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Choose your role to continue',
                          style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: () {
                    lpc.goToNextScreen("Employee");
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF8E278F),
                    ),
                    child: const Text(
                      "Employee",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    lpc.goToNextScreen("Operator");
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF8E278F),
                    ),
                    child: const Text(
                      "Service Provider",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    lpc.goToNextScreen("Airport Admin");
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF8E278F),
                    ),
                    child: const Text(
                      "Airport Admin",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    lpc.goToNextScreen("Driver");
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF8E278F),
                    ),
                    child: const Text(
                      "Driver",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}
