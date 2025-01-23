import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:vbms/views/landingpage/landingpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../views/driver/myrides.dart';
import '../../views/driver/notifications.dart';

class HomePageController extends GetxController {
  List vehicleNotificationDetails = [];
  final List<String> slideImages = [
    "assets/images/slide1.png",
    "assets/images/slide2.png",
    "assets/images/slide3.png",
  ];
  String userRole = "";
  String? driverStatus;
  final PageController pageController = PageController();
  late Timer pageTimer;
  @override
  void onInit() {
    // TODO: implement onInit
    getPlatformValue();
    pageTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (pageController.hasClients) {
        int nextPage = (pageController.page ?? 0).toInt() + 1;
        if (nextPage == slideImages.length) {
          nextPage = 0; // Loop back to the first page
        }
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
    getTripDetailsNotifications();
    super.onInit();
  }

  @override
  void dispose() {
    pageTimer.cancel();
    pageController.dispose();
    super.dispose();
  }

  getPlatformValue() {
    if (Platform.isAndroid) {
      log("Value for Android");
    } else if (Platform.isIOS) {
      log("Value for Android");
    } else if (Platform.isMacOS) {
      log("Value for Android");
    } else if (Platform.isWindows) {
      log("Value for Android");
    } else if (Platform.isLinux) {
      log("Value for Android");
    } else {
      log("Value for Android");
    }
  }

  getTripDetailsNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log(prefs.getString('userRole').toString());
    userRole = prefs.getString('userRole').toString();
    driverStatus = prefs.getString('driverStatus').toString();
    // final body = jsonEncode({"user_id": userID});
    log('body-------$userRole');
    // await ApiService.post(
    //   'bookVehicleNotifDetails',
    //   body,
    // ).then((success) {
    //   var data = jsonDecode(success.body);
    //   log('response = $data');
    //   if (data['status'] == 1) {
    //     vehicleNotificationDetails = data['bkVhclNotfctnDtls'];
    //     log('vehicleNotificationDetails ===========$vehicleNotificationDetails');
    //     update();
    //   }
    // });
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

  handleNavigation(type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    driverStatus = prefs.getString('driverStatus').toString();
    handleNotificationPage(type);
    update();
    // Get.to(() => const Notifications()); Get.to(() => const MyRides());
  }

  handleNotificationPage(type) {
    if (userRole.toString() == "Driver") {
      if (driverStatus.toString() == "Pause Shift") {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: "Resume your shift to continue");
      } else {
        if (type.toString() == "Notifications") {
          Get.to(() => const Notifications());
        } else {
          Get.to(() => const MyRides());
        }
      }
    } else {
      if (type.toString() == "Notifications") {
        Get.to(() => const Notifications());
      } else {
        Get.to(() => const MyRides());
      }
    }
    update();
  }
}
