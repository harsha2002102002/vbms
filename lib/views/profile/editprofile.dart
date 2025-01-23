import 'package:vbms/controllers/profile/editprofilecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
        init: EditProfileController(),
        builder: (epc) => Scaffold(
              backgroundColor: Colors.pink.shade50,
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
                title: const Text(
                  "Edit Profile",
                  style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      color: Colors.white,
                      fontSize: 20),
                ),
                backgroundColor: Colors.purple,
                iconTheme: const IconThemeData(color: Colors.white, size: 30),
              ),
              body: Container(
                height: Get.height,
                width: Get.width,
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
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Form(
                      key: epc.editProfileFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: epc.firstName,
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
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1),
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
                                  fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: epc.lastName,
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
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1),
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
                              "Mobile Number *",
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: epc.mobileNumber,
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
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1),
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
                              "Upload Photo",
                              style: TextStyle(
                                  fontFamily: 'Inter-Medium',
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: epc.names.toString().isEmpty ||
                                        epc.names.toString() == "null"
                                    ? 240
                                    : 200,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: epc.names.toString().isEmpty ||
                                        epc.names.toString() == "null"
                                    ? const Text('Upload Profile Photo')
                                    : Text(epc.names.toString()),
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      epc.handleUploadPhoto(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey)),
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
                                      epc.viewImage(epc.baseImg.toString());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey)),
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
                                    visible: epc.names.toString().isEmpty ||
                                            epc.names.toString() == "null"
                                        ? false
                                        : true,
                                    child: GestureDetector(
                                      onTap: () {
                                        epc.deleteImageData();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey)),
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
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (epc.editProfileFormKey.currentState!
                                  .validate()) {
                                if (epc.names.toString().isEmpty) {
                                  Get.rawSnackbar(
                                      message: "Profile Photo is required");
                                } else {
                                  epc.handleUpdateProfile();
                                }
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 30, right: 30, top: 20),
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(10)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              alignment: Alignment.center,
                              child: const Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter-Medium'),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ));
  }
}
