import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:vbms/views/viewimage/viewimage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/apiservice.dart';

class BottomDriverScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  final addDriverFormKey = GlobalKey<FormState>();
  String airportRegId = "";
  String supplierId = "";
  String driverId = "";
  String? airportId;
  String supplierName = "";
  List frontSideNames = [];
  List editFrontSideNames = [];
  List backSideNames = [];
  List editBackSideNames = [];
  List frontSidePaths = [];
  List editFrontSidePaths = [];
  List backSidePaths = [];
  List editBackSidePaths = [];
  List frontSideBaseImg = [];
  List editFrontSideBaseImg = [];
  List backSideBaseImg = [];
  List editBackSideBaseImg = [];
  File? frontSideImage, frontSideSelectedImage;
  File? editFrontSideImage, editFrontSideSelectedImage;
  File? backSideImage, backSideSelectedImage;
  File? editBackSideImage, editBackSideSelectedImage;
  final ImagePicker _picker = ImagePicker();
  bool showPassword = true;
  TextEditingController loginPassword = TextEditingController();
  TextEditingController editLoginPassword = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController editFirstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController editLastName = TextEditingController();
  TextEditingController emailID = TextEditingController();
  TextEditingController editEmailID = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController editMobileNumber = TextEditingController();
  TextEditingController licenseNumber = TextEditingController();
  TextEditingController editLicenseNumber = TextEditingController();
  dynamic argumentData = Get.arguments;
  List driversList = [];
  bool isLoading = true;
  String buttonName = "Save";
  String appTitle = "Add Driver";

  @override
  void onInit() {
    // TODO: implement onInit
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    loadData();
    super.onInit();
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }

  loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    log("LoadingData");
    airportRegId = pref.getString("airportRegId").toString();
    supplierId = pref.getString('supplierId').toString();
    supplierName = pref.getString('spocName').toString();
    airportId = pref.getString('airportId');
    log("Airport ID $airportId");
    loadDriversList();
    update();
  }

  buildAddDriver() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
              Color(0xFFDFD0DF),
              Color(0xFFDFD0DF),
            ],
            begin: Alignment.topLeft, // Start of the gradient
            end: Alignment.bottomRight, // End of the gradient
          ),
        ),
        child: Form(
            key: addDriverFormKey,
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const Text("Supplier Name",
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  color: Colors.black,
                                  fontSize: 16)),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            supplierName.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter-Medium',
                                color: Colors.black,
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "First Name *",
                        style: TextStyle(
                            fontFamily: 'Inter-Medium',
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: firstName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(8))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "First Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Last Name *",
                        style: TextStyle(
                            fontFamily: 'Inter-Medium',
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: lastName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(8))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Last Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Email ID *",
                        style: TextStyle(
                            fontFamily: 'Inter-Medium',
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: emailID,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(8))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email ID is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Mobile Number *",
                        style: TextStyle(
                            fontFamily: 'Inter-Medium',
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: mobileNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(8))),
                      validator: (value) {
                        if (value!.isEmpty ||
                            value.length > 10 ||
                            value.length < 10) {
                          return "Enter a valid Mobile No.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Password",
                        style: TextStyle(
                            fontFamily: 'Inter-Medium',
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: loginPassword,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              showPassword = !showPassword;
                              update();
                            },
                            child: showPassword
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.purple,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.purple,
                                  ),
                          )),
                      obscureText: showPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "License Number *",
                        style: TextStyle(
                            fontFamily: 'Inter-Medium',
                            color: Colors.black,
                            fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: licenseNumber,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8)),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(8))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "License Number is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Upload License",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter-Medium',
                            color: Colors.black),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: frontSideNames.isEmpty ? 220 : 180,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)),
                          child: frontSideNames.isEmpty
                              ? const Text('Upload Front Side')
                              : Text(frontSideNames[0].toString()),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                frontSideHandleUpload();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: const Icon(
                                  Icons.upload,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                viewImage(frontSideBaseImg[0].toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: const Icon(
                                  Icons.visibility,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: frontSideNames.isEmpty ? false : true,
                              child: GestureDetector(
                                onTap: () {
                                  deleteFrontSideImageData();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: backSideNames.isEmpty ? 220 : 180,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)),
                          child: backSideNames.isEmpty
                              ? const Text('Upload Back Side')
                              : Text(backSideNames[0].toString()),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                backSideHandleUpload();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: const Icon(
                                  Icons.upload,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                viewImage(backSideBaseImg[0].toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: const Icon(
                                  Icons.visibility,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: backSideNames.isEmpty ? false : true,
                              child: GestureDetector(
                                onTap: () {
                                  deleteBackSideImageData();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )),
      ),
      bottomNavigationBar: buttonName == "Save"
          ? Container(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 10, top: 10),
              child: ElevatedButton(
                onPressed: () {
                  if (addDriverFormKey.currentState!.validate()) {
                    if (frontSideNames.isEmpty) {
                      Get.rawSnackbar(message: "Upload License Front Image");
                    } else if (backSideNames.isEmpty) {
                      Get.rawSnackbar(message: "Upload License back Image");
                    } else {
                      FocusNode().unfocus();
                      saveDriverData();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Makes it rectangular
                  ),
                ),
                child: Text(
                  buttonName.toString(),
                  style: const TextStyle(
                      fontFamily: 'Inter-Medium', color: Colors.white),
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        if (addDriverFormKey.currentState!.validate()) {
                          if (frontSideNames.isEmpty) {
                            Get.rawSnackbar(
                                message: "Upload License Front Image");
                          } else if (backSideNames.isEmpty) {
                            Get.rawSnackbar(
                                message: "Upload License back Image");
                          } else {
                            FocusNode().unfocus();
                            saveDriverData();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Makes it rectangular
                        ),
                      ),
                      child: Text(
                        buttonName.toString(),
                        style: const TextStyle(
                            fontFamily: 'Inter-Medium', color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        tabController!.index = 1;
                        loginPassword.clear();
                        firstName.clear();
                        lastName.clear();
                        emailID.clear();
                        mobileNumber.clear();
                        licenseNumber.clear();
                        frontSideNames.clear();
                        frontSidePaths.clear();
                        frontSideBaseImg.clear();
                        backSideNames.clear();
                        backSidePaths.clear();
                        backSideBaseImg.clear();
                        driverId = "";
                        buttonName = "Save";
                        appTitle = "Add Driver";
                        loadDriversList();
                        update();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.purple),
                          borderRadius:
                              BorderRadius.circular(10), // Makes it rectangular
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            fontFamily: 'Inter-Medium', color: Colors.purple),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  buildDriversList() {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                  height: Get.height / 1.4,
                  child: isLoading == true
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 80,
                                foregroundImage:
                                    AssetImage('assets/gif/tracking.gif'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 14,
                                  fontFamily: 'Inter-Medium',
                                ),
                              )
                            ],
                          ),
                        )
                      : driversList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/gif/carAnimation.gif',
                                    scale: 0.6,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'No Records Found',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter-Medium',
                                    ),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: driversList.length,
                              itemBuilder: (BuildContext context, index) {
                                var driver = driversList;
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                      leading: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${driver[index]['fullName']}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Inter-Medium',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text("+91${driver[index]['mobile']}",
                                              style: const TextStyle(
                                                  fontFamily: 'Inter-Medium',
                                                  fontSize: 14))
                                        ],
                                      ),
                                      trailing: PopupMenuButton(
                                        onSelected: (value) {
                                          log('Selected: $value');
                                          if (value.toString() == 'Edit') {
                                            log('driver data is ${driver[index]}');
                                            driverId =
                                                driver[index]['driverId'];
                                            firstName.text =
                                                driver[index]['firstName'];
                                            lastName.text =
                                                driver[index]['lastName'];
                                            emailID.text =
                                                driver[index]['email'];
                                            mobileNumber.text =
                                                driver[index]['mobile'];
                                            licenseNumber.text =
                                                driver[index]['driverLicence'];
                                            frontSideNames.add(driver[index]
                                                ['uploadFrontName']);
                                            frontSidePaths.add(driver[index]
                                                ['uploadFrontPath']);
                                            frontSideBaseImg.add(
                                                driver[index]['uploadFront']);
                                            backSideNames.add(driver[index]
                                                ['uploadBackName']);
                                            backSidePaths.add(driver[index]
                                                ['uploadBackPath']);
                                            backSideBaseImg.add(
                                                driver[index]['uploadBack']);
                                            buttonName = "Update";
                                            appTitle = "Update Driver Details";
                                            tabController!.index = 0;
                                            update();
                                          } else {
                                            handleDelete(
                                                driver[index]['driverId']);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          const PopupMenuItem(
                                            value: 'Edit',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit,
                                                  size: 18,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'Delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text('Delete'),
                                              ],
                                            ),
                                          ),
                                        ],
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                      )),
                                );
                              })),
            ],
          ),
        ),
      ),
    );
  }

  handleDelete(driverId) async {
    final body = jsonEncode({'driverId': driverId});
    isLoading = true;
    await ApiService.post('deleteDriver', body).then((success) {
      var data = jsonDecode(success.body);
      if (success.statusCode == 200) {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        loadDriversList();
        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      }
    });
  }

  viewImage(imageData) {
    log('image data is $imageData');
    if (imageData.toString().isNotEmpty) {
      Get.to(() => const ViewImage(), arguments: imageData);
      update();
    } else {
      Get.rawSnackbar(message: 'Nothing to view');
      update();
    }
  }

  frontSideHandleUpload() {
    return Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: const Text(
          "Add Front Side Photo !",
          style: TextStyle(fontFamily: 'Inter-Medium', fontSize: 16),
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
                        style: TextStyle(
                            fontFamily: 'Inter-Medium', color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () async {
                    frontSideUploadPhoto(ImageSource.camera);
                    Get.back();
                  }),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Choose From Gallery",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium', color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  frontSideUploadPhoto(ImageSource.gallery);
                  Get.back();
                },
              ),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium', color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  editFrontSideHandleUpload() {
    return Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: const Text(
          "Add Front Side Photo !",
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
                        style: TextStyle(
                            fontFamily: 'Inter-Medium', color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () async {
                    editFrontSideUploadPhoto(ImageSource.camera);
                    Get.back();
                  }),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Choose From Gallery",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium', color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  editFrontSideUploadPhoto(ImageSource.gallery);
                  Get.back();
                },
              ),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium', color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  backSideHandleUpload() {
    return Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: const Text(
          "Add Back Side Photo !",
          style: TextStyle(fontFamily: 'Inter-Medium', fontSize: 16),
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
                        style: TextStyle(
                            fontFamily: 'Inter-Medium', color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () async {
                    backSideUploadPhoto(ImageSource.camera);
                    Get.back();
                  }),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Choose From Gallery",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium', color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  backSideUploadPhoto(ImageSource.gallery);
                  Get.back();
                },
              ),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium', color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  editBackSideHandleUpload() {
    return Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: const Text(
          "Add Back Side Photo !",
          style: TextStyle(fontFamily: 'Inter-Medium', fontSize: 16),
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
                        style: TextStyle(
                            fontFamily: 'Inter-Medium', color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () async {
                    editBackSideUploadPhoto(ImageSource.camera);
                    Get.back();
                  }),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Choose From Gallery",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium', color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  editBackSideUploadPhoto(ImageSource.gallery);
                  Get.back();
                },
              ),
              GestureDetector(
                child: const Card(
                  color: Colors.purple,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium', color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                onTap: () {
                  Get.back();
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

  editFrontSideUploadPhoto(ImageSource source) async {
    editFrontSideNames = [];
    editFrontSidePaths = [];
    editFrontSideBaseImg = [];

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    final File file = File(image!.path);

    try {
      if (image != null) {
        editFrontSideSelectedImage = file;
        String fileName = image.path.toString().split('/').last;
        List<int> imageBytes = editFrontSideSelectedImage!.readAsBytesSync();
        var imageB64 = base64Encode(imageBytes);
        editFrontSideBaseImg.add(imageB64);
        editFrontSideNames.add(fileName);
        editFrontSidePaths.add(image.path.toString());
        // log('baseImg is $baseImg');
        log('fileName is $fileName');
        log('names is $editFrontSideNames');
        log('front side paths is $editFrontSidePaths');

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

  editBackSideUploadPhoto(ImageSource source) async {
    editBackSideNames = [];
    editBackSidePaths = [];
    editBackSideBaseImg = [];

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    final File file = File(image!.path);

    try {
      if (image != null) {
        editBackSideSelectedImage = file;
        String fileName = image.path.toString().split('/').last;
        List<int> imageBytes = editBackSideSelectedImage!.readAsBytesSync();
        var imageB64 = base64Encode(imageBytes);
        editBackSideBaseImg.add(imageB64);
        editBackSideNames.add(fileName);
        editBackSidePaths.add(image.path.toString());
        // log('baseImg is $baseImg');
        log('fileName is $fileName');
        log('names is $editBackSideNames');
        log('front side paths is $editBackSidePaths');

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

  editDeleteBackSideImageData() {
    editBackSideNames = [];
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

  editDeleteFrontSideImageData() {
    editFrontSideNames = [];
    editFrontSidePaths = [];
    editFrontSideBaseImg = [];
    update();
  }

  saveDriverData() {
    log('driver id is $driverId');
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
        tabController!.index = 1;
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        loginPassword.clear();
        firstName.clear();
        lastName.clear();
        emailID.clear();
        mobileNumber.clear();
        licenseNumber.clear();
        frontSideNames.clear();
        frontSidePaths.clear();
        frontSideBaseImg.clear();
        backSideNames.clear();
        backSidePaths.clear();
        backSideBaseImg.clear();
        driverId = "";
        buttonName = "Save";
        appTitle = "Add Driver";
        loadDriversList();
        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      }
    });
    update();
  }

  void loadDriversList() {
    ApiService.get(
            'driverList?airportRegId=$airportRegId&supplierId=$supplierId')
        .then((success) {
      log('status code is ${success.statusCode}');
      if (success.statusCode == 200) {
        var data = jsonDecode(success.body);
        log('response is $data');
        log(data['status'].toString());
        if (data['status'].toString() == 'true') {
          driversList = data['data'];
          log('driversList is $driversList');
          isLoading = false;
          update();
        }
        update();
      } else {
        Get.rawSnackbar(
            message: 'Something went wrong, Please try again later');
      }
      isLoading = false;
      update();
    });

    update();
  }
}
