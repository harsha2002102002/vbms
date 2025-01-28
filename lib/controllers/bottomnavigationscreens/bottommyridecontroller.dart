import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/apiservice.dart';
import '../../maps/googlemaps.dart';
import '../../views/driver/tripdetails.dart';

class BottomMyRidesScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  List rides = [];
  String? airportRegId;
  String? driverId;
  bool isLoading = true;

  @override
  void onInit() {
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    loadLoginData();
    // TODO: implement onInit
    super.onInit();
  }

  loadLoginData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    log("LoadingData");
    airportRegId = pref.getString("airportRegId").toString();
    driverId = pref.getString("driverId").toString();
    loadMyRides(0);
    if (isLoading == true) {
      log('is loading is $isLoading');
      Future.delayed(const Duration(seconds: 10), () {
        isLoading = false;
        log('is loading is $isLoading');
        update();
      });
    }
    update();
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  buildOnGoing() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isLoading == true
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
                        color: Colors.purple,
                        fontSize: 14,
                      fontFamily: "Inter-Medium",),
                  )
                ],
              ),
            )
          : rides.isNotEmpty
              ? ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    var ride = rides[index];
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.purple.shade200,
                                blurRadius: 10,
                                spreadRadius: 2)
                          ],
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ride['status'] == null
                                    ? '--'
                                    : ride['status'].toString(),
                                style: const TextStyle(
                                    color: Color(0xFF2a2a2a),
                                    fontFamily: "Inter-Medium",
                                    fontSize: 12),
                              ),
                              Text(
                                ride['tripDetails']['date'] == null ||
                                        ride['tripDetails'] == null
                                    ? '--'
                                    : ride['tripDetails']['date'].toString(),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    width: 280,
                                    child: Text(
                                      ride['tripDetails']['pickUp'] == null ||
                                              ride['tripDetails'] == null
                                          ? '--'
                                          : ride['tripDetails']['pickUp']
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
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    width: 280,
                                    child: Text(
                                      ride['tripDetails']['dropAt'] == null ||
                                              ride['tripDetails'] == null
                                          ? '--'
                                          : ride['tripDetails']['dropAt']
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
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                    width: 5,
                                  ),
                                  Text(
                                    ride['vehicleBookingId'] == null
                                        ? '--'
                                        : ride['vehicleBookingId'].toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF2a2a2a),
                                        fontFamily: "Inter-Medium",
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (ride['status'].toString() == "Accepted") {
                                    gotoMapsAccepted(ride);
                                  } else if (ride['status'].toString() ==
                                      "On Going") {
                                    gotoOnGoingMaps(ride);
                                  } else {
                                    var encodeData = jsonEncode({
                                      "vehicleBookingId":
                                          ride['vehicleBookingId'],
                                      "BookingFor": ride['tripDetails']
                                          ['BookingFor'],
                                      "pickUp": ride['tripDetails']['pickUp'],
                                      "dropAt": ride['tripDetails']['dropAt'],
                                      "date": ride['tripDetails']['date'],
                                      "time": ride['tripDetails']['time'],
                                      "status": ride['status'],
                                      "pickupLatitude": ride['tripDetails']
                                          ['pickupLatitude'],
                                      "pickupLongitude": ride['tripDetails']
                                          ['pickupLongitude'],
                                      "dropAtLatitude": ride['tripDetails']
                                          ['dropAtLatitude'],
                                      "dropAtLongitude": ride['tripDetails']
                                          ['dropAtLongitude'],
                                      "airportId": ride['tripDetails']
                                          ['airportId'],
                                      "airportRegId": ride['airportRegId'],
                                      "departmentId": ride['tripDetails']
                                          ['departmentId'],
                                      "departmentTypeId": ride['tripDetails']
                                          ['departmentTypeId'],
                                    });
                                    var decodeData = jsonDecode(encodeData);
                                    Get.to(() => const TripDetails(),
                                        arguments: decodeData);
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ride['status'].toString() ==
                                                "Accepted" ||
                                            ride['status'].toString() ==
                                                "On Going"
                                        ? const Text(
                                            "show on Map",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 14),
                                          )
                                        : const Text(
                                            "Trip Details",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 14),
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
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
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          fontFamily: "Inter-Medium",),
                      )
                    ],
                  ),
                ),
    );
  }

  buildCompleted() {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          : rides.isNotEmpty
              ? ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    var ride = rides[index];
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.purple.shade200,
                                blurRadius: 10,
                                spreadRadius: 2)
                          ],
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ride['status'] == null
                                    ? '--'
                                    : ride['status'].toString(),
                                style: const TextStyle(
                                    color: Color(0xFF2a2a2a),
                                    fontFamily: "Inter-Medium",
                                    fontSize: 12),
                              ),
                              Text(
                                ride['tripDetails']['date'] == null ||
                                        ride['tripDetails'] == null
                                    ? '--'
                                    : ride['tripDetails']['date'].toString(),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    width: 280,
                                    child: Text(
                                      ride['tripDetails']['pickUp'] == null ||
                                              ride['tripDetails'] == null
                                          ? '--'
                                          : ride['tripDetails']['pickUp']
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
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    width: 280,
                                    child: Text(
                                      ride['tripDetails']['dropAt'] == null ||
                                              ride['tripDetails'] == null
                                          ? '--'
                                          : ride['tripDetails']['dropAt']
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
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                    width: 5,
                                  ),
                                  Text(
                                    ride['vehicleBookingId'] == null
                                        ? '--'
                                        : ride['vehicleBookingId'].toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF2a2a2a),
                                        fontFamily: "Inter-Medium",
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (ride['status'].toString() == "Accepted") {
                                    gotoMapsAccepted(ride);
                                  } else if (ride['status'].toString() ==
                                      "On Going") {
                                    gotoOnGoingMaps(ride);
                                  } else {
                                    var encodeData = jsonEncode({
                                      "vehicleBookingId":
                                          ride['vehicleBookingId'],
                                      "BookingFor": ride['tripDetails']
                                          ['BookingFor'],
                                      "pickUp": ride['tripDetails']['pickUp'],
                                      "dropAt": ride['tripDetails']['dropAt'],
                                      "date": ride['tripDetails']['date'],
                                      "time": ride['tripDetails']['time'],
                                      "status": ride['status'],
                                      "pickupLatitude": ride['tripDetails']
                                          ['pickupLatitude'],
                                      "pickupLongitude": ride['tripDetails']
                                          ['pickupLongitude'],
                                      "dropAtLatitude": ride['tripDetails']
                                          ['dropAtLatitude'],
                                      "dropAtLongitude": ride['tripDetails']
                                          ['dropAtLongitude'],
                                      "airportId": ride['tripDetails']
                                          ['airportId'],
                                      "airportRegId": ride['airportRegId'],
                                      "departmentId": ride['tripDetails']
                                          ['departmentId'],
                                      "departmentTypeId": ride['tripDetails']
                                          ['departmentTypeId'],
                                    });
                                    var decodeData = jsonDecode(encodeData);
                                    Get.to(() => const TripDetails(),
                                        arguments: decodeData);
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ride['status'].toString() ==
                                                "Accepted" ||
                                            ride['status'].toString() ==
                                                "On Going"
                                        ? const Text(
                                            "show on Map",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 14),
                                          )
                                        : const Text(
                                            "Trip Details",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Inter-Medium",
                                                fontSize: 14),
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
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
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: "Inter-Medium",
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  loadMyRides(index) async {
    await ApiService.get(
            'driverAcceptedList?airportRegId=$airportRegId&driverId=$driverId&pageIndex=$index')
        .then((success) {
      log('status code is ${success.statusCode}');
      if (success.statusCode == 200) {
        var data = jsonDecode(success.body);
        // log('response is $data');
        log(data['status'].toString());
        if (data['status'].toString() == 'true') {
          rides = data['data'];
          log('my ride list is $rides');
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
        isLoading = false;
        update();
      }
    });
  }

  gotoMapsAccepted(ride) {
    log('---------->>>$ride');
    var pLatitude = ride['tripDetails']['driverLatitude'].toString().isNotEmpty
        ? double.parse(ride['tripDetails']['driverLatitude'].toString())
        : 0.0;
    var dLatitude = ride['tripDetails']['pickupLatitude'].toString().isNotEmpty
        ? double.parse(ride['tripDetails']['pickupLatitude'].toString())
        : 0.0;
    var pLongitude =
        ride['tripDetails']['driverLongitude'].toString().isNotEmpty
            ? double.parse(ride['tripDetails']['driverLongitude'].toString())
            : 0.0;
    var dLongitude =
        ride['tripDetails']['pickupLongitude'].toString().isNotEmpty
            ? double.parse(ride['tripDetails']['pickupLongitude'].toString())
            : 0.0;
    Get.off(() => GoogleMapScreen(
          dLatitude: dLatitude,
          dLongitude: dLongitude,
          pLatitude: pLatitude,
          pLongitude: pLongitude,
          tripData: ride,
          tripStatus: ride['status'],
        ));
    update();
  }

  gotoOnGoingMaps(ride) {
    log('---------->>>$ride');
    var pLatitude = ride['tripDetails']['pickupLatitude'].toString().isNotEmpty
        ? double.parse(ride['tripDetails']['pickupLatitude'].toString())
        : 0.0;
    var dLatitude = ride['tripDetails']['dropAtLatitude'].toString().isNotEmpty
        ? double.parse(ride['tripDetails']['dropAtLatitude'].toString())
        : 0.0;
    var pLongitude =
        ride['tripDetails']['pickupLongitude'].toString().isNotEmpty
            ? double.parse(ride['tripDetails']['pickupLongitude'].toString())
            : 0.0;
    var dLongitude =
        ride['tripDetails']['dropAtLongitude'].toString().isNotEmpty
            ? double.parse(ride['tripDetails']['dropAtLongitude'].toString())
            : 0.0;
    Get.off(() => GoogleMapScreen(
          dLatitude: dLatitude,
          dLongitude: dLongitude,
          pLatitude: pLatitude,
          pLongitude: pLongitude,
          tripData: ride,
          tripStatus: ride['status'],
        ));
    update();
  }
}
