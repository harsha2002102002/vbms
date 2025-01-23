import 'dart:developer';

import 'package:vbms/controllers/caboperator/driver/driverhomecontroller.dart';
import 'package:vbms/views/caboperator/driver/adddriver.dart';
import 'package:vbms/views/caboperator/driver/viewdrivers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/bottombar.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverHomeController>(
        init: DriverHomeController(),
        builder: (dhc) => Scaffold(
          backgroundColor: Colors.pink.shade50,
              // appBar: AppBar(
              //   leading: GestureDetector(
              //     onTap: () {
              //       Get.off(() => const BottomTile());
              //     },
              //     child: const Icon(
              //       Icons.arrow_back_ios,
              //       size: 30,
              //     ),
              //   ),
              //   title: const Text(
              //     "Driver",
              //     style: TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   backgroundColor: Colors.purple,
              //   iconTheme: const IconThemeData(
              //     color: Colors.white,
              //     size: 35,
              //   ),
              // ),
              body: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 30, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.off(() => const AddDriver());
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          padding: const EdgeInsets.all(10),
                          // width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            children: [
                              SizedBox(height: 15,),
                              Image(
                                image: AssetImage('assets/images/add_icon.png'),
                                height: 80,
                                width: 80,
                              ),

                              Text("Add Driver",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: GestureDetector(
                        onTap: () {
                          log("Clicked on Driver");
                          Get.to(() => const ViewDrivers());
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          padding: const EdgeInsets.all(10),
                          // width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            children: [
                              SizedBox(height: 15,),
                              Image(
                                image:
                                    AssetImage('assets/images/list_icon.png'),
                                height: 80,
                                width: 80,
                              ),
                              Text(
                                "View Drivers List",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow
                                    .ellipsis, // Ensures text doesn’t overflow
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
