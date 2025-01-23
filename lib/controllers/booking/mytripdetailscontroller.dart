import 'dart:developer';

import 'package:get/get.dart';

import '../../maps/googlemaps.dart';

class MyTripDetailsController extends GetxController {
  bool isLoading = true;
  dynamic argData = Get.arguments;
  @override
  void onInit() {
    // TODO: implement onInit
    log('argument data is $argData');
    stopLoader();
    super.onInit();
  }

  stopLoader() {
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      update();
    });
  }

  gotoMapsAccepted() {
    var pLatitude = argData['pickupLatitude'].toString().isNotEmpty
        ? double.parse(argData['pickupLatitude'].toString())
        : 0.0;
    var dLatitude = argData['driverLatitude'].toString().isNotEmpty
        ? double.parse(argData['driverLatitude'].toString())
        : 0.0;
    var pLongitude = argData['pickupLongitude'].toString().isNotEmpty
        ? double.parse(argData['pickupLongitude'].toString())
        : 0.0;
    var dLongitude = argData['driverLongitude'].toString().isNotEmpty
        ? double.parse(argData['driverLongitude'].toString())
        : 0.0;
    Get.off(() => GoogleMapScreen(
        dLatitude: dLatitude,
        dLongitude: dLongitude,
        pLatitude: pLatitude,
        pLongitude: pLongitude, tripData: const {}, tripStatus: "",));
    update();
  }

  gotoOnGoingMaps() {
    var pLatitude = argData['pickupLatitude'].toString().isNotEmpty
        ? double.parse(argData['pickupLatitude'].toString())
        : 0.0;
    var dLatitude = argData['dropAtLatitude'].toString().isNotEmpty
        ? double.parse(argData['dropAtLatitude'].toString())
        : 0.0;
    var pLongitude = argData['pickupLongitude'].toString().isNotEmpty
        ? double.parse(argData['pickupLongitude'].toString())
        : 0.0;
    var dLongitude = argData['dropAtLongitude'].toString().isNotEmpty
        ? double.parse(argData['dropAtLongitude'].toString())
        : 0.0;
    Get.off(() => GoogleMapScreen(
        dLatitude: dLatitude,
        dLongitude: dLongitude,
        pLatitude: pLatitude,
        pLongitude: pLongitude, tripData: const {}, tripStatus: "",));
    update();
  }
}
