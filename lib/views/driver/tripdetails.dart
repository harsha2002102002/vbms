import 'dart:developer';

import 'package:vbms/maps/googlemaps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../controllers/driver/tripdetailscontroller.dart';

class TripDetails extends StatelessWidget {
  const TripDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripDetailsController>(
      init: TripDetailsController(),
      builder: (tdc) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
            ),
            title: const Text(
              "Trip Details",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Inter-Medium",
                  fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.purple,
            iconTheme: const IconThemeData(color: Colors.white, size: 30),
          ),
          body: Container(
            height: Get.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                  Color(0xFFDFD0DF),
                  Color(0xFFDFD0DF),
                ],
                begin: Alignment.topLeft, // Start of the gradient
                end: Alignment.bottomRight, // End of the gradient
              ),
            ),
            width: Get.width,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.purple.shade200,
                            blurRadius: 10,
                            spreadRadius: 2)
                      ],
                      color: Colors.white),
                  padding: const EdgeInsets.all(20),
                  child: Table(
                    children: [
                      TableRow(children: [
                        const TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Booking ID',
                            style: TextStyle(
                                fontFamily: 'Inter-Medium',
                                fontSize: 14,
                                color: Color(0xFF2c3252)),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                              tdc.argData['vehicleBookingId'].toString(),
                              style: const TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                      ]),
                      TableRow(children: [
                        const TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Booked By',
                            style: TextStyle(
                                fontFamily: 'Inter-Medium',
                                fontSize: 14,
                                color: Color(0xFF2c3252)),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(tdc.argData['BookingFor'].toString(),
                              style: const TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                      ]),
                      TableRow(children: [
                        const TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text('Pick Up Location',
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(tdc.argData['pickUp'].toString(),
                              style: const TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                      ]),
                      TableRow(children: [
                        const TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text('Drop Location',
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(tdc.argData['dropAt'].toString(),
                              style: const TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                      ]),
                      TableRow(children: [
                        const TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text('Booking Date',
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(tdc.argData['date'].toString(),
                              style: const TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                      ]),
                      TableRow(children: [
                        const TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text('Booking Time',
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(tdc.argData['time'].toString(),
                              style: const TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                      ]),
                      TableRow(children: [
                        const TableCell(
                            child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text('Status',
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(tdc.argData['status'].toString(),
                              style: const TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 14,
                                  color: Color(0xFF2c3252))),
                        )),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 50,
              width: 300,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'Inter-Medium',
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
