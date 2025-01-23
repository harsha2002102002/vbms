import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiservice/apiservice.dart';

class BottomVehicleScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  String vehicleId = "";
  final addVehicleFormKey = GlobalKey<FormState>();
  String supplierName = "";
  String airportRegId = "";
  String supplierId = "";
  TextEditingController vehicleName = TextEditingController();
  TextEditingController editVehicleName = TextEditingController();
  TextEditingController registrationNumber = TextEditingController();
  TextEditingController editRegistrationNumber = TextEditingController();
  TextEditingController noOfSeats = TextEditingController();
  TextEditingController editNoOfSeats = TextEditingController();
  List vehicleList = [];
  bool isLoading = true;
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
    loadVehicleList();
    update();
  }

  buildAddVehicle() {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Form(
            key: addVehicleFormKey,
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
                      const Text("Supplier Name :",
                          style: TextStyle(
                              fontFamily: 'Inter-Medium',
                              color: Colors.black,
                              fontSize: 14)),
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                        supplierName.toString(),
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter-Medium',
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Vehicle Name",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium',
                          color: Colors.black,
                          fontSize: 16)),
                ),
                TextFormField(
                  controller: vehicleName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vehicle Name is required";
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Registration Number",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium',
                          color: Colors.black,
                          fontSize: 16)),
                ),
                TextFormField(
                  controller: registrationNumber,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Registration Number is required";
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("No. of Seats",
                      style: TextStyle(
                          fontFamily: 'Inter-Medium',
                          color: Colors.black,
                          fontSize: 16)),
                ),
                TextFormField(
                  controller: noOfSeats,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "No. of seats required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: ElevatedButton(
          onPressed: () {
            if (addVehicleFormKey.currentState!.validate()) {
              addVehicle();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Makes it rectangular
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(fontFamily: 'Inter-Medium', color: Colors.white),
          ),
        ),
      ),
    );
  }

  buildVehicleList() {
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
                  height: 480,
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
                                  fontFamily: "Inter-Medium",
                                  color: Colors.purple,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        )
                      : vehicleList.isEmpty
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
                                      fontSize: 16,
                                      fontFamily: "Inter-Medium",
                                    ),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: vehicleList.length,
                              itemBuilder: (BuildContext context, index) {
                                var vehicle = vehicleList;
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                      leading: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${vehicle[index]['vehicleName']}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Inter-Medium",
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                              "${vehicle[index]['noOfSeats']} Seater",
                                              style: const TextStyle(
                                                  fontFamily: "Inter-Medium",
                                                  fontSize: 14))
                                        ],
                                      ),
                                      trailing: PopupMenuButton(
                                        onSelected: (value) {
                                          // log('Selected: $value');
                                          if (value.toString() == 'Edit') {
                                            editVehicle(vehicle[index]);
                                            // Get.to(
                                            //         () =>
                                            //     const VehicleHome(),
                                            //     arguments: [
                                            //       value,
                                            //       vehicle[index]
                                            //     ]);
                                          } else {
                                            handleDelete(
                                                vehicle[index]['vehicleId']);
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

  editVehicle(vehicleData) {
    log('vehicle data is $vehicleData');
    editVehicleName.text = vehicleData['vehicleName'];
    editRegistrationNumber.text = vehicleData['registrationNumber'];
    editNoOfSeats.text = vehicleData['noOfSeats'];
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: Get.width * 1,
            height: Get.height * 0.6,
            child: SingleChildScrollView(
              child: Form(
                key: addVehicleFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Update Vehicle Details',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontFamily: "Inter-Medium",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 7),
                      child: Row(
                        children: [
                          const Text("Supplier Name :",
                              style: TextStyle(
                                  fontFamily: "Inter-Medium",
                                  color: Colors.black,
                                  fontSize: 16)),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            supplierName.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: "Inter-Medium",
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Vehicle Name",
                          style: TextStyle(
                              fontFamily: "Inter-Medium",
                              color: Colors.black,
                              fontSize: 16)),
                    ),
                    TextFormField(
                      controller: editVehicleName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vehicle Name is required";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text("Registration Number",
                          style: TextStyle(
                              fontFamily: "Inter-Medium",
                              color: Colors.black,
                              fontSize: 16)),
                    ),
                    TextFormField(
                      controller: editRegistrationNumber,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Registration Number is required";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("No. of Seats",
                          style: TextStyle(
                              fontFamily: "Inter-Medium",
                              color: Colors.black,
                              fontSize: 16)),
                    ),
                    TextFormField(
                      controller: editNoOfSeats,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(8.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "No. of seats required";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              if (addVehicleFormKey.currentState!.validate()) {
                                log('details');
                                log(editVehicleName.text);
                                log(editRegistrationNumber.text);
                                log(editNoOfSeats.text);
                                updateVehicle(
                                    vehicleData['vehicleId'],
                                    vehicleData['airportRegId'],
                                    vehicleData['supplierId']);
                                Get.back();
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
                              style: TextStyle(
                                  fontFamily: "Inter-Medium",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(10)),
                            width: 120,
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  fontFamily: "Inter-Medium",
                                  color: Colors.purple),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    update();
  }

  void addVehicle() async {
    isLoading = true;
    String body = jsonEncode({
      "airportRegId": airportRegId.toString(),
      "supplierId": supplierId.toString(),
      "vehicleName": vehicleName.text,
      "registrationNumber": registrationNumber.text,
      "noOfSeats": noOfSeats.text
    });

    log("Vehicle Body $body");
    await ApiService.post('/vehicles', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('response is $data');
      if (success.statusCode == 200) {
        tabController!.index = 1;
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        vehicleName.clear();
        registrationNumber.clear();
        noOfSeats.clear();
        loadVehicleList();
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

  void updateVehicle(vehicleId, airportRegId, supplierId) async {
    isLoading = true;
    log('values $vehicleId,$airportRegId,$supplierId');
    String body = jsonEncode({
      "vehicleId": vehicleId,
      "airportRegId": airportRegId.toString(),
      "supplierId": supplierId.toString(),
      "vehicleName": editVehicleName.text,
      "registrationNumber": editRegistrationNumber.text,
      "noOfSeats": editNoOfSeats.text
    });

    log("Vehicle Body $body");
    await ApiService.post('/vehicles', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('response is $data');
      if (success.statusCode == 200) {
        tabController!.index = 1;
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        vehicleName.clear();
        registrationNumber.clear();
        noOfSeats.clear();
        loadVehicleList();
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

  loadVehicleList() async {
    await ApiService.get(
            'vehicleList?airportRegId=$airportRegId&supplierId=$supplierId')
        .then((success) {
      log('status code is ${success.statusCode}');
      if (success.statusCode == 200) {
        var data = jsonDecode(success.body);
        log('response is $data');
        log(data['status'].toString());
        if (data['status'].toString() == 'true') {
          vehicleList = data['data'];
          log('vehicleList list is $vehicleList');
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

  handleDelete(vehicleId) async {
    final body = jsonEncode({'vehicleId': vehicleId});
    isLoading = true;
    await ApiService.post('/deleteVehicle', body).then((success) {
      var data = jsonDecode(success.body);
      if (success.statusCode == 200) {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        loadVehicleList();

        update();
      } else {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      }
    });
  }
}
