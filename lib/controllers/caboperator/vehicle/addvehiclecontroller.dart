import 'dart:convert';
import 'dart:developer';
import 'package:vbms/views/caboperator/vehicle/vehiclehome.dart';
import 'package:vbms/views/caboperator/vehicle/viewvehiclelist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/apiservice.dart';

class AddVehicleController extends GetxController {
  final addVehicleFormKey = GlobalKey<FormState>();
  TextEditingController vehicleName = TextEditingController();
  TextEditingController registrationNumber = TextEditingController();
  TextEditingController noOfSeats = TextEditingController();
  String airportRegId = "";
  String supplierId = "";
  String supplierName = "";
  dynamic argumentData = Get.arguments;
  String vehicleId = "";

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
    supplierId = pref.getString('supplierId').toString();
    supplierName = pref.getString('spocName').toString();

    if (argumentData != null && argumentData[0].toString() == "Edit") {
      vehicleId = argumentData[1]['vehicleId'];
      vehicleName.text = argumentData[1]['vehicleName'];
      registrationNumber.text = argumentData[1]['registrationNumber'];
      noOfSeats.text = argumentData[1]['noOfSeats'].toString();
      log('vehicle id is $vehicleId');
    }
    update();
  }

  void addVehicle() async {
    String body;
    if (vehicleId != "") {
      body = jsonEncode({
        "vehicleId": vehicleId,
        "airportRegId": airportRegId.toString(),
        "supplierId": supplierId.toString(),
        "vehicleName": vehicleName.text,
        "registrationNumber": registrationNumber.text,
        "noOfSeats": noOfSeats.text
      });
    } else {
      body = jsonEncode({
        "airportRegId": airportRegId.toString(),
        "supplierId": supplierId.toString(),
        "vehicleName": vehicleName.text,
        "registrationNumber": registrationNumber.text,
        "noOfSeats": noOfSeats.text
      });
    }

    log("Vehicle Body $body");
    await ApiService.post('/vehicles', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('response is $data');
      if (success.statusCode == 200) {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        if (vehicleId != "") {
          Get.off(() => const ViewVehicleList());
        } else {
          Get.off(() => const VehicleHome());
        }
        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      }
    });
  }
}
