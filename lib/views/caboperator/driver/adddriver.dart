import 'package:vbms/controllers/caboperator/driver/adddrivercontroller.dart';
import 'package:vbms/views/caboperator/driver/driverhome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({super.key});

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddDriverController>(
        init: AddDriverController(),
        builder: (ad) => Scaffold(
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
                  "Add Driver",
                  style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // centerTitle: true,
                backgroundColor: Colors.purple,
                iconTheme: const IconThemeData(color: Colors.white, size: 35),
              ),
              body: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                      key: ad.addDriverFormKey,
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
                                        color: Colors.black, fontSize: 16)),
                                const SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  ad.supplierName.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: ad.firstName,
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: ad.lastName,
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
                              "Email ID *",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: ad.emailID,
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
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: ad.mobileNumber,
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
                              "Password",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: ad.loginPassword,
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
                                    borderRadius: BorderRadius.circular(8)),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    ad.showPassword = !ad.showPassword;
                                    ad.update();
                                  },
                                  child: ad.showPassword
                                      ? const Icon(
                                          Icons.visibility_off,
                                          color: Colors.purple,
                                        )
                                      : const Icon(
                                          Icons.visibility,
                                          color: Colors.purple,
                                        ),
                                )),
                            obscureText: ad.showPassword,
                            validator: (value) {
                              if (ad.driverId == "" && (value!.isEmpty)) {
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            controller: ad.licenseNumber,
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: ad.frontSideNames.isEmpty ? 240 : 200,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: ad.frontSideNames.isEmpty
                                    ? const Text('Upload Front Side')
                                    : Text(ad.frontSideNames[0].toString()),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      ad.frontSideHandleUpload(context);
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
                                      ad.viewImage(
                                          ad.frontSideBaseImg[0].toString());
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
                                    visible: ad.frontSideNames.isEmpty
                                        ? false
                                        : true,
                                    child: GestureDetector(
                                      onTap: () {
                                        ad.deleteFrontSideImageData();
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
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: ad.backSideNames.isEmpty ? 240 : 200,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: ad.backSideNames.isEmpty
                                    ? const Text('Upload Back Side')
                                    : Text(ad.backSideNames[0].toString()),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      ad.backSideHandleUpload(context);
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
                                      ad.viewImage(
                                          ad.backSideBaseImg[0].toString());
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
                                    visible:
                                        ad.backSideNames.isEmpty ? false : true,
                                    child: GestureDetector(
                                      onTap: () {
                                        ad.deleteBackSideImageData();
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
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.off(() => const DriverHome());
                                },
                                style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.purple, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Makes it rectangular
                                  ),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.purple),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (ad.addDriverFormKey.currentState!
                                      .validate()) {
                                    if (ad.frontSideNames.isEmpty) {
                                      Get.rawSnackbar(
                                          message:
                                              "Upload License Front Image");
                                    } else if (ad.backSideNames.isEmpty) {
                                      Get.rawSnackbar(
                                          message: "Upload License back Image");
                                    } else {
                                      ad.saveDriverData();
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Makes it rectangular
                                  ),
                                ),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ));
  }
}
