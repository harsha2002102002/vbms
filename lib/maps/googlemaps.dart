import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../apiservice/apiservice.dart';
import '../views/home/bottombar.dart';
import 'googlmaps1.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({
    super.key,
    required this.dLatitude,
    required this.dLongitude,
    required this.pLatitude,
    required this.pLongitude,
    required this.tripData,
    required this.tripStatus,
  });

  final double dLatitude;
  final double pLatitude;
  final double dLongitude;
  final double pLongitude;
  final Map tripData;
  final String tripStatus;

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? mapController; // Nullable map controller
  Set<Polyline> polyLines = {};
  Set<Marker> mapMarkers = {};
  late LatLng _currentLocation;
  late LatLng airport;
  bool isLoading = true;
  Timer? _locationTimer;
  String? userRole;
  String? supplierID;
  String? tripStatus;
  bool isFabExpanded = true;

  @override
  void initState() {
    log('trip data ${widget.tripData}');
    updateTracking();
    setState(() {
      _currentLocation = LatLng(widget.pLatitude, widget.pLongitude);
      // _currentLocation = const LatLng(0.0, 0.0);
      log('pick lat long is $_currentLocation');
      airport = LatLng(widget.dLatitude, widget.dLongitude);
      log('drop lat long is $airport');
    });
    requestLocationPermission();
    getCurrentLocation();
    _startLocationUpdates();
    super.initState();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      getCurrentLocation();
    });
  }

  Future<void> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled. Prompting user...');
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          debugPrint('User did not enable location services.');
          return;
        }
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        debugPrint(
            'Location permissions are permanently denied. Please enable them in settings.');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update latitude and longitude
      var latitude = position.latitude.toString();
      var longitude = position.longitude.toString();
      log('Driver lat/lon: $latitude, $longitude');
      // _currentLocation = LatLng(position.latitude, position.longitude);
      // log('Current lat/lon: $_currentLocation');
      _updateRoute();

      // Reverse geocode to get address
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;
        var currentPlace =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
        debugPrint('Current place: $currentPlace');
      } else {
        debugPrint('No address available for the current location.');
      }
    } catch (e) {
      debugPrint('Error while getting location details: $e');
    }
  }

  // getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     setState(() {
  //       _currentLocation = LatLng(position.latitude, position.longitude);
  //       log('current lat long is $_currentLocation');
  //       _updateRoute();
  //     });
  //   } catch (error) {
  //     log('Error fetching location: $error');
  //   }
  // }

  _updateRoute() async {
    await _getDirections(_currentLocation, airport);
    setState(() {
      isLoading = false;
    });
    _addMarkers();
  }

  _getDirections(LatLng origin, LatLng destination) async {
    if (mapController == null) {
      log('mapController is not initialized yet.');
      return;
    }

    const String apiKey =
        'AIzaSyB4Z7TS_eDUaBfMH_lVq1NCOmrYZceSiwY'; // Replace with your API key
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var routes = data['routes'];

        if (routes.isNotEmpty) {
          var steps = routes[0]['legs'][0]['steps'];
          List<LatLng> polylineCoordinates = [];
          for (var step in steps) {
            var polyline = step['polyline']['points'];
            polylineCoordinates.addAll(_decodePolyline(polyline));
          }

          polylineCoordinates
              .add(LatLng(destination.latitude, destination.longitude));

          setState(() {
            polyLines.add(Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ));
          });

          mapController?.animateCamera(
            CameraUpdate.newLatLng(origin),
          );
        }
      } else {
        log('Failed to fetch directions: ${response.statusCode}');
      }
    } catch (error) {
      log('Error fetching directions: $error');
    }
  }

  List<LatLng> _decodePolyline(String encodedPolyline) {
    List<LatLng> polylinePoints = [];
    int index = 0;
    int len = encodedPolyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int byte;

      do {
        byte = encodedPolyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (result & 0x01 != 0 ? ~(result >> 1) : (result >> 1));

      shift = 0;
      result = 0;

      do {
        byte = encodedPolyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (result & 0x01 != 0 ? ~(result >> 1) : (result >> 1));

      polylinePoints.add(LatLng((lat / 1E5), (lng / 1E5)));
    }

    return polylinePoints;
  }

  void _addMarkers() {
    setState(() {
      mapMarkers = {
        Marker(
          markerId: const MarkerId('current'),
          position: _currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId('airport'),
          position: airport,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Get.offAll(() => const BottomTile()),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
        ),
        actions: [
          Visibility(
            visible: userRole.toString() == "Driver" ? true : false,
            child: GestureDetector(
              onTap: () {
                handleStartEndTrip();
              },
              child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 50,
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                    tripStatus.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: "Inter-Medium",
                    ),
                  )),
            ),
          )
        ],
        title: const Text(
          "Tracking",
          style: TextStyle(
              color: Colors.white, fontFamily: "Inter-Medium", fontSize: 20),
        ),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    foregroundImage: AssetImage('assets/gif/tracking.gif'),
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
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation,
                    zoom: 18,
                  ),
                  markers: mapMarkers,
                  polylines: polyLines,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    _updateRoute(); // Trigger route update after controller is initialized
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  trafficEnabled: true,
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: FloatingActionButton(
                //       onPressed: () {
                //         if (mapController != null) {
                //           mapController!.animateCamera(
                //             CameraUpdate.newLatLng(_currentLocation),
                //           );
                //         }
                //       },
                //       backgroundColor: Colors.white,
                //       child: const Icon(
                //         Icons.my_location,
                //         size: 30,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }

  handleStartEndTrip() async {
    setState(() {
      double dLatitude = 0.0,
          dLongitude = 0.0,
          pLatitude = 0.0,
          pLongitude = 0.0;
      String body;
      if (widget.tripStatus == "" || widget.tripStatus.isEmpty) {
        tripStatus = "Start Trip";
      } else if (widget.tripStatus == "On Going") {
        tripStatus = "End Trip";
      } else if (widget.tripStatus == "End Trip") {
        tripStatus = "End Trip";
      } else if (widget.tripStatus == "Accepted") {
        tripStatus = "Start Trip";
      }
      log('trip status is $tripStatus');
      if (tripStatus == "Start Trip") {
        if (widget.tripData.toString().contains('tripDetails')) {
          pLatitude = widget.tripData['tripDetails']['pickupLatitude']
                  .toString()
                  .isNotEmpty
              ? double.parse(
                  widget.tripData['tripDetails']['pickupLatitude'].toString())
              : 0.0;
          dLatitude = widget.tripData['tripDetails']['dropAtLatitude']
                  .toString()
                  .isNotEmpty
              ? double.parse(
                  widget.tripData['tripDetails']['dropAtLatitude'].toString())
              : 0.0;
          pLongitude = widget.tripData['tripDetails']['pickupLongitude']
                  .toString()
                  .isNotEmpty
              ? double.parse(
                  widget.tripData['tripDetails']['pickupLongitude'].toString(),
                )
              : 0.0;
          dLongitude = widget.tripData['tripDetails']['dropAtLongitude']
                  .toString()
                  .isNotEmpty
              ? double.parse(
                  widget.tripData['tripDetails']['dropAtLongitude'].toString())
              : 0.0;
          body = jsonEncode({
            "BookingFor":
                widget.tripData['tripDetails']['BookingFor'].toString(),
            "airportId": widget.tripData['tripDetails']['airportId'].toString(),
            "vehicleBookingId": widget.tripData['vehicleBookingId'].toString(),
            "airportRegId": widget.tripData['airportRegId'].toString(),
            "departmentId":
                widget.tripData['tripDetails']['departmentId'].toString(),
            "departmentTypeId":
                widget.tripData['tripDetails']['departmentTypeId'].toString(),
            "date": widget.tripData['tripDetails']['date'].toString(),
            "dropAt": widget.tripData['tripDetails']['dropAt'].toString(),
            "dropAtLatitude":
                widget.tripData['tripDetails']['dropAtLatitude'].toString(),
            "dropAtLongitude":
                widget.tripData['tripDetails']['dropAtLongitude'].toString(),
            "isActive": "true",
            "isDeleted": false,
            "pickUp": widget.tripData['tripDetails']['pickUp'].toString(),
            "pickupLatitude":
                widget.tripData['tripDetails']['pickupLatitude'].toString(),
            "pickupLongitude":
                widget.tripData['tripDetails']['pickupLongitude'].toString(),
            "status": "StartTrip",
            "time": widget.tripData['tripDetails']['time'].toString(),
            "supplierId": supplierID.toString(),
          });
        } else {
          pLatitude = widget.tripData['pickupLatitude'].toString().isNotEmpty
              ? double.parse(widget.tripData['pickupLatitude'].toString())
              : 0.0;
          dLatitude = widget.tripData['dropAtLatitude'].toString().isNotEmpty
              ? double.parse(widget.tripData['dropAtLatitude'].toString())
              : 0.0;
          pLongitude = widget.tripData['pickupLongitude'].toString().isNotEmpty
              ? double.parse(
                  widget.tripData['pickupLongitude'].toString(),
                )
              : 0.0;
          dLongitude = widget.tripData['dropAtLongitude'].toString().isNotEmpty
              ? double.parse(widget.tripData['dropAtLongitude'].toString())
              : 0.0;
          body = jsonEncode({
            "BookingFor": widget.tripData['BookingFor'].toString(),
            "airportId": widget.tripData['airportId'].toString(),
            "vehicleBookingId": widget.tripData['vehicleBookingId'].toString(),
            "airportRegId": widget.tripData['airportRegId'].toString(),
            "departmentId": widget.tripData['departmentId'].toString(),
            "departmentTypeId": widget.tripData['departmentTypeId'].toString(),
            "date": widget.tripData['date'].toString(),
            "dropAt": widget.tripData['dropAt'].toString(),
            "dropAtLatitude": widget.tripData['dropAtLatitude'].toString(),
            "dropAtLongitude": widget.tripData['dropAtLongitude'].toString(),
            "isActive": "true",
            "isDeleted": false,
            "pickUp": widget.tripData['pickUp'].toString(),
            "pickupLatitude": widget.tripData['pickupLatitude'].toString(),
            "pickupLongitude": widget.tripData['pickupLongitude'].toString(),
            "status": "StartTrip",
            "time": widget.tripData['time'].toString(),
            "supplierId": supplierID.toString(),
          });
        }
        log('$dLatitude, $dLongitude, $pLatitude, $pLongitude, $body');
        startTrip(dLatitude, dLongitude, pLatitude, pLongitude, body);
      } else if (tripStatus == "End Trip") {
        if (widget.tripData.toString().contains('tripDetails')) {
          body = jsonEncode({
            "BookingFor":
                widget.tripData['tripDetails']['BookingFor'].toString(),
            "airportId": widget.tripData['tripDetails']['airportId'].toString(),
            "vehicleBookingId": widget.tripData['vehicleBookingId'].toString(),
            "airportRegId": widget.tripData['airportRegId'].toString(),
            "departmentId":
                widget.tripData['tripDetails']['departmentId'].toString(),
            "departmentTypeId":
                widget.tripData['tripDetails']['departmentTypeId'].toString(),
            "date": widget.tripData['tripDetails']['date'].toString(),
            "dropAt": widget.tripData['tripDetails']['dropAt'].toString(),
            "dropAtLatitude":
                widget.tripData['tripDetails']['dropAtLatitude'].toString(),
            "dropAtLongitude":
                widget.tripData['tripDetails']['dropAtLongitude'].toString(),
            "isActive": "true",
            "isDeleted": false,
            "pickUp": widget.tripData['tripDetails']['pickUp'].toString(),
            "pickupLatitude":
                widget.tripData['tripDetails']['pickupLatitude'].toString(),
            "pickupLongitude":
                widget.tripData['tripDetails']['pickupLongitude'].toString(),
            "status": "EndTrip",
            "time": widget.tripData['tripDetails']['time'].toString(),
            "supplierId": supplierID.toString(),
          });
        } else {
          body = jsonEncode({
            "BookingFor": widget.tripData['BookingFor'].toString(),
            "airportId": widget.tripData['airportId'].toString(),
            "vehicleBookingId": widget.tripData['vehicleBookingId'].toString(),
            "airportRegId": widget.tripData['airportRegId'].toString(),
            "departmentId": widget.tripData['departmentId'].toString(),
            "departmentTypeId": widget.tripData['departmentTypeId'].toString(),
            "date": widget.tripData['date'].toString(),
            "dropAt": widget.tripData['dropAt'].toString(),
            "dropAtLatitude": widget.tripData['dropAtLatitude'].toString(),
            "dropAtLongitude": widget.tripData['dropAtLongitude'].toString(),
            "isActive": "true",
            "isDeleted": false,
            "pickUp": widget.tripData['pickUp'].toString(),
            "pickupLatitude": widget.tripData['pickupLatitude'].toString(),
            "pickupLongitude": widget.tripData['pickupLongitude'].toString(),
            "status": "EndTrip",
            "time": widget.tripData['time'].toString(),
            "supplierId": supplierID.toString(),
          });
        }
        endTrip(body);
      }
    });
  }

  updateTracking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('userRole').toString();
      supplierID = prefs.getString('supplierId').toString();
      log('role is $userRole');
      log('supplierID is $supplierID');
      if (widget.tripStatus == "" || widget.tripStatus.isEmpty) {
        tripStatus = "Start Trip";
      } else if (widget.tripStatus == "On Going") {
        tripStatus = "End Trip";
      } else if (widget.tripStatus == "Accepted") {
        tripStatus = "Start Trip";
      } else if (widget.tripStatus == "End Trip") {
        tripStatus = "End Trip";
      }
      log('trip status is $tripStatus');
    });
  }

  startTrip(dLatitude, dLongitude, pLatitude, pLongitude, jsonBody) async {
    log('jsonBody is ------>$jsonBody');
    setState(() {
      var body = jsonBody;
      log('body is ------>$body');
      ApiService.post('startAndEndTrip', body).then((success) {
        log('status code is ${success.statusCode}');
        var data = jsonDecode(success.body);
        log('response is $data');
        if (success.statusCode == 200) {
          setState(() {
            isLoading = true;
            tripStatus = "End Trip";
            polyLines = {};
            mapMarkers = {};
            _currentLocation = LatLng(pLatitude, pLongitude);
            airport = LatLng(dLatitude, dLongitude);
          });
          requestLocationPermission();
          getCurrentLocation();
          _startLocationUpdates();
          Get.off(() => GoogleMapScreen1(
                dLatitude: dLatitude,
                dLongitude: dLongitude,
                pLatitude: pLatitude,
                pLongitude: pLongitude,
                tripData: widget.tripData,
                tripStatus: tripStatus.toString(),
              ));
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: data['message'].toString());
        } else {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: data['message'].toString());
        }
      });
    });
  }

  // 1

  endTrip(jsonBody) async {
    log('jsonBody is ------>$jsonBody');
    setState(() {
      var body = jsonBody;
      log('body is ------>$body');
      ApiService.post('startAndEndTrip', body).then((success) {
        log('status code is ${success.statusCode}');
        var data = jsonDecode(success.body);
        log('response is $data');
        if (success.statusCode == 200) {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: data['message'].toString());
          Get.offAll(() => const BottomTile());
        } else {
          Get.rawSnackbar(
              snackPosition: SnackPosition.TOP,
              message: data['message'].toString());
        }
      });
    });
  }
}
