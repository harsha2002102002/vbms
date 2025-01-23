import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../../apiservice/apiservice.dart';
import '../../maps/googlemaps.dart';

class TripDetailsController extends GetxController {
  dynamic argData = Get.arguments;
  List tripDetails = [];
  @override
  void onInit() {
    // TODO: implement onInit
    log('argData');
    log(argData.toString());
    // getTripDetails();
    super.onInit();
  }

  startTrip(dLatitude, dLongitude) async {
    var body = jsonEncode({
      "BookingFor": argData['BookingFor'].toString(),
      "airportId": argData['airportId'].toString(),
      "vehicleBookingId": argData['vehicleBookingId'].toString(),
      "airportRegId": argData['airportRegId'].toString(),
      "departmentId": argData['departmentId'].toString(),
      "departmentTypeId": argData['departmentTypeId'].toString(),
      "date": argData['date'].toString(),
      "dropAt": argData['dropAt'].toString(),
      "dropAtLatitude": argData['dropAtLatitude'].toString(),
      "dropAtLongitude": argData['dropAtLongitude'].toString(),
      "isActive": "true",
      "isDeleted": false,
      "pickUp": argData['pickUp'].toString(),
      "pickupLatitude": argData['pickupLatitude'].toString(),
      "pickupLongitude": argData['pickupLongitude'].toString(),
      "status": "StartTrip",
      "time": argData['time'].toString()
    });
    log('body is ------>$body');
    ApiService.post('startAndEndTrip', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('response is $data');
      if (success.statusCode == 200) {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        log("drop latlong is $dLatitude $dLongitude");
        Get.off(
          () => GoogleMapScreen(
            dLatitude: dLatitude,
            dLongitude: dLongitude,
            pLatitude: 0.0,
            pLongitude: 0.0,
            tripData: const {}, tripStatus: "",
          ),
        );
        // Get.to(() => const GoogleMapScreen());
        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      }
      update();
    });
  }
}
