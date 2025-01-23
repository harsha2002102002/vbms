import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/apiservice.dart';
import '../../views/booking/mytripdetails.dart';

class BottomMyTripsScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  bool isLoading = true;
  List myTrips = [];
  @override
  void onInit() {
    // TODO: implement onInit
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    getMyTrips(0);
    super.onInit();
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  getMyTrips(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var airportRegId = prefs.getString("airportRegId").toString();
    var deptID = prefs.getString("deptID").toString();
    log('airport id is $airportRegId');
    log('dept id is $deptID');
    ApiService.get(
            'vehicleBookingList?airportRegId=$airportRegId&departmentId=$deptID&pageIndex=$index')
        .then((success) {
      log('status code is ${success.statusCode}');
      if (success.statusCode == 200) {
        var data = jsonDecode(success.body);
        log(data['status'].toString());
        if (data['status'].toString() == 'true') {
          myTrips = data['data'];
          log('my trips list is $myTrips');
          if (isLoading == true) {
            log('is loading is $isLoading');
            Future.delayed(const Duration(seconds: 5), () {
              isLoading = false;
              log('is loading is $isLoading');
              update();
            });
          }
          update();
        }
        update();
      } else {
        Get.rawSnackbar(
            message: 'Something went wrong, Please try again later');
      }
      update();
    });

    update();
  }

  buildOnGoing() {
    return Scaffold(
      body: isLoading == true
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    foregroundImage: AssetImage('assets/gif/tracking.gif'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Loading...',
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                      fontFamily: "Inter-Medium",),
                  )
                ],
              ),
            )
          : myTrips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/gif/carAnimation.gif',
                        scale: 0.6,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'No Records Found',
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 14,
                          fontFamily: "Inter-Medium",),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: myTrips.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => const MyTripDetails(),
                            arguments: myTrips[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.purple.shade200,
                                  blurRadius: 10,
                                  spreadRadius: 2)
                            ],
                            color: Colors.white),
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
                                    myTrips[index]['status'] == null
                                        ? '--'
                                        : myTrips[index]['status'].toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF2a2a2a),
                                        fontFamily: "Inter-Medium",
                                        fontSize: 12),
                                  ),
                                  Text(
                                    myTrips[index]['date'] == null
                                        ? '--'
                                        : myTrips[index]['date'].toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF2a2a2a),
                                        fontFamily: "Inter-Medium",
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
                                              myTrips[index]['pickUp'] == null
                                                  ? '--'
                                                  : myTrips[index]['pickUp']
                                                      .toString()
                                                      .toUpperCase(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Color(0xFF2a2a2a),
                                                  fontFamily: "Inter-Medium",
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
                                              myTrips[index]['dropAt'] == null
                                                  ? '--'
                                                  : myTrips[index]['dropAt']
                                                      .toString()
                                                      .toUpperCase(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Color(0xFF2a2a2a),
                                                  fontFamily: "Inter-Medium",
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
                                        fontFamily: "Inter-Medium",
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    myTrips[index]['vehicleBookingId'] == null
                                        ? '--'
                                        : myTrips[index]['vehicleBookingId']
                                            .toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF2a2a2a),
                                        fontFamily: "Inter-Medium",
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
                ),
    );
  }

  buildCompleted() {
    return Scaffold(
      body: isLoading == true
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    foregroundImage: AssetImage('assets/gif/tracking.gif'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Loading...',
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                      fontFamily: "Inter-Medium",),
                  )
                ],
              ),
            )
          : myTrips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/gif/carAnimation.gif',
                        scale: 0.6,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'No Records Found',
                        style: TextStyle(
                            fontFamily: "Inter-Medium",
                            color: Colors.purple,
                            fontSize: 14,),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: myTrips.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => const MyTripDetails(),
                            arguments: myTrips[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.purple.shade200,
                                  blurRadius: 10,
                                  spreadRadius: 2)
                            ],
                            color: Colors.white),
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
                                    myTrips[index]['status'] == null
                                        ? 'No Status'
                                        : myTrips[index]['status'].toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF2a2a2a),
                                        fontFamily: "Inter-Medium",
                                        fontSize: 12),
                                  ),
                                  Text(
                                    myTrips[index]['date'] == null
                                        ? '--'
                                        : myTrips[index]['date'].toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF2a2a2a),
                                        fontFamily: "Inter-Medium",
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
                                              myTrips[index]['pickUp'] == null
                                                  ? '--'
                                                  : myTrips[index]['pickUp']
                                                      .toString()
                                                      .toUpperCase(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Color(0xFF2a2a2a),
                                                  fontFamily: "Inter-Medium",
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
                                              myTrips[index]['dropAt'] == null
                                                  ? '--'
                                                  : myTrips[index]['dropAt']
                                                      .toString()
                                                      .toUpperCase(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: "Inter-Medium",
                                                  color: Color(0xFF2a2a2a),
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
                                        fontFamily: "Inter-Medium",
                                        color: Color(0xFF2a2a2a),
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    myTrips[index]['vehicleBookingId'] == null
                                        ? '--'
                                        : myTrips[index]['vehicleBookingId']
                                            .toString(),
                                    style: const TextStyle(
                                      fontFamily: "Inter-Medium",
                                        color: Color(0xFF2a2a2a),
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
                ),
    );
  }
}
