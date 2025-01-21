import 'dart:convert';
import 'dart:developer';

// import 'package:adanivehiclebooking/helpers/utilities.dart';
// import 'package:adanivehiclebooking/views/driver/shiftdriver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/apiservice.dart';
// import '../../../views/home/bottombar.dart';
// import '../../../views/home/homepage.dart';

class AirportAdminOrDriverLoginController extends GetxController {
  dynamic argumentData = Get.arguments;
  final loginFormKey = GlobalKey<FormState>();
  bool showLoginPassword = true;
  TextEditingController loginEmailIDorMobNo = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    log('argument data is $argumentData');
    super.onInit();
  }

  signApi() async {
    log('entered value is ${loginEmailIDorMobNo.text.toString()}');
    String userNumber = "";
    String userEmail = "";
    if (isNumeric(loginEmailIDorMobNo.text.toString())) {
      userNumber = loginEmailIDorMobNo.text.toString();
      log('user number is $userNumber');
    } else {
      userEmail = loginEmailIDorMobNo.text.toString();
      log('user email is $userEmail');
    }
    final body = jsonEncode({
      "email": userEmail.toString(),
      "password": loginPassword.text.toString(),
      "mobile": userNumber.toString(),
      "roleType": argumentData.toString()
    });
    log('body-------$body');
    await ApiService.post('auth/signIn', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('response is $data');
      if (success.statusCode == 200) {
        log('role is ${data['data'][0]['roleType']}');
        var roleType = data['data'][0]['roleType'];
        if (roleType == "Driver") {
          driverUserDetails(data['data']);
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP, message: 'Login Success');
          handleNavigation();
          // Utilities.isAssigned == true
          //     ? Get.offAll(() => const HomePage())
          //     :
          // Get.offAll(() => const ShiftDriver());
          update();
        } else {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: 'Something went wrong, Try again later');
        }
        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
      }
    });
  }

  bool isNumeric(String str) {
    log('str is $str');
    final numberRegex = RegExp(r'^-?[0-9]+(\.[0-9]+)?$');
    return numberRegex.hasMatch(str);
  }

  driverUserDetails(data) async {
    log('data is $data');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
    prefs.setString("userID", data[0]['userId']);
    prefs.setString("emailID", data[0]['email']);
    prefs.setString("mobileNo", data[0]['mobile']);
    prefs.setString("userRole", data[0]['roleType']);
    prefs.setString("driverId", data[0]['driverId']);
    prefs.setString("firstName", data[0]['firstName']);
    prefs.setString("lastName", data[0]['lastName']);
    prefs.setString("airportRegId", data[0]['airportRegId']);
    prefs.setString("spocName", data[0]['fullName']);
    prefs.setString("supplierId", data[0]['supplierId']);
    prefs.setString("driverStatus", data[0]['driverStatus']['driverStatus']);
    prefs.setString("supplierName", data[0]['supplierDetails']['spocName']);
    prefs.setString("airportName", data[0]['masterAirportData']['airportName']);
    log('Driver shared preferencses==============');
    log(prefs.getBool('isLogin').toString());
    log(prefs.getString('userID').toString());
    log(prefs.getString('emailID').toString());
    log(prefs.getString('mobileNo').toString());
    log(prefs.getString('userRole').toString());
    log(prefs.getString('driverId').toString());
    log(prefs.getString('firstName').toString());
    log(prefs.getString('lastName').toString());
    log(prefs.getString('spocName').toString());
    log(prefs.getString('airportRegId').toString());
    log(prefs.getString('supplierId').toString());
    log(prefs.getString('supplierName').toString());
    log(prefs.getString('airportName').toString());
    log("--------------Driver Status -------------");
    log(prefs.getString('driverStatus').toString());
    log('shared preferencses==============');
  }

  handleNavigation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("Status ");
    log(prefs.getString('driverStatus').toString());

    // prefs.getString('driverStatus').toString() == "End Shift" ||
    //         prefs.getString('driverStatus').toString() == "null"
    //     ? Get.offAll(() => const ShiftDriver())
    //     : Get.offAll(() => const BottomTile());
    update();
  }
}
