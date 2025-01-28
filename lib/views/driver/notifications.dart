import 'package:vbms/controllers/driver/notificationscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
        init: NotificationsController(),
        builder: (nsc) => Scaffold(
            // appBar: AppBar(
            //   leading: GestureDetector(
            //     onTap: () {
            //       Get.back();
            //     },
            //     child: const Icon(
            //       Icons.arrow_back_ios,
            //       size: 30,
            //     ),
            //   ),
            //   title: const Text(
            //     "Notifications",
            //     style:
            //         TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            //   ),
            //   backgroundColor: Colors.purple,
            //   iconTheme: const IconThemeData(color: Colors.white, size: 30),
            // ),
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
                child: nsc.isCurrentLoading == true
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              foregroundImage:
                                  AssetImage('packages/vbms/assets/gif/tracking.gif'),
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
                    : nsc.isLoading == true
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 80,
                                  foregroundImage:
                                      AssetImage('packages/vbms/assets/gif/tracking.gif'),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontFamily: 'Inter-Medium',
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          )
                        : nsc.notifications.isNotEmpty
                            ? ListView.builder(
                                itemCount: nsc.notifications.length,
                                itemBuilder: (context, index) {
                                  var notification = nsc.notifications[index];
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        bottom: 10,
                                        top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.purple.shade200,
                                              blurRadius: 10,
                                              spreadRadius: 2)
                                        ],
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                notification['status'] == null
                                                    ? '--'
                                                    : notification['status']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    color: Color(0xFF2a2a2a),
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                notification['date'] == null
                                                    ? '--'
                                                    : notification['date']
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontFamily: 'Inter-Medium',
                                                    color: Color(0xFF2a2a2a),
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 15,
                                                    color: Colors.purple,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text(
                                                      notification['pickUp'] ==
                                                              null
                                                          ? '--'
                                                          : notification[
                                                                  'pickUp']
                                                              .toString()
                                                              .toUpperCase(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Inter-Medium',
                                                          color:
                                                              Color(0xFF2a2a2a),
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 15,
                                                    color: Colors.purple,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text(
                                                      notification['dropAt'] ==
                                                              null
                                                          ? '--'
                                                          : notification[
                                                                  'dropAt']
                                                              .toString()
                                                              .toUpperCase(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Inter-Medium',
                                                          color:
                                                              Color(0xFF2a2a2a),
                                                          fontSize: 14),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    'Booking ID :',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Inter-Medium',
                                                        color:
                                                            Color(0xFF2a2a2a),
                                                        fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    notification[
                                                                'vehicleBookingId'] ==
                                                            null
                                                        ? '--'
                                                        : notification[
                                                                'vehicleBookingId']
                                                            .toString(),
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'Inter-Medium',
                                                        color:
                                                            Color(0xFF2a2a2a),
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  nsc.handleAccept(
                                                      notification[
                                                          'airportRegId'],
                                                      notification[
                                                          'vehicleBookingId']);
                                                },
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    width: 100,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 5,
                                                            bottom: 5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.purple,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: nsc.isLoading ==
                                                            false
                                                        ? const Text(
                                                            "Accept",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Inter-Medium',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                          )
                                                        : const SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                              strokeWidth: 2,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'packages/vbms/assets/gif/carAnimation.gif',
                                      scale: 0.6,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'No Records Found',
                                      style: TextStyle(
                                        fontFamily: 'Inter-Medium',
                                        color: Colors.purple,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ))));
  }
}
