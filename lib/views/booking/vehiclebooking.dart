import 'dart:developer';
import 'package:vbms/controllers/booking/vehiclebookingcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleBooking extends StatefulWidget {
  const VehicleBooking({super.key});

  @override
  State<VehicleBooking> createState() => _VehicleBookingState();
}

class _VehicleBookingState extends State<VehicleBooking> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VehicleBookingController>(
        init: VehicleBookingController(),
        builder: (vb) => Scaffold(
              // appBar: AppBar(
              //   backgroundColor: Colors.purple,
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
              //     "Book Vehicle",
              //     style: TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   iconTheme: const IconThemeData(color: Colors.white),
              // ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: vb.isCurrentLoading == true
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
                                  fontFamily: 'Inter-Medium',
                                  color: Colors.purple,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
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
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: Form(
                              key: vb.bookingFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Pick Up",
                                      style: TextStyle(
                                          fontFamily: 'Inter-Medium',
                                          color: Colors.black,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.purple.shade200,
                                                  blurRadius: 2,
                                                  spreadRadius: 2),
                                            ]),
                                        child: TextFormField(
                                          controller: vb.controller,
                                          onChanged: (input) {
                                            vb.searchPlaces(
                                                input); // Trigger search when user types
                                          },
                                          decoration: InputDecoration(
                                              hintText:
                                                  vb.controller.text.isEmpty
                                                      ? "Pick Up Location"
                                                      : "",
                                              suffixIcon: vb.controller.text
                                                      .isNotEmpty
                                                  ? IconButton(
                                                      onPressed: () {
                                                        vb.clearFieldsData(
                                                            "pickup");
                                                      },
                                                      icon: const Icon(
                                                        Icons.clear,
                                                        size: 20,
                                                        color: Colors.purple,
                                                      ))
                                                  : null,
                                              prefixIcon:
                                                  const Icon(Icons.search),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      top: 12)),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please select pick up location";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      vb.suggestions.isEmpty
                                          ? vb.selectedPlace.toString().isEmpty
                                              ? const Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Text(
                                                      "No suggestions available"),
                                                )
                                              : Container()
                                          : SizedBox(
                                              height: 300,
                                              child: ListView.builder(
                                                physics: const ScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    vb.suggestions.length,
                                                itemBuilder: (context, index) {
                                                  final suggestion =
                                                      vb.suggestions[index];
                                                  return ListTile(
                                                    title: Text(suggestion[
                                                            'description'] ??
                                                        ""),
                                                    onTap: () {
                                                      setState(() {
                                                        vb.selectedPlace =
                                                            suggestion[
                                                                'description'];
                                                        vb.controller.text = vb
                                                            .selectedPlace
                                                            .toString();
                                                        log('selected value is ${vb.selectedPlace}');
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        vb.suggestions = [];
                                                      });
                                                      vb.updatePickupCoordinates();
                                                      // Fetch place details when the user selects a suggestion
                                                      // vb.getPlaceDetails(
                                                      //     suggestion['place_id'] ?? "");
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Drop At",
                                      style: TextStyle(
                                          fontFamily: 'Inter-Medium',
                                          color: Colors.black,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.purple.shade200,
                                                  blurRadius: 2,
                                                  spreadRadius: 2),
                                            ]),
                                        child: TextFormField(
                                          controller: vb.dropController,
                                          onChanged: (input) {
                                            vb.dropSearchPlaces(
                                                input); // Trigger search when user types
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please select drop location";
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(top: 12),
                                            hintText: 'Drop Location',
                                            suffixIcon: vb.dropController.text
                                                    .isNotEmpty
                                                ? IconButton(
                                                    onPressed: () {
                                                      vb.clearFieldsData(
                                                          "dropat");
                                                    },
                                                    icon: const Icon(
                                                      Icons.clear,
                                                      size: 20,
                                                      color: Colors.purple,
                                                    ))
                                                : null,
                                            prefixIcon:
                                                const Icon(Icons.search),
                                          ),
                                        ),
                                      ),
                                      vb.dropSuggestions.isEmpty
                                          ? vb.selectedDropPlace
                                                  .toString()
                                                  .isEmpty
                                              ? const Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Text(
                                                      "No suggestions available"),
                                                )
                                              : Container()
                                          : SizedBox(
                                              height: 300,
                                              child: ListView.builder(
                                                physics: const ScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    vb.dropSuggestions.length,
                                                itemBuilder: (context, index) {
                                                  final suggestion =
                                                      vb.dropSuggestions[index];
                                                  return ListTile(
                                                    title: Text(suggestion[
                                                            'description'] ??
                                                        ""),
                                                    onTap: () {
                                                      setState(() {
                                                        vb.selectedDropPlace =
                                                            suggestion[
                                                                'description'];
                                                        vb.dropController.text =
                                                            vb.selectedDropPlace
                                                                .toString();
                                                        log('selected value is ${vb.selectedDropPlace}');
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        vb.dropSuggestions = [];
                                                      });
                                                      vb.updateDropAtCoordinates();
                                                      // Fetch place details when the user selects a suggestion
                                                      // vb.getPlaceDetails(
                                                      //     suggestion['place_id'] ?? "");
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    height: 320,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.purple.shade200,
                                              blurRadius: 2,
                                              spreadRadius: 2),
                                        ]),
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: vb.currentLocation,
                                        zoom: 10,
                                      ),
                                      markers: vb.mapMarkers,
                                      polylines: vb.polyLines,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        vb.mapController1 = controller;
                                        vb.updateRoute(); // Trigger route update after controller is initialized
                                      },
                                      myLocationEnabled: true,
                                      myLocationButtonEnabled: true,
                                      zoomControlsEnabled: false,
                                      trafficEnabled: true,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
              ),
              bottomNavigationBar: Container(
                  margin: const EdgeInsets.only(
                      top: 5, left: 15, right: 15, bottom: 25),
                  child:
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (vb.bookingFormKey.currentState!.validate()) {
                          // vb.updatePickupCoordinates();
                          vb.handleBooking();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Makes it rectangular
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          vb.isLoading == false
                              ? const Text(
                                  "Book",
                                  style: TextStyle(
                                      fontFamily: 'Inter-Medium',
                                      color: Colors.white,
                                      fontSize: 16),
                                )
                              : const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                  //   ],
                  // ),
                  ),
            ));
  }
}
