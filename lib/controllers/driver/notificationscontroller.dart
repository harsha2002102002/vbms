import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:vbms/maps/googlemaps.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/apiservice.dart';

class NotificationsController extends GetxController {
  List notifications = [];
  String? airportRegId;
  String? driverId;
  String? supplierID;
  bool isLoading = true;
  bool isAcceptLoading = false;
  final String apiKey = 'AIzaSyB4Z7TS_eDUaBfMH_lVq1NCOmrYZceSiwY';
  bool isCurrentLoading = true;
  String? currentPlace;
  String? driverLat;
  String? driverLon;
  Timer? _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    requestLocationPermission();
    getCurrentLocation();
    loadLoginData();
    getNotifications();
    super.onInit();
  }

  Future<Position?> requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt the user to enable location services
      bool userEnabledLocation = await _promptToEnableLocation();
      if (!userEnabledLocation) {
        return Future.error('Location services are disabled.');
      }
    }

    // Check and request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, please enable them in settings.');
    }

    // If permission is granted, return the current location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<bool> _promptToEnableLocation() async {
    bool userEnabledLocation = false;

    // Show a dialog to prompt the user
    await Get.defaultDialog(
      barrierDismissible: false,
      contentPadding: const EdgeInsets.all(10),
      title: 'Location Services Disabled',
      titlePadding: const EdgeInsets.all(20),
      middleText: 'Please enable location services to continue.',
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            userEnabledLocation = false;
            Future.delayed(const Duration(seconds: 2), () {
              requestLocationPermission();
            });
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Get.back();
            // Open location settings
            await Geolocator.openLocationSettings();
            userEnabledLocation = await Geolocator.isLocationServiceEnabled();
          },
          child: const Text('Enable'),
        ),
      ],
    );

    return userEnabledLocation;
  }

  // Future<Position?> requestLocationPermission() async {
  //   // Check if location services are enabled
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // If location services are not enabled, ask the user to enable it
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   // Check the current location permission status
  //   LocationPermission permission = await Geolocator.checkPermission();
  //
  //   // If permission is denied, request permission
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //
  //   // Handle permanent denial of location permission
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error('Location permissions are permanently denied.');
  //   }
  //
  //   // If permission is granted, return the current location
  //   if (permission == LocationPermission.whileInUse ||
  //       permission == LocationPermission.always) {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     return position;
  //   }
  //
  //   // If none of the above, return null
  //   return null;
  // }

  Future<void> getCurrentLocation() async {
    isCurrentLoading = true;
    update();

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled. Prompting user...');
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          debugPrint('User did not enable location services.');
          isCurrentLoading = false;
          update();
          return;
        }
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        debugPrint(
            'Location permissions are permanently denied. Please enable them in settings.');
        isCurrentLoading = false;
        update();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update latitude and longitude
      driverLat = position.latitude.toString();
      driverLon = position.longitude.toString();
      log('Driver lat/lon: $driverLat, $driverLon');

      // Reverse geocode to get address
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;
        currentPlace =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
        debugPrint('Current place: $currentPlace');
      } else {
        debugPrint('No address available for the current location.');
      }
    } catch (e) {
      debugPrint('Error while getting location details: $e');
    } finally {
      isCurrentLoading = false;
      update();
    }
  }

  // Future<void> getCurrentLocation() async {
  //   isCurrentLoading = true;
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     debugPrint('Location services are disabled.');
  //     return;
  //   }
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     debugPrint('Location permissions are permanently denied.');
  //     return;
  //   }
  //
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //
  //     // Get latitude and longitude
  //     double latitude = position.latitude;
  //     double longitude = position.longitude;
  //
  //     driverLat = latitude.toString();
  //     driverLon = longitude.toString();
  //     log('driver latlon is $driverLat,$driverLon');
  //     // Reverse geocoding to get address
  //     List<Placemark> placeMarks =
  //         await placemarkFromCoordinates(latitude, longitude);
  //
  //     if (placeMarks.isNotEmpty) {
  //       Placemark place = placeMarks.first;
  //
  //       // debugPrint('Country: ${place.country}');
  //       // debugPrint('Locality: ${place.locality}');
  //       // debugPrint('Postal Code: ${place.postalCode}');
  //       // debugPrint('Street: ${place.street}');
  //       // debugPrint('Full Address: ${place.toString()}');
  //       currentPlace =
  //           "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
  //       debugPrint('current place is ${currentPlace.toString()}');
  //       isCurrentLoading = false;
  //       update();
  //     } else {
  //       debugPrint('No address available for the current location.');
  //     }
  //     update();
  //   } catch (e) {
  //     debugPrint('Error while getting location details: $e');
  //   }
  // }

  getNotifications() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!Get.isRegistered<NotificationsController>()) {
          log('Controller not registered. Cancelling timer.');
          _timer?.cancel();
          return;
        }
        loadLoginData();
      });
    }
  }

  loadLoginData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    log("LoadingData");
    airportRegId = pref.getString("airportRegId").toString();
    driverId = pref.getString("driverId").toString();
    supplierID = pref.getString('supplierId').toString();
    loadNotificationList();
    update();
  }

  loadNotificationList() async {
    await ApiService.get('notificationList?airportRegId=$airportRegId')
        .then((success) {
      log('status code is ${success.statusCode}');
      if (success.statusCode == 200) {
        var data = jsonDecode(success.body);
        log('response is $data');
        log(data['status'].toString());
        if (data['status'].toString() == 'true') {
          notifications = data['data'];
          log('notifications list is $notifications');
          isLoading = false;
          if (notifications.isEmpty) {
            _timer?.cancel();
            update();
          }
          update();
        }
        update();
      } else {
        isLoading = false;
        Get.rawSnackbar(
            message: 'Something went wrong, Please try again later');
        update();
      }
    });
  }

  handleAccept(airportRegId, vehicleBookingId) async {
    if (driverLat.toString().isNotEmpty && driverLon.toString().isNotEmpty) {
      isLoading = true;
      log(isLoading.toString());
      log(driverLat.toString());
      log(driverLon.toString());
      update();
      final body = jsonEncode({
        "airportRegId": airportRegId.toString(),
        "vehicleBookingId": vehicleBookingId.toString(),
        "driverId": driverId.toString(),
        "status": "Accepted",
        "driverLatitude": driverLat.toString(),
        "driverLongitude": driverLon.toString(),
        "supplierId": supplierID.toString()
      });

      log("Body $body");
      await ApiService.post('acceptBooking', body).then((success) {
        log('status code is ${success.statusCode}');
        var data = jsonDecode(success.body);
        log('response is $data');
        if (success.statusCode == 200) {
          _timer?.cancel(); // Ensure the timer is stopped
          Get.delete<NotificationsController>();
          isLoading = false;
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: data['message'].toString());
          var notificationDetails = data['data'];
          log('notificationDetails is $notificationDetails');
          var pLatitude = notificationDetails['driverLatitude']
                  .toString()
                  .isNotEmpty
              ? double.parse(notificationDetails['driverLatitude'].toString())
              : 0.0;
          var dLatitude = notificationDetails['pickupLatitude']
                  .toString()
                  .isNotEmpty
              ? double.parse(notificationDetails['pickupLatitude'].toString())
              : 0.0;
          var pLongitude = notificationDetails['driverLongitude']
                  .toString()
                  .isNotEmpty
              ? double.parse(notificationDetails['driverLongitude'].toString())
              : 0.0;
          var dLongitude = notificationDetails['pickupLongitude']
                  .toString()
                  .isNotEmpty
              ? double.parse(notificationDetails['pickupLongitude'].toString())
              : 0.0;
          Get.off(() => GoogleMapScreen(
                dLatitude: dLatitude,
                dLongitude: dLongitude,
                pLatitude: pLatitude,
                pLongitude: pLongitude,
                tripData: notificationDetails,
                tripStatus: "",
              ));
          update();
        } else {
          isLoading = false;
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: data['message'].toString());
          update();
        }
      });
    } else {
      Get.rawSnackbar(
          snackPosition: SnackPosition.TOP,
          message: 'Something went wrong, Please contact administrator');
    }
  }

  @override
  void dispose() {
    log('Disposing NotificationsController and stopping timer');
    _timer?.cancel(); // Stop the timer
    _timer = null; // Nullify the timer reference
    super.dispose();
  }
}
