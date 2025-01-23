import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home/bottombarcontroller.dart';

class BottomTile extends StatelessWidget {
  const BottomTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomTileController>(
      init: BottomTileController(),
      builder: (bc) {
        return Scaffold(
          appBar: AppBar(
            // leading: GestureDetector(
            //   child: Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            //     decoration: BoxDecoration(
            //         color: Colors.grey,
            //         borderRadius: BorderRadius.circular(80)),
            //     child: const Icon(
            //       Icons.person,
            //       size: 30,
            //     ),
            //   ),
            // ),
            title: Text(bc.appTitle),
            titleTextStyle: const TextStyle(
                color: Colors.purple,
                fontFamily: "Inter-Medium",
                fontSize: 20),
          ),
          body: bc.bottomPages[bc.selectedIndex],
          bottomNavigationBar: CircleNavBar(
            activeIcons: bc.activeIcons,
            inactiveIcons: bc.inactiveIcons,
            color: Colors.white,
            height: 60,
            circleWidth: 50,
            activeIndex: bc.selectedIndex,
            padding: const EdgeInsets.only(bottom: 10),
            onTap: (index) {
              bc.updateIndex(index);
            },
            shadowColor: Colors.purple.shade100,
            elevation: 10,
            circleShadowColor: Colors.purple,
            levels: bc.bottomLabels,
            inactiveLevelsStyle:
                const TextStyle(color: Colors.grey, fontSize: 12,fontFamily: "Inter-Medium",),
            activeLevelsStyle: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
