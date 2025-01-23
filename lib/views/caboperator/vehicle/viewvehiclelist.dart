import 'dart:developer';

import 'package:vbms/controllers/caboperator/vehicle/viewvehiclelistcontroller.dart';
import 'package:vbms/views/caboperator/vehicle/addvehicle.dart';
import 'package:vbms/views/caboperator/vehicle/vehiclehome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewVehicleList extends StatelessWidget {
  const ViewVehicleList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewVehicleListController>(
        init: ViewVehicleListController(),
        builder: (vvlc) => Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Get.off(() => const VehicleHome());
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
                title: const Text(
                  "Vehicle List",
                  style: TextStyle(fontFamily: 'Inter-Medium',
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.purple,
                iconTheme: const IconThemeData(color: Colors.white, size: 30),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          // contentPadding: const EdgeInsets.all(15),
                          hintText:
                              "Search by name, registration number etc...",
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          hintStyle:
                              TextStyle(fontFamily: 'Inter-Medium',color: Colors.grey.withOpacity(0.5)),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 1.4,
                        child: vvlc.isLoading == true
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.purple,
                                    ),
                                  ],
                                ),
                              )
                            : vvlc.vehicleList.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No Records Found",
                                      style: TextStyle(fontFamily: 'Inter-Medium',
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: vvlc.vehicleList.length,
                                    itemBuilder: (BuildContext context, index) {
                                      var vehicle = vvlc.vehicleList;
                                      return Container(
                                        padding: const EdgeInsets.all(8),
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Card(
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
                                                    style: const TextStyle(fontFamily: 'Inter-Medium',
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                      "${vehicle[index]['noOfSeats']} Seater",
                                                      style: const TextStyle(fontFamily: 'Inter-Medium',
                                                          fontSize: 12))
                                                ],
                                              ),
                                              trailing: PopupMenuButton(
                                                onSelected: (value) {
                                                  log('Selected: $value');

                                                  if (value.toString() ==
                                                      'Edit') {
                                                    Get.to(
                                                        () =>
                                                            const VehicleHome(),
                                                        arguments: [
                                                          value,
                                                          vehicle[index]
                                                        ]);
                                                  } else {
                                                    vvlc.handleDelete(
                                                        vehicle[index]
                                                            ['vehicleId']);
                                                  }
                                                },
                                                itemBuilder:
                                                    (BuildContext context) => [
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
                                                          color:
                                                              Colors.redAccent,
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
                                        ),
                                      );
                                    })),
                  ],
                ),
              ),
            ));
  }
}
