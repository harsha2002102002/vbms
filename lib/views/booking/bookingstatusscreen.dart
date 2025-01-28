import 'dart:developer';
import 'package:vbms/views/home/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vbms/controllers/booking/bookingstatusscreencontroller.dart';
import 'package:blur/blur.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingStatusScreen extends StatelessWidget {
  const BookingStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingStatusScreenController>(
      init: BookingStatusScreenController(),
      builder: (bsc) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Awaiting Confirmation',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.purple,
            actions: [
              GestureDetector(
                onTap: () {
                  Get.offAll(() => const BottomTile());
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              // Top half: Blurred map background
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Blur(
                        blur: 3,
                        blurColor: Colors.white,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(17.7413, 83.3345), zoom: 17),
                        ),
                      ),
                    ),
                    bsc.isFabExpanded
                        ? Container(
                            decoration: const BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Booking Details',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.purple,
                                              width: 2,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          child: Table(
                                            columnWidths: const {
                                              0: FractionColumnWidth(0.4),
                                              1: FractionColumnWidth(0.6),
                                            },
                                            children: [
                                              TableRow(children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Status:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    bsc.bookingStatus ?? "--",
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'User Name:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    bsc.bookingDetails[
                                                            'BookingFor'] ??
                                                        "--",
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Booking ID:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    bsc.bookingDetails[
                                                            'vehicleBookingId'] ??
                                                        "--",
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Pick Up:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    bsc.bookingDetails[
                                                            'pickUp'] ??
                                                        "--",
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Drop At:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    bsc.bookingDetails[
                                                            'dropAt'] ??
                                                        "--",
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Date:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    bsc.bookingDetails[
                                                            'date'] ??
                                                        "--",
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Time:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    bsc.bookingDetails[
                                                            'time'] ??
                                                        "--",
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    bsc.acceptBookingDetails.isNotEmpty
                                        ? Visibility(
                                            visible:
                                                bsc.bookingStatus == "Accepted"
                                                    ? true
                                                    : false,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 20),
                                                const Text(
                                                  'Driver Details',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.purple,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.purple,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Table(
                                                    columnWidths: const {
                                                      0: FractionColumnWidth(
                                                          0.4),
                                                      1: FractionColumnWidth(
                                                          0.6),
                                                    },
                                                    children: [
                                                      TableRow(children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            'Name:',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            bsc.acceptBookingDetails[
                                                                        'driver']
                                                                    [
                                                                    'fullName'] ??
                                                                "--",
                                                          ),
                                                        ),
                                                      ]),
                                                      TableRow(children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            'Mobile No. :',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            bsc.acceptBookingDetails[
                                                                        'driver']
                                                                    [
                                                                    'mobile'] ??
                                                                "--",
                                                          ),
                                                        ),
                                                      ]),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                const Text(
                                                  'Vehicle Details',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.purple,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.purple,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Table(
                                                    columnWidths: const {
                                                      0: FractionColumnWidth(
                                                          0.4),
                                                      1: FractionColumnWidth(
                                                          0.6),
                                                    },
                                                    children: [
                                                      TableRow(children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            'Vehicle Name:',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            bsc.acceptBookingDetails[
                                                                        'vehicle']
                                                                    [
                                                                    'vehicleName'] ??
                                                                "--",
                                                          ),
                                                        ),
                                                      ]),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (bsc.bookingStatus == "Accepted" &&
                                    bsc.isLoading)
                                  const Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        foregroundImage: AssetImage(
                                            'packages/vbms/assets/gif/tracking.gif'),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Hurray . . .\nCaptain accepted your ride, Please wait",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                if (bsc.bookingStatus == "Booking")
                                  const Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        foregroundImage: AssetImage(
                                            'packages/vbms/assets/gif/tracking.gif'),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Hold on . . .\nWaiting for captain to accept your ride",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: Stack(
            children: [
              bsc.isFabExpanded
                  ? Positioned(
                      bottom: 80,
                      right: 16,
                      child: AnimatedOpacity(
                        opacity: bsc.isFabExpanded ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: FloatingActionButton(
                          heroTag: "subFab1",
                          backgroundColor: Colors.purple,
                          onPressed: () {
                            log('Sub FAB 1 pressed');
                          },
                          child: const Icon(Icons.info, color: Colors.white),
                        ),
                      ),
                    )
                  : Positioned(
                      bottom: 140,
                      right: 16,
                      child: AnimatedOpacity(
                        opacity: bsc.isFabExpanded ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: FloatingActionButton(
                          heroTag: "subFab2",
                          backgroundColor: Colors.purple,
                          onPressed: () {
                            log('Sub FAB 2 pressed');
                          },
                          child:
                              const Icon(Icons.settings, color: Colors.white),
                        ),
                      ),
                    ),
              FloatingActionButton(
                tooltip: "Show Details",
                backgroundColor: Colors.purple,
                onPressed: () {
                  bsc.fabIconAnimation();
                },
                child: Icon(
                  bsc.isFabExpanded ? Icons.close : Icons.info_outline,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
