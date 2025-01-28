import 'package:vbms/views/booking/mytripdetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/booking/mytripscontroller.dart';

class MyTrips extends StatelessWidget {
  const MyTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyTripsController>(
      init: MyTripsController(),
      builder: (mtc) {
        return Scaffold(
          backgroundColor: Colors.pink.shade50,
          // appBar: AppBar(
          //   backgroundColor: Colors.purple,
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
          //     "My Trips",
          //     style:
          //         TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          //   ),
          //   iconTheme: const IconThemeData(color: Colors.white),
          // ),
          body: mtc.isLoading == true
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        foregroundImage: AssetImage('packages/vbms/assets/gif/tracking.gif'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Loading...',
                        style: TextStyle(
                            fontFamily: 'Inter-Medium',
                            color: Colors.purple,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                )
              : mtc.myTrips.isEmpty
                  ? Center(
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
                            style: TextStyle(
                                fontFamily: 'Inter-Medium',
                                color: Colors.purple,
                                fontSize: 14,
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: mtc.myTrips.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => const MyTripDetails(),
                                  arguments: mtc.myTrips[index]);
                            },
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              color: const Color(0xFFE4E8EA),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          mtc.myTrips[index]['status'] == null
                                              ? 'No Status'
                                              : mtc.myTrips[index]['status']
                                                  .toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Inter-Medium',
                                              color: Color(0xFF2a2a2a),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          mtc.myTrips[index]['date'] == null
                                              ? '--'
                                              : mtc.myTrips[index]['date']
                                                  .toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Inter-Medium',
                                              color: Color(0xFF2a2a2a),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 15,
                                                  color: Colors.purple,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                SizedBox(
                                                  width: 250,
                                                  child: Text(
                                                    mtc.myTrips[index]
                                                                ['pickUp'] ==
                                                            null
                                                        ? '--'
                                                        : mtc.myTrips[index]
                                                                ['pickUp']
                                                            .toString()
                                                            .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF2a2a2a),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 15,
                                                  color: Colors.purple,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                SizedBox(
                                                  width: 250,
                                                  child: Text(
                                                    mtc.myTrips[index]
                                                                ['dropAt'] ==
                                                            null
                                                        ? '--'
                                                        : mtc.myTrips[index]
                                                                ['dropAt']
                                                            .toString()
                                                            .toUpperCase(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF2a2a2a),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.purple,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Booking ID :',
                                          style: TextStyle(
                                              color: Color(0xFF2a2a2a),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          mtc.myTrips[index]
                                                      ['vehicleBookingId'] ==
                                                  null
                                              ? '--'
                                              : mtc.myTrips[index]
                                                      ['vehicleBookingId']
                                                  .toString(),
                                          style: const TextStyle(
                                              color: Color(0xFF2a2a2a),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )),
        );
      },
    );
  }
}
