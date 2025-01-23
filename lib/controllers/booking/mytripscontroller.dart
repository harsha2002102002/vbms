import 'dart:convert';
import 'dart:developer';
import 'package:vbms/apiservice/apiservice.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTripsController extends GetxController {
  bool isLoading = true;
  List myTrips = [];

  @override
  void onInit() {
    // TODO: implement onInit
    getMyTrips();
    super.onInit();
  }


  getMyTrips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var airportRegId = prefs.getString("airportRegId").toString();
    var deptID = prefs.getString("deptID").toString();
    log('airport id is $airportRegId');
    log('dept id is $deptID');
    ApiService.get(
            'vehicleBookingList?airportRegId=$airportRegId&departmentId=$deptID')
        .then((success) {
      log('status code is ${success.statusCode}');
      if (success.statusCode == 200) {
        var data = jsonDecode(success.body);
        log(data['status'].toString());
        if (data['status'].toString() == 'true') {
          myTrips = data['data'];
          isLoading = false;
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
}
