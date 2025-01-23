import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:vbms/views/caboperator/driver/driverhome.dart';
import 'package:vbms/views/viewimage/viewimage.dart';
import 'package:vbms/views/caboperator/driver/viewdrivers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/apiservice.dart';

class AddDriverController extends GetxController {
  final addDriverFormKey = GlobalKey<FormState>();
  String airportRegId = "";
  String supplierId = "";
  String driverId = "";
  String? airportId;
  String supplierName = "";
  List frontSideNames = [];
  List backSideNames = [];
  List frontSidePaths = [];
  List backSidePaths = [];
  List frontSideBaseImg = [];
  List backSideBaseImg = [];
  File? frontSideImage, frontSideSelectedImage;
  File? backSideImage, backSideSelectedImage;
  final ImagePicker _picker = ImagePicker();
  // File? image, selectedImage;
  bool showPassword = true;
  TextEditingController loginPassword = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailID = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController licenseNumber = TextEditingController();
  dynamic argumentData = Get.arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    loadLoginData();
    super.onInit();
  }

  loadLoginData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    log("LoadingData");
    airportRegId = pref.getString("airportRegId").toString();
    supplierId = pref.getString('supplierId').toString();
    supplierName = pref.getString('spocName').toString();
    airportId = pref.getString('airportId');

    log("Airport ID $airportId");

    if (argumentData != null && argumentData[0].toString() == "Edit") {
      driverId = argumentData[1]['driverId'];
      firstName.text = argumentData[1]['firstName'];
      lastName.text = argumentData[1]['lastName'];
      emailID.text = argumentData[1]['email'];
      mobileNumber.text = argumentData[1]['mobile'];
      licenseNumber.text = argumentData[1]['driverLicence'];
      frontSideNames.add(argumentData[1]['uploadFrontName']);
      frontSidePaths.add(argumentData[1]['uploadFrontPath']);
      frontSideBaseImg.add(argumentData[1]['uploadFront']);
      backSideNames.add(argumentData[1]['uploadBackName']);
      backSidePaths.add(argumentData[1]['uploadBackPath']);
      backSideBaseImg.add(argumentData[1]['uploadBack']);
    }
    update();
  }

  saveDriverData() {
    String body;
    if (driverId.toString() != "") {
      body = jsonEncode({
        "driverId": driverId,
        "email": emailID.text,
        "mobile": mobileNumber.text,
        "password": loginPassword.text,
        "firstName": firstName.text,
        "lastName": lastName.text,
        "fullName": "${firstName.text} ${lastName.text}",
        "driverLicence": licenseNumber.text,
        "airportId": airportRegId.toString(),
        "supplierId": supplierId.toString(),
        "uploadFront": frontSideBaseImg[0].toString(),
        "uploadFrontPath": frontSidePaths[0].toString(),
        "uploadFrontName": frontSideNames[0].toString(),
        "uploadBack": backSideBaseImg[0].toString(),
        "uploadBackPath": backSidePaths[0].toString(),
        "uploadBackName": backSideNames[0].toString(),
        "roleType": "Driver",
        "airportId": int.parse(airportId.toString()),
      });
    } else {
      body = jsonEncode({
        "email": emailID.text,
        "mobile": mobileNumber.text,
        "password": loginPassword.text,
        "firstName": firstName.text,
        "lastName": lastName.text,
        "fullName": "${firstName.text} ${lastName.text}",
        "driverLicence": licenseNumber.text,
        "airportRegId": airportRegId.toString(),
        "supplierId": supplierId.toString(),
        "uploadFront": frontSideBaseImg[0].toString(),
        "uploadFrontPath": frontSidePaths[0].toString(),
        "uploadFrontName": frontSideNames[0].toString(),
        "uploadBack": backSideBaseImg[0].toString(),
        "uploadBackPath": backSidePaths[0].toString(),
        "uploadBackName": backSideNames[0].toString(),
        "roleType": "Driver",
        "airportId": int.parse(airportId.toString()),
        "profileImgName": "",
        "uploadBaseImg": ""
      });
    }

    if (kDebugMode) {
      print("Driver Body $body");
    }

    ApiService.post('saveAndUpdateDriver', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('response is $data');
      if (success.statusCode == 200) {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        if (driverId != "") {
          Get.off(() => const ViewDrivers());
        } else {
          Get.off(() => const DriverHome());
        }

        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      }
    });
  }

  frontSideHandleUpload(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Add Front Side Photo!",
          style: TextStyle(fontFamily: 'Inter-Medium',fontSize: 18),
        ),
        content: SizedBox(
          height: 130,
          width: 50,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              GestureDetector(
                  child: const Card(
                    color: Colors.purple,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Take Photo",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () async {
                    frontSideUploadPhoto(ImageSource.camera);
                    Navigator.pop(context);
                  }),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Choose From Gallery",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  frontSideUploadPhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  backSideHandleUpload(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Add Back Side Photo!",
          style: TextStyle(fontSize: 18),
        ),
        content: SizedBox(
          height: 130,
          width: 50,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              GestureDetector(
                  child: const Card(
                    color: Colors.purple,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Take Photo",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () async {
                    backSideUploadPhoto(ImageSource.camera);
                    Navigator.pop(context);
                  }),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Choose From Gallery",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  backSideUploadPhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  frontSideUploadPhoto(ImageSource source) async {
    frontSideNames = [];
    frontSidePaths = [];
    frontSideBaseImg = [];

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    final File file = File(image!.path);

    try {
      if (image != null) {
        frontSideSelectedImage = file;
        String fileName = image.path.toString().split('/').last;
        List<int> imageBytes = frontSideSelectedImage!.readAsBytesSync();
        var imageB64 = base64Encode(imageBytes);
        frontSideBaseImg.add(imageB64);
        frontSideNames.add(fileName);
        frontSidePaths.add(image.path.toString());
        // log('baseImg is $baseImg');
        log('fileName is $fileName');
        log('names is $frontSideNames');
        log('front side paths is $frontSidePaths');

        update();
      }
    } catch (e) {
      log("Error Occured $e");
      update();
    }
    update();
  }

  backSideUploadPhoto(ImageSource source) async {
    backSideNames = [];
    backSidePaths = [];
    backSideBaseImg = [];

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    final File file = File(image!.path);

    try {
      if (image != null) {
        backSideSelectedImage = file;
        String fileName = image.path.toString().split('/').last;
        List<int> imageBytes = backSideSelectedImage!.readAsBytesSync();
        var imageB64 = base64Encode(imageBytes);
        backSideBaseImg.add(imageB64);
        backSideNames.add(fileName);
        backSidePaths.add(image.path.toString());
        // log('baseImg is $baseImg');
        log('fileName is $fileName');
        log('names is $frontSideNames');
        log('front side paths is $frontSidePaths');

        update();
      }
    } catch (e) {
      log("Error Occured $e");
      update();
    }
    update();
  }

  deleteBackSideImageData() {
    backSideNames = [];
    backSidePaths = [];
    backSideBaseImg = [];
    update();
  }

  deleteFrontSideImageData() {
    frontSideNames = [];
    frontSidePaths = [];
    frontSideBaseImg = [];
    update();
  }

  viewImage(imageData) {
    log('imagedata is $imageData');
    if (imageData.toString().isNotEmpty) {
      Get.to(() => const ViewImage(), arguments: imageData);
      update();
    } else {
      Get.rawSnackbar(message: 'Nothing to view');
      update();
    }
  }
}
