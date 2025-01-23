import 'dart:convert';
import 'dart:developer';
import 'package:vbms/controllers/home/homecontroller.dart';
import 'package:vbms/views/landingpage/landingpage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/apiservice.dart';

class ProfileController extends GetxController {
  var firstName = "",
      lastName = "",
      mobileNo = "",
      emailID = "",
      roleType = "",
      driverStatus = "",
      supplierId = "",
      driverId = "",
      vehicleId = "",
      airportRegId = "",
      supplierName = "",
      airportName = "",
      baseImg = "",
      names = "";
  late int assignedVehicleId;
  dynamic homeController = Get.put(HomePageController());
  bool isLoading = false;

  @override
  void onInit() {
    // TODO: implement onInit
    getProfileData();

    log("Driver Status $driverStatus");
    super.onInit();
  }

  getProfileData() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString('firstName').toString();
    lastName = prefs.getString('lastName').toString();
    mobileNo = prefs.getString('mobileNo').toString();
    emailID = prefs.getString('emailID').toString();
    roleType = prefs.getString('userRole').toString();
    driverStatus = prefs.getString('driverStatus').toString();
    supplierId = prefs.getString('supplierId').toString();
    driverId = prefs.getString('driverId').toString();
    airportRegId = prefs.getString('airportRegId').toString();
    airportName = prefs.getString('airportName').toString();
    supplierName = prefs.getString('supplierName').toString();
    names = prefs.getString('profileImgName').toString();
    baseImg = prefs.getString('uploadBaseImg').toString();
    log('baseImg is $baseImg');
    log('role is $roleType');
    if (roleType.toString() == "Driver") {
      getDriverInfo();
    }
    await Future.delayed(const Duration(seconds: 2));
    isLoading = false;
    update();
  }

  getDriverInfo() async {
    ApiService.get(
            'driverInfo?airportRegId=$airportRegId&supplierId=$supplierId&driverId=$driverId')
        .then((success) {
      log('status code is ${success.statusCode}');
      if (success.statusCode == 200) {
        var data = jsonDecode(success.body);
        log('response is $data');
        log(data['status'].toString());
        if (data['status'].toString() == 'true') {
          var driverInfo = data['data'];
          assignedVehicleId = driverInfo[0]['assignedVehicleId'];
          log('assignedVehicleId ${driverInfo[0]['assignedVehicleId']}');
          update();
        }
        update();
      } else {
        Get.rawSnackbar(
            message: 'Something went wrong, Please try again later');
      }
    });
  }

  handleShift(shiftStatus) async {
    final body = jsonEncode(
        {"assignedVehicleId": assignedVehicleId, "driverStatus": shiftStatus});

    await ApiService.post('assignVehicle', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('response is $data');
      if (success.statusCode == 200) {
        updateDriverStatus(shiftStatus);
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
      }
    });
    update();
  }

  updateDriverStatus(shiftStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("driverStatus", shiftStatus);
    getProfileData();
    if (shiftStatus == "End Shift") {
      Get.offAll(() => const LandingPage());
    }
    update();
  }

  clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    await prefs.clear();
    log('data cleared');
    Get.offAll(() => const LandingPage());
    update();
  }
}
