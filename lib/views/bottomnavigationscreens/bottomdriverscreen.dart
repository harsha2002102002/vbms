import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottomnavigationscreens/bottomdriverscreencontroller.dart';

class BottomDriverScreen extends StatelessWidget {
  const BottomDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomDriverScreenController>(
      init: BottomDriverScreenController(),
      builder: (dsc) {
        return DefaultTabController(
          initialIndex: 0,
          length: dsc.tabController!.length, // Number of tabs
          child: Scaffold(
            body: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                // TabBar without AppBar
                Container(
                  width: 370,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey)),
                  child: TabBar(
                    onTap: (int index) {
                      // Handle tab selection
                      log('Selected tab: $index');
                      if (dsc.appTitle == "Update Driver Details") {
                        if (index == 1) {
                          dsc.loginPassword.clear();
                          dsc.firstName.clear();
                          dsc.lastName.clear();
                          dsc.emailID.clear();
                          dsc.mobileNumber.clear();
                          dsc.licenseNumber.clear();
                          dsc.frontSideNames.clear();
                          dsc.frontSidePaths.clear();
                          dsc.frontSideBaseImg.clear();
                          dsc.backSideNames.clear();
                          dsc.backSidePaths.clear();
                          dsc.backSideBaseImg.clear();
                          dsc.driverId = "";
                          dsc.buttonName = "Save";
                          dsc.appTitle = "Add Driver";
                          dsc.isLoading = true;
                          dsc.loadDriversList();
                          dsc.update();
                        }
                      }
                    },
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.all(5),
                    indicatorColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors
                          .purple, // Background color for the selected tab
                      borderRadius: BorderRadius.circular(8), // Rounded edges
                    ),
                    labelColor: Colors.white, // Text color for the selected tab
                    unselectedLabelColor:
                        Colors.black, // Text color for unselected tabs
                    unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Inter-Medium', fontSize: 14),
                    labelStyle: const TextStyle(
                        fontFamily: 'Inter-Medium', fontSize: 14),
                    controller: dsc.tabController,
                    tabs: [
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Text(dsc.appTitle.toString()),
                        ),
                      ),
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            'Drivers List',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // TabBarView for showing content for each tab
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38, // Shadow color with opacity
                          offset: Offset(0, 1), // Position of the shadow (x, y)
                          blurRadius: 10, // Blur effect radius
                          spreadRadius: 5, // How far the shadow spreads
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TabBarView(
                      controller: dsc.tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        dsc.buildAddDriver(),
                        dsc.buildDriversList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
