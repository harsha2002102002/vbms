import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:vbms/controllers/profile/profilecontroller.dart';
import 'package:vbms/views/home/bottombar.dart';
import 'package:vbms/views/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/apiservice.dart';
import '../../views/viewimage/viewimage.dart';

class EditProfileController extends GetxController {
  ProfileController profileController = Get.put(ProfileController());
  dynamic editProfileFormKey = GlobalKey<FormState>();
  String names = '';
  String paths = '';
  String baseImg = '';
  File? frontSideImage, frontSideSelectedImage;
  final ImagePicker _picker = ImagePicker();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailID = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  String userId = '';

  @override
  void onInit() {
    // TODO: implement onInit
    loadProfileData();
    super.onInit();
  }

  loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName.text = prefs.getString('firstName').toString();
    lastName.text = prefs.getString('lastName').toString();
    mobileNumber.text = prefs.getString('mobileNo').toString();
    emailID.text = prefs.getString('emailID').toString();
    userId = prefs.getString('userID').toString();
    baseImg = prefs.getString('uploadBaseImg').toString();
    names = prefs.getString('profileImgName').toString();
    update();
  }

  handleUploadPhoto(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Upload Photo!",
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
                    uploadPhoto(ImageSource.camera);
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
                  uploadPhoto(ImageSource.gallery);
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

  uploadPhoto(ImageSource source) async {
    names = '';
    paths = '';
    baseImg = '';

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
        baseImg = imageB64.toString();
        names = fileName.toString();
        paths = image.path.toString();
        // log('baseImg is $baseImg');
        log('fileName is $fileName');
        log('names is $names');
        log('front side paths is $paths');

        update();
      }
    } catch (e) {
      log("Error Occured $e");
      update();
    }
    update();
  }

  deleteImageData() {
    names = '';
    paths = '';
    baseImg = '';
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

  handleUpdateProfile() {
    String body = jsonEncode({
      "userId": userId,
      "firstName": firstName.text,
      "lastName": lastName.text,
      "mobile": mobileNumber.text,
      "profileImgName": names.toString(),
      "uploadBaseImg": baseImg.toString()
    });

    ApiService.post('profile', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('response is $data');
      if (success.statusCode == 200) {
        updateLoginData();
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        Get.offAll(() => const BottomTile());
        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      }
    });

    log("Body $body");
  }

  updateLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', firstName.text);
    prefs.setString('lastName', lastName.text);
    prefs.setString('spocName', "${firstName.text} ${lastName.text}");
    prefs.setString('mobileNo', mobileNumber.text);
    prefs.setString('profileImgName', names.toString());
    prefs.setString('uploadBaseImg', baseImg.toString());
    profileController.getProfileData();
    update();
  }
}
