import 'package:vbms/controllers/caboperator/vehicle/addvehiclecontroller.dart';
import 'package:vbms/views/caboperator/vehicle/vehiclehome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddVehicleController>(
        init: AddVehicleController(),
        builder: (avc) => Scaffold(
              // appBar: AppBar(
              //   leading: InkWell(
              //     onTap: () {
              //       Get.back();
              //     },
              //     child: const Icon(
              //       Icons.arrow_back_ios,
              //       color: Colors.white,
              //       size: 30,
              //     ),
              //   ),
              //   title: Text(
              //     avc.vehicleId != "" ? "Edit Vehicle" : "Add Vehicle",
              //     style: const TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   // centerTitle: true,
              //   backgroundColor: Colors.purple,
              //   iconTheme: const IconThemeData(color: Colors.white, size: 35),
              // ),
              body: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: avc.addVehicleFormKey,
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
                                  style: TextStyle(fontFamily: 'Inter-Medium',
                                      color: Colors.black, fontSize: 16)),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                avc.supplierName.toString(),
                                style: const TextStyle(
                                    fontFamily: 'Inter-Medium',
                                    fontSize: 16,
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
                          child: Text("Vehicle Name",
                              style:
                                  TextStyle(fontFamily: 'Inter-Medium',color: Colors.black, fontSize: 16)),
                        ),
                        TextFormField(
                          controller: avc.vehicleName,
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
                          padding: EdgeInsets.all(8),
                          child: Text("Registration Number",
                              style:
                                  TextStyle(fontFamily: 'Inter-Medium',color: Colors.black, fontSize: 16)),
                        ),
                        TextFormField(
                          controller: avc.registrationNumber,
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
                              style:
                                  TextStyle(fontFamily: 'Inter-Medium',color: Colors.black, fontSize: 16)),
                        ),
                        TextFormField(
                          controller: avc.noOfSeats,
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
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
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
                                style: TextStyle(fontFamily: 'Inter-Medium',color: Colors.purple),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (avc.addVehicleFormKey.currentState!
                                    .validate()) {
                                  avc.addVehicle();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Makes it rectangular
                                ),
                              ),
                              child: Text(
                                avc.vehicleId != "" ? "Update" : "Save",
                                style: const TextStyle(fontFamily: 'Inter-Medium',color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
