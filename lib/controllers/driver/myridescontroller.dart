import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/apiservice.dart';
import '../../maps/googlemaps.dart';

class MyRidesController extends GetxController {
  List rides = [];
  String? airportRegId;
  String? driverId;
  bool isLoading = true;

  @override
  void onInit() {
    // TODO: implement onInit
    loadLoginData();
    super.onInit();
  }

  loadLoginData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    log("LoadingData");
    airportRegId = pref.getString("airportRegId").toString();
    driverId = pref.getString("driverId").toString();
    loadMyRides();
    if (isLoading == true) {
      log('is loading is $isLoading');
      Future.delayed(const Duration(seconds: 10), () {
        isLoading = false;
        // Get.rawSnackbar(
        //     message: 'Something went wrong, Please try again later');
        log('is loading is $isLoading');
        update();
      });
    }
    update();
  }

  loadMyRides() async {
    await ApiService.get(
            'driverAcceptedList?airportRegId=$airportRegId&driverId=$driverId')
        .then((success) {
      log('status code is ${success.statusCode}');
      if (success.statusCode == 200) {
        var data = jsonDecode(success.body);
        // log('response is $data');
        log(data['status'].toString());
        if (data['status'].toString() == 'true') {
          rides = data['data'];
          log('my ride list is $rides');
          // Get.rawSnackbar(
          //     snackPosition: SnackPosition.TOP,
          //     message: data['message'].toString());
          isLoading = false;
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
