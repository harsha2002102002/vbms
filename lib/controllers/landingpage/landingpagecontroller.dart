import 'dart:developer';
import 'package:get/get.dart';

import '../../views/employeeoroperatorportal/employeeoroperatorportal.dart';
import '../../views/login/airportadminordriver/airportadminordriverlogin.dart';

class LandingPageController extends GetxController {
  goToNextScreen(role) {
    log('role is $role');
    if (role == "Employee") {
      Get.to(() => const EmployeeOrOperatorTabs(), arguments: role);
    } else if (role == "Operator") {
      Get.to(() => const EmployeeOrOperatorTabs(), arguments: role);
    } else if (role == "Airport Admin") {
      Get.to(() => const AirportAdminLogin(), arguments: role);
    } else if (role == "Driver") {
      Get.to(() => const AirportAdminLogin(), arguments: role);
    }
  }
}
