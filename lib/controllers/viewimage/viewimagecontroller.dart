import 'dart:developer';

import 'package:get/get.dart';

class ViewImageController extends GetxController{
  dynamic argumentData = Get.arguments;
  @override
  void onInit() {
    // TODO: implement onInit
    log('argumnet data $argumentData');
    super.onInit();
  }
}