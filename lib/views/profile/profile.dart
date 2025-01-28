import 'dart:convert';
import 'dart:developer';
import 'package:vbms/controllers/profile/profilecontroller.dart';
import 'package:vbms/views/profile/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (pc) {
        return Scaffold(
          body: Container(
            height: Get.height,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 30),
                child: pc.isLoading == true
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height / 5,
                            ),
                            const CircleAvatar(
                              radius: 80,
                              foregroundImage:
                                  AssetImage('packages/vbms/assets/gif/tracking.gif'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Loading...',
                              style: TextStyle(
                                fontFamily: 'Inter-Medium',
                                color: Colors.purple,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              log('edit');
                              Get.to(() => const EditProfile());
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(100)),
                                margin: const EdgeInsets.all(10),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.purple, width: 2),
                                borderRadius: BorderRadius.circular(100)),
                            padding: const EdgeInsets.all(2.0),
                            margin: const EdgeInsets.all(10.0),
                            child: pc.baseImg.toString().isEmpty ||
                                    pc.baseImg.toString() == 'null'
                                ? CircleAvatar(
                                    radius: 60,
                                    child: Text(
                                      pc.firstName.toString().substring(0, 1),
                                      style: const TextStyle(
                                        fontSize: 50,
                                        fontFamily: 'Inter-Medium',
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundImage: MemoryImage(
                                      base64Decode(pc.baseImg.toString()),
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.purple.shade200,
                                      blurRadius: 10,
                                      spreadRadius: 2),
                                ]),
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: "${pc.firstName} ${pc.lastName}",
                                  hintStyle: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter-Medium',
                                    color: Colors.purple,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.purple,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.purple.shade200,
                                      blurRadius: 10,
                                      spreadRadius: 2)
                                ]),
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: pc.emailID,
                                  hintStyle: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter-Medium',
                                    color: Colors.purple,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.purple,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.purple.shade200,
                                      blurRadius: 10,
                                      spreadRadius: 2)
                                ]),
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: pc.mobileNo,
                                  hintStyle: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter-Medium',
                                    color: Colors.purple,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Colors.purple,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.purple.shade200,
                                      blurRadius: 10,
                                      spreadRadius: 2)
                                ]),
                            child: const TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Privacy policy",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter-Medium',
                                    color: Colors.purple,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.arrow_right,
                                    color: Colors.purple,
                                    size: 30,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.privacy_tip,
                                    color: Colors.purple,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.purple.shade200,
                                      blurRadius: 10,
                                      spreadRadius: 2)
                                ]),
                            child: const TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Settings",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter-Medium',
                                    color: Colors.purple,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.arrow_right,
                                    color: Colors.purple,
                                    size: 30,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.settings,
                                    color: Colors.purple,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: pc.roleType.toString() == "Driver"
                                ? true
                                : false,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: pc.roleType.toString() ==
                                                  "Driver" &&
                                              (pc.driverStatus.toString() ==
                                                      "Start Shift" ||
                                                  pc.driverStatus.toString() ==
                                                      "Resume Shift")
                                          ? true
                                          : false,
                                      child: GestureDetector(
                                        onTap: () {
                                          pc.handleShift("Pause Shift");
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: Get.width / 2.4,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color:
                                                        Colors.purple.shade200,
                                                    blurRadius: 10,
                                                    spreadRadius: 2)
                                              ]),
                                          child: const TextField(
                                            enabled: false,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Pause Shift",
                                                hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Inter-Medium',
                                                  color: Colors.purple,
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.pause,
                                                  color: Colors.purple,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          pc.roleType.toString() == "Driver" &&
                                                  (pc.driverStatus.toString() ==
                                                      "Pause Shift")
                                              ? true
                                              : false,
                                      child: GestureDetector(
                                        onTap: () {
                                          pc.handleShift("Resume Shift");
                                        },
                                        child: Container(
                                          width: Get.width / 2.3,
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color:
                                                        Colors.purple.shade200,
                                                    blurRadius: 10,
                                                    spreadRadius: 2)
                                              ]),
                                          child: const TextField(
                                            enabled: false,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Resume Shift",
                                                hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Inter-Medium',
                                                  color: Colors.purple,
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.purple,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          pc.roleType.toString() == "Driver" &&
                                              pc.driverStatus.toString() !=
                                                  "End Shift",
                                      child: GestureDetector(
                                        onTap: () {
                                          pc.handleShift("End Shift");
                                        },
                                        child: SizedBox(
                                          width: Get.width / 2.3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors
                                                          .purple.shade200,
                                                      blurRadius: 10,
                                                      spreadRadius: 2)
                                                ]),
                                            child: const TextField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: "End Shift",
                                                  hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Inter-Medium',
                                                    color: Colors.purple,
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.close,
                                                    color: Colors.purple,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              pc.clearData();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.purple.shade200,
                                        blurRadius: 10,
                                        spreadRadius: 2)
                                  ]),
                              child: const TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Logout",
                                    hintStyle: TextStyle(
                                      fontFamily: 'Inter-Medium',
                                      color: Colors.purple,
                                      fontSize: 16
                                    ),
                                    prefixIcon: Icon(
                                      Icons.exit_to_app,
                                      color: Colors.purple,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
