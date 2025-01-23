import 'package:vbms/controllers/booking/mytripdetailscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTripDetails extends StatelessWidget {
  const MyTripDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyTripDetailsController>(
      init: MyTripDetailsController(),
      builder: (mtd) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
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
              "Details",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter-Medium',
                  fontSize: 20),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
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
            child: mtd.isLoading == true
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          foregroundImage:
                              AssetImage('assets/gif/tracking.gif'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Loading...',
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 14,
                              fontFamily: "Inter-Medium"),
                        )
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Booking Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.purple,
                                  fontFamily: 'Inter-Medium',
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.purple.shade200,
                                          blurRadius: 10,
                                          spreadRadius: 2)
                                    ],
                                    color: Colors.white),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Table(
                                      children: [
                                        TableRow(children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                mtd.argData['status'] == null
                                                    ? "--"
                                                    : mtd.argData['status']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Booking ID',
                                                style: TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                mtd.argData['vehicleBookingId'] ==
                                                        null
                                                    ? "--"
                                                    : mtd.argData[
                                                            'vehicleBookingId']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Booked For',
                                                style: TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                mtd.argData['BookingFor'] ==
                                                        null
                                                    ? "--"
                                                    : mtd.argData['BookingFor']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Pick Up',
                                                style: TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                mtd.argData['pickUp'] == null
                                                    ? "--"
                                                    : mtd.argData['pickUp']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Drop At',
                                                style: TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                mtd.argData['dropAt'] == null
                                                    ? "--"
                                                    : mtd.argData['dropAt']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Date'),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                mtd.argData['date'] == null
                                                    ? "--"
                                                    : mtd.argData['date']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Time',
                                                style: TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                mtd.argData['time'] == null
                                                    ? "--"
                                                    : mtd.argData['time']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    fontSize: 14,
                                                    color: Color(0xFF2c3252)),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              mtd.argData['driver'] == null
                                  ? Container()
                                  : Visibility(
                                      visible:
                                          mtd.argData['status'] == "Accepted" ||
                                                  mtd.argData['status'] ==
                                                      "On Going"
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
                                              fontFamily: 'Inter-Medium',
                                              fontSize: 16,
                                              color: Colors.purple,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors
                                                          .purple.shade200,
                                                      blurRadius: 10,
                                                      spreadRadius: 2)
                                                ],
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Table(
                                                  children: [
                                                    TableRow(children: [
                                                      const TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            'Name',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Inter-Medium',
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xFF2c3252)),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            mtd.argData['driver']
                                                                        [
                                                                        'fullName'] ==
                                                                    null
                                                                ? "--"
                                                                : mtd.argData[
                                                                        'driver']
                                                                        [
                                                                        'fullName']
                                                                    .toString(),
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Inter-Medium',
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xFF2c3252)),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      const TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            'Mobile No.',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Inter-Medium',
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xFF2c3252)),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            mtd.argData['driver']
                                                                        [
                                                                        'mobile'] ==
                                                                    null
                                                                ? "--"
                                                                : mtd.argData[
                                                                        'driver']
                                                                        [
                                                                        'mobile']
                                                                    .toString(),
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Inter-Medium',
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xFF2c3252)),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Vehicle Details',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Inter-Medium',
                                              color: Colors.purple,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors
                                                          .purple.shade200,
                                                      blurRadius: 10,
                                                      spreadRadius: 2)
                                                ],
                                                color: Colors.white),
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Table(
                                                  children: [
                                                    TableRow(children: [
                                                      const TableCell(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            'Name',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Inter-Medium',
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xFF2c3252)),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            mtd.argData['vehicle']
                                                                        [
                                                                        'vehicleName'] ==
                                                                    null
                                                                ? "--"
                                                                : mtd.argData[
                                                                        'vehicle']
                                                                        [
                                                                        'vehicleName']
                                                                    .toString(),
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Inter-Medium',
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xFF2c3252)),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              if (mtd.argData['status'] == "Accepted") {
                mtd.gotoMapsAccepted();
              } else if (mtd.argData['status'] == "On Going") {
                mtd.gotoOnGoingMaps();
              } else {
                Get.back();
              }
            },
            child: Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: mtd.argData['status'] == "Accepted" ||
                        mtd.argData['status'] == "On Going"
                    ? const Text(
                        'show on Map',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Inter-Medium',
                        ),
                      )
                    : const Text(
                        'Close',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Inter-Medium',
                        ),
                      )),
          ),
        );
      },
    );
  }
}
