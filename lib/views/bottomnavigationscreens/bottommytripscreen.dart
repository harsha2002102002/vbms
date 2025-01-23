import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottomnavigationscreens/bottommytripcontroller.dart';

class BottomMyTripsScreen extends StatelessWidget {
  const BottomMyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomMyTripsScreenController>(
      init: BottomMyTripsScreenController(),
      builder: (mtc) {
        return DefaultTabController(
          initialIndex: 0,
          length: mtc.tabController!.length, // Number of tabs
          child: Scaffold(
            body: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                // TabBar without AppBar
                Container(
                  width: 370,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey)),
                  child: TabBar(
                    onTap: (int index) {
                      mtc.isLoading = true;
                      mtc.getMyTrips(index);
                    },
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.all(5),
                    indicatorColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: Colors
                          .purple, // Background color for the selected tab
                      borderRadius: BorderRadius.circular(8), // Rounded edges
                    ),
                    labelColor:
                        Colors.white, // Text color for the selected tab
                    unselectedLabelColor:
                        Colors.black, // Text color for unselected tabs
                    unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    controller: mtc.tabController,
                    tabs: [
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            'On Going',
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            'Completed',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // TabBarView for showing content for each tab
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TabBarView(
                      controller: mtc.tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        mtc.buildOnGoing(),
                        mtc.buildCompleted(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
