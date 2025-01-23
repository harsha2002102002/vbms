import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';

import '../../apiservice/apiservice.dart';
import '../../maps/googlemaps.dart';

class BookingStatusScreenController extends GetxController {
  dynamic bookingDetails = Get.arguments;
  Timer? _timer;
  bool isLoading = false;
  bool statusLoading = true;
  var bookingStatus = "";
  Map acceptBookingDetails = {};
  bool isFabExpanded = false;

  @override
  void onInit() {
    super.onInit();
    log('Booking details are: $bookingDetails');
    bookingStatus = bookingDetails['status'].toString();
    log("Booking status is: $bookingStatus");
    getBookingStatus();
    startUpdateStatusTimer();
  }

  void startUpdateStatusTimer() {
    // Start the timer only if it's not already running
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!Get.isRegistered<BookingStatusScreenController>()) {
          log('Controller not registered. Cancelling timer.');
          _timer?.cancel();
          return;
        }
        getBookingStatus();
      });
    }
  }

  fabIconAnimation(){
    isFabExpanded = !isFabExpanded;
    update();
  }

  @override
  void dispose() {
    log('Disposing BookingStatusScreenController and stopping timer');
    _timer?.cancel(); // Stop the timer
    _timer = null; // Nullify the timer reference
    super.dispose();
  }

  Future<void> getBookingStatus() async {
    try {
      final success = await ApiService.get(
          'getAccept?vehicleBookingId=${bookingDetails['vehicleBookingId']}');
      log('Status code is: ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('Response is: $data');

      if (success.statusCode == 200) {
        var body = data['data'];
        log('body is $body');
        log('Status is: ${body['status']}');
        var statusVal = body['status'];
        if (statusVal == "Accepted") {
          acceptBookingDetails = body;
          log('acceptBookingDetails is $acceptBookingDetails');
          bookingStatus = statusVal;
          statusLoading = false;
          isLoading = true;
          // Navigate after a small delay
          Future.delayed(const Duration(seconds: 10), () {
            isLoading = false; // Explicitly delete the controller
            var pLatitude =
                acceptBookingDetails['pickupLatitude'].toString().isNotEmpty
                    ? double.parse(
                        acceptBookingDetails['pickupLatitude'].toString())
                    : 0.0;
            var dLatitude =
                acceptBookingDetails['driverLatitude'].toString().isNotEmpty
                    ? double.parse(
                        acceptBookingDetails['driverLatitude'].toString())
                    : 0.0;
            var pLongitude =
                acceptBookingDetails['pickupLongitude'].toString().isNotEmpty
                    ? double.parse(
                        acceptBookingDetails['pickupLongitude'].toString())
                    : 0.0;
            var dLongitude =
                acceptBookingDetails['driverLongitude'].toString().isNotEmpty
                    ? double.parse(
                        acceptBookingDetails['driverLongitude'].toString())
                    : 0.0;
            _timer?.cancel(); // Ensure the timer is stopped
            Get.delete<BookingStatusScreenController>();
            Get.off(() => GoogleMapScreen(
                  dLatitude: dLatitude,
                  dLongitude: dLongitude,
                  pLatitude: pLatitude,
                  pLongitude: pLongitude,
                  tripData: const {},
                  tripStatus: "",
                ));
            update();
          });
          update();
        }
        update();
      }
    } catch (e) {
      log('Error fetching booking status: $e');
    }
    update();
  }
}
