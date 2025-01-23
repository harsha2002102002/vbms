import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/apiservice.dart';
import '../../views/home/bottombar.dart';

class ShiftDriverController extends GetxController {
  final shiftFormKey = GlobalKey<FormState>();
  String? vehicleId;
  List vehicleList = [];
  String? airportRegId;
  String? supplierId;
  String? driverId;
  String? vehicleName;
  String? registrationNumber;

  @override
  void onInit() {
    // TODO: implement onInit
    loadLoginData();
    super.onInit();
  }

  loadLoginData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    airportRegId = pref.getString("airportRegId").toString();
    supplierId = pref.getString('supplierId').toString();
    driverId = pref.getString('driverId').toString();
    loadVehicleList();
    update();
  }

  loadVehicleList() async {
    ApiService.get(
            'vehicleList?airportRegId=$airportRegId&supplierId=$supplierId&isAssigned=false')
        .then((success) {
      if (success.statusCode == 200) {
        var data = jsonDecode(success.body);
        if (data['status'].toString() == 'true') {
          vehicleList = data['data'];
          log('vehicle list is $vehicleList');
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

  handleShiftStart() async {
    var body = jsonEncode({
      "airportRegId": airportRegId,
      "driverId": driverId,
      "vehicleId": vehicleId,
      "isAssigned": true,
      "vehicleName": vehicleName,
      "registrationNumber": registrationNumber,
      "supplierId": supplierId,
      "driverStatus": 'Start Shift'
    });

    await ApiService.post('assignVehicle', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('assignVehicle response is $data');
      if (success.statusCode == 200) {
        // updateIsAssigned(data['result']['value']);
        updateDriverStatus("Start Shift");
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        Get.offAll(() => const BottomTile());
        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      }
    });

    log("Body $body");
  }

  handleVehicle(newValue) {
    log('selected value is $newValue');
    vehicleId = newValue;
    log("message $vehicleList");
    for (int i = 0; i < vehicleList.length; i++) {
      if (vehicleList[i]['vehicleId'].toString() == newValue.toString()) {
        vehicleName = vehicleList[i]['vehicleName'].toString();
        registrationNumber = vehicleList[i]['registrationNumber'].toString();
        update();
      }
    }
    update();
  }

  updateDriverStatus(shiftStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("driverStatus", shiftStatus);
    update();
  }

  // updateIsAssigned(data) async {
  //   log("Assigned Data ${data['isAssigned']}");
  //   Utilities.isAssigned = data['isAssigned'];
  //   update();
  // }
}
