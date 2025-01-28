import 'dart:convert';

import 'package:vbms/controllers/driver/myridescontroller.dart';
import 'package:vbms/views/driver/tripdetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRides extends StatefulWidget {
  const MyRides({super.key});

  @override
  State<MyRides> createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyRidesController>(
        init: MyRidesController(),
        builder: (mrc) => Scaffold(
            backgroundColor: Colors.pink.shade50,
            // appBar: AppBar(
            //   leading: GestureDetector(
            //     onTap: () {
            //       Get.back();
            //     },
            //     child: const Icon(
            //       Icons.arrow_back_ios,
            //       size: 30,
            //     ),
            //   ),
            //   title: const Text(
            //     "My Rides",
            //     style:
            //         TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            //   ),
            //   backgroundColor: Colors.purple,
            //   iconTheme: const IconThemeData(color: Colors.white, size: 30),
            // ),
            body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: mrc.isLoading == true
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              foregroundImage:
                                  AssetImage('packages/vbms/assets/gif/tracking.gif'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Loading...',
                              style: TextStyle(fontFamily: 'Inter-Medium',
                                  color: Colors.purple,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                      )
                    : mrc.rides.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: mrc.rides.length,
                            itemBuilder: (BuildContext context, index) {
                              var ride = mrc.rides[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.black12),
                                  child: Table(
                                    children: [
                                      TableRow(children: [
                                        const TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            'Booking ID',
                                            style: TextStyle(
                                                fontSize: 16,fontFamily: 'Inter-Medium',
                                                color: Color(0xFF2c3252)),
                                          ),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                              ride['vehicleBookingId']
                                                  .toString(),
                                              style: const TextStyle(fontFamily: 'Inter-Medium',
                                                  fontSize: 16,
                                                  color: Color(0xFF2c3252))),
                                        )),
                                      ]),
                                      TableRow(children: [
                                        const TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            'Booked By',
                                            style: TextStyle(
                                                fontSize: 16,fontFamily: 'Inter-Medium',
                                                color: Color(0xFF2c3252)),
                                          ),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                              ride['tripDetails']['BookingFor']
                                                  .toString(),
                                              style: const TextStyle(fontFamily: 'Inter-Medium',
                                                  fontSize: 16,
                                                  color: Color(0xFF2c3252))),
                                        )),
                                      ]),
                                      TableRow(children: [
                                        const TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            'Pick Up',
                                            style: TextStyle(
                                                fontSize: 16,fontFamily: 'Inter-Medium',
                                                color: Color(0xFF2c3252)),
                                          ),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                              ride['tripDetails']['pickUp']
                                                  .toString(),
                                              style: const TextStyle(fontFamily: 'Inter-Medium',
                                                  fontSize: 16,
                                                  color: Color(0xFF2c3252))),
                                        )),
                                      ]),
                                      TableRow(children: [
                                        const TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            'Drop at',
                                            style: TextStyle(fontFamily: 'Inter-Medium',
                                                fontSize: 16,
                                                color: Color(0xFF2c3252)),
                                          ),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                              ride['tripDetails']['dropAt']
                                                  .toString(),
                                              style: const TextStyle(fontFamily: 'Inter-Medium',
                                                  fontSize: 16,
                                                  color: Color(0xFF2c3252))),
                                        )),
                                      ]),
                                      TableRow(children: [
                                        const TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            'Date & Time',
                                            style: TextStyle(fontFamily: 'Inter-Medium',
                                                fontSize: 16,
                                                color: Color(0xFF2c3252)),
                                          ),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                              "${ride['tripDetails']['date'].toString()} ${ride['tripDetails']['time'].toString()}",
                                              style: const TextStyle(fontFamily: 'Inter-Medium',
                                                  fontSize: 16,
                                                  color: Color(0xFF2c3252))),
                                        )),
                                      ]),
                                      TableRow(children: [
                                        const TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text(
                                            'Status',
                                            style: TextStyle(fontFamily: 'Inter-Medium',
                                                fontSize: 16,
                                                color: Color(0xFF2c3252)),
                                          ),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(ride['status'],
                                              style: const TextStyle(fontFamily: 'Inter-Medium',
                                                  fontSize: 16,
                                                  color: Color(0xFF2c3252))),
                                        )),
                                      ]),
                                      TableRow(children: [
                                        TableCell(child: Container()),
                                        TableCell(
                                            child: ElevatedButton(
                                          onPressed: () {
                                            if (ride['status'].toString() ==
                                                "Accepted") {
                                              mrc.gotoMapsAccepted(ride);
                                            } else if (ride['status']
                                                    .toString() ==
                                                "On Going") {
                                              mrc.gotoOnGoingMaps(ride);
                                            } else {
                                              var encodeData = jsonEncode({
                                                "vehicleBookingId":
                                                    ride['vehicleBookingId'],
                                                "BookingFor":
                                                    ride['tripDetails']
                                                        ['BookingFor'],
                                                "pickUp": ride['tripDetails']
                                                    ['pickUp'],
                                                "dropAt": ride['tripDetails']
                                                    ['dropAt'],
                                                "date": ride['tripDetails']
                                                    ['date'],
                                                "time": ride['tripDetails']
                                                    ['time'],
                                                "status": ride['status'],
                                                "pickupLatitude":
                                                    ride['tripDetails']
                                                        ['pickupLatitude'],
                                                "pickupLongitude":
                                                    ride['tripDetails']
                                                        ['pickupLongitude'],
                                                "dropAtLatitude":
                                                    ride['tripDetails']
                                                        ['dropAtLatitude'],
                                                "dropAtLongitude":
                                                    ride['tripDetails']
                                                        ['dropAtLongitude'],
                                                "airportId": ride['tripDetails']
                                                    ['airportId'],
                                                "airportRegId":
                                                    ride['airportRegId'],
                                                "departmentId":
                                                    ride['tripDetails']
                                                        ['departmentId'],
                                                "departmentTypeId":
                                                    ride['tripDetails']
                                                        ['departmentTypeId'],
                                              });
                                              var decodeData =
                                                  jsonDecode(encodeData);
                                              Get.to(() => const TripDetails(),
                                                  arguments: decodeData);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.purple,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  10), // Makes it rectangular
                                            ),
                                          ),
                                          child: ride['status'].toString() ==
                                                      "Accepted" ||
                                                  ride['status'].toString() ==
                                                      "On Going"
                                              ? const Text(
                                                  "show on Map",
                                                  style: TextStyle(fontFamily: 'Inter-Medium',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              : const Text(
                                                  "Trip Details",
                                                  style: TextStyle(fontFamily: 'Inter-Medium',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                        )),
                                      ])
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'packages/vbms/assets/gif/carAnimation.gif',
                                  scale: 0.6,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'No Records Found',
                                  style: TextStyle(fontFamily: 'Inter-Medium',
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ))));
  }
}
