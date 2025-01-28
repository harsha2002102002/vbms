import 'dart:developer';
import 'package:vbms/controllers/caboperator/vehicle/vehiclehomecontroller.dart';
import 'package:vbms/views/caboperator/vehicle/viewvehiclelist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'addvehicle.dart';

class VehicleHome extends StatelessWidget {
  const VehicleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VehicleHomeController>(
        init: VehicleHomeController(),
        builder: (vhc) => Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                title: const Text(
                  "Vehicle",
                  style: TextStyle(fontFamily: 'Inter-Medium',
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // centerTitle: true,
                backgroundColor: Colors.purple,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                  size: 35,
                ),
              ),
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
                          Get.to(() => const AddVehicle());
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
                              SizedBox(
                                height: 15,
                              ),
                              Image(
                                image: AssetImage('packages/vbms/assets/images/add_icon.png'),
                                height: 80,
                                width: 80,
                              ),
                              Text("Add Vehicle",
                                  style: TextStyle(fontFamily: 'Inter-Medium',
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
                          Get.to(() => const ViewVehicleList());
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
                              SizedBox(
                                height: 15,
                              ),
                              Image(
                                image:
                                    AssetImage('packages/vbms/assets/images/list_icon.png'),
                                height: 80,
                                width: 80,
                              ),
                              Flexible(
                                child: Text(
                                  "View Vehicle List",
                                  style: TextStyle(
                                      fontFamily: 'Inter-Medium',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow
                                      .ellipsis, // Ensures text doesn’t overflow
                                ),
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
