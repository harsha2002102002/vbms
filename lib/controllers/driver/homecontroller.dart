import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverHomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? driverTabController;
  @override
  void onInit() {
    // TODO: implement onInit
    driverTabController = TabController(
      length: 2,
      vsync: this,
    );
    super.onInit();
  }

  @override
  void onClose() {
    driverTabController?.dispose();
    super.onClose();
  }
}
