import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/driver/shiftdriver.dart';
import '../../views/home/bottombar.dart';
import '../../views/home/homepage.dart';
import '../../views/landingpage/landingpage.dart';

class SplashScreenController extends GetxController {
  String? driverStatus;
  String? userRole;
  @override
  void onInit() {
    // TODO: implement onInit
    loadDriverStatus();
    super.onInit();
  }

  loadDriverStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    driverStatus = prefs.getString('driverStatus').toString();
    userRole = prefs.getString('userRole').toString();
    update();

    getLoginStatus().then((status) {
      log("Driver Status $driverStatus");
      if (status && userRole.toString() == "Driver") {
        if (driverStatus.toString() == "End Shift" ||
            driverStatus.toString() == "null") {
          navigateToShiftDriver();
        } else {
          navigateToHome();
        }
        // navigateToHome();
      } else if (status && userRole.toString() != "Driver") {
        navigateToHome();
      } else {
        navigateToLogin();
      }
    });

    update();
  }

  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (prefs.getBool('isLogin') == null) {
      return false;
    } else {
      return true;
    }
  }

  navigateToHome() {
    Timer(const Duration(seconds: 3), () => Get.offAll(() => const BottomTile()));
    // Timer(const Duration(seconds: 3), () => Get.offAll(() => const HomePage()));
  }

  navigateToShiftDriver() {
    Timer(const Duration(seconds: 3),
        () => Get.offAll(() => const ShiftDriver()));
  }

  navigateToLogin() {
    Timer(const Duration(seconds: 3),
        () => Get.offAll(() => const LandingPage()));
  }

  updateNavigation(status) {
    log("Status $status");
    log("driverStatus1 $driverStatus");
    log("userRole $userRole");
    update();
  }
}
