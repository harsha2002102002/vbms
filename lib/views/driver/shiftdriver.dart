import 'dart:developer';

import 'package:vbms/controllers/driver/shiftdrivercontroller.dart';
import 'package:vbms/views/landingpage/landingpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShiftDriver extends StatefulWidget {
  const ShiftDriver({super.key});

  @override
  State<ShiftDriver> createState() => _ShiftDriverState();
}

class _ShiftDriverState extends State<ShiftDriver> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShiftDriverController>(
        init: ShiftDriverController(),
        builder: (sdc) => Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Get.off(() => const LandingPage());
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
                title: const Text(
                  "Driver Shift",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.purple,
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white, size: 30),
              ),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                        key: sdc.shiftFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            // const Padding(
                            //   padding: EdgeInsets.all(8),
                            //   child: Text("Vehicles",
                            //       style: TextStyle(
                            //           color: Colors.black, fontSize: 16)),
                            // ),
                            DropdownButtonFormField(
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF2a2a2a)),
                              value: sdc.vehicleId,
                              decoration: const InputDecoration(
                                hintText: "Select Vehicle",
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 1.5)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 1.5)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 1.5)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select a vehicle";
                                }
                                return null;
                              },
                              items: sdc.vehicleList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem(
                                  value: value['vehicleId'].toString(),
                                  child: Text(value['vehicleName'].toString()),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                log(newValue.toString());
                                sdc.handleVehicle(newValue);
                              },
                            ),
                            SizedBox(height: 100,),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (sdc.shiftFormKey.currentState!
                                      .validate()) {
                                    sdc.handleShiftStart();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Makes it rectangular
                                  ),
                                ),
                                child: Text(
                                  "Shift Start",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ));
  }
}
