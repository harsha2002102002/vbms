import 'dart:developer';

import 'package:vbms/controllers/caboperator/driver/viewdriverscontroller.dart';
import 'package:vbms/views/caboperator/driver/adddriver.dart';
import 'package:vbms/views/caboperator/driver/driverhome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewDrivers extends StatefulWidget {
  const ViewDrivers({super.key});

  @override
  State<ViewDrivers> createState() => _ViewDriversState();
}

class _ViewDriversState extends State<ViewDrivers> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewDriversController>(
        init: ViewDriversController(),
        builder: (vds) => Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Get.off(() => const DriverHome());
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
                title: const Text(
                  "View Drivers",
                  style: TextStyle(
                      fontFamily: 'Inter-Medium',
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.purple,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                  size: 35,
                ),
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
                          hintText: "Search by Name / License No.",
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
                        child: vds.isLoading == true
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
                            : vds.driversList.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No Records Found",
                                      style: TextStyle(
                                          fontFamily: 'Inter-Medium',
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: vds.driversList.length,
                                    itemBuilder: (BuildContext context, index) {
                                      var driver = vds.driversList;
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
                                                    "${driver[index]['fullName']}",
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                      "+91${driver[index]['mobile']}",
                                                      style: const TextStyle(
                                                          fontSize: 12))
                                                ],
                                              ),
                                              trailing: PopupMenuButton(
                                                onSelected: (value) {
                                                  log('Selected: $value');

                                                  if (value.toString() ==
                                                      'Edit') {
                                                    Get.to(
                                                        () => const AddDriver(),
                                                        arguments: [
                                                          value,
                                                          driver[index]
                                                        ]);
                                                  } else {
                                                    vds.handleDelete(
                                                        driver[index]
                                                            ['driverId']);
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
