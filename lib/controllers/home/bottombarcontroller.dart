import 'dart:developer';
import 'package:vbms/views/booking/vehiclebooking.dart';
import 'package:vbms/views/bottomnavigationscreens/bottomvehiclescreen.dart';
import 'package:vbms/views/driver/notifications.dart';
import 'package:vbms/views/home/homepage.dart';
import 'package:vbms/views/profile/profile.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../views/bottomnavigationscreens/bottomdriverscreen.dart';
import '../../views/bottomnavigationscreens/bottommyridescreen.dart';
import '../../views/bottomnavigationscreens/bottommytripscreen.dart';
import '../../views/landingpage/landingpage.dart';

class BottomTileController extends GetxController {
  String appTitle = "Home Page";
  int selectedIndex = 0;
  List bottomPages = [];
  String userRole = "";
  List<String> bottomLabels = [];
  List<Widget> inactiveIcons = [];
  List<Widget> activeIcons = [];

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController controller =
      NotchBottomBarController(index: 0);

  @override
  void onInit() {
    // TODO: implement onInit
    setData();
    super.onInit();
  }

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log(prefs.getString('userRole').toString());
    userRole = prefs.getString('userRole').toString();
    // userRole = "Employee";
    // userRole = "Driver";
    log('body-------$userRole');
    if (userRole == "Driver") {
      bottomPages = [
        const HomePage(),
        const Notifications(),
        const BottomMyRidesScreen(),
        const ProfilePage()
      ];
      bottomLabels = ["Home", "Notification", "History", "Account"];
      activeIcons = [
        const Icon(Icons.home_outlined, color: Colors.deepPurple),
        const Icon(Icons.notifications_active, color: Colors.deepPurple),
        const Icon(Icons.history, color: Colors.deepPurple),
        const Icon(Icons.person_outlined, color: Colors.deepPurple),
      ];
      inactiveIcons = [
        const Icon(Icons.home_outlined, color: Colors.grey),
        const Icon(Icons.notifications_active, color: Colors.grey),
        const Icon(Icons.history, color: Colors.grey),
        const Icon(Icons.person_outlined, color: Colors.grey),
      ];
    } else if (userRole == "Employee") {
      bottomPages = [
        const HomePage(),
        const VehicleBooking(),
        const BottomMyTripsScreen(),
        const ProfilePage()
      ];
      bottomLabels = ["Home", "Book", "Trips", "Account"];
      activeIcons = [
        const Icon(Icons.home_outlined, color: Colors.deepPurple),
        const Icon(Icons.car_rental_outlined, color: Colors.deepPurple),
        const Icon(Icons.history, color: Colors.deepPurple),
        const Icon(Icons.person_outlined, color: Colors.deepPurple),
      ];
      inactiveIcons = [
        const Icon(Icons.home_outlined, color: Colors.grey),
        const Icon(Icons.car_rental_outlined, color: Colors.grey),
        const Icon(Icons.history, color: Colors.grey),
        const Icon(Icons.person_outlined, color: Colors.grey),
      ];
    } else if (userRole == "Operator") {
      bottomPages = [
        const HomePage(),
        const BottomVehicleScreen(),
        const BottomDriverScreen(),
        const ProfilePage()
      ];
      bottomLabels = ["Home", "Vehicle", "Driver", "Account"];
      activeIcons = [
        const Icon(Icons.home_outlined, color: Colors.deepPurple),
        const Icon(Icons.drive_eta_rounded, color: Colors.deepPurple),
        Image.asset(
          'assets/icons/driver_icon.png',
          color: Colors.deepPurple,
        ),
        const Icon(Icons.person_outlined, color: Colors.deepPurple),
      ];
      inactiveIcons = [
        const Icon(Icons.home_outlined, color: Colors.grey),
        const Icon(Icons.drive_eta_rounded, color: Colors.grey),
        Image.asset(
          'assets/icons/driver_icon.png',
          color: Colors.grey,
        ),
        const Icon(Icons.person_outlined, color: Colors.grey),
      ];
    }
    update();
  }

  updateIndex(index) {
    log('current selected index $index');
    selectedIndex = index;
    if (index == 0) {
      appTitle = "Home Page";
    } else if (index == 1) {
      if (userRole == "Driver") {
        appTitle = "Notifications";
      } else if (userRole == "Employee") {
        appTitle = "Vehicle Booking";
      } else if (userRole == "Operator") {
        appTitle = "Vehicle";
      }
    } else if (index == 2) {
      if (userRole == "Driver") {
        appTitle = "My Rides";
      } else if (userRole == "Employee") {
        appTitle = "My Trips";
      } else if (userRole == "Operator") {
        appTitle = "Driver";
      }
    } else if (index == 3) {
      appTitle = "Account";
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
