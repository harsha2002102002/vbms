import 'dart:convert';
import 'dart:developer';
import 'package:vbms/views/booking/bookingstatusscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../apiservice/apiservice.dart';

class VehicleBookingController extends GetxController {
  final bookingFormKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> dropdownItems = [
    {'id': 1, 'name': "My Self"},
    {'id': 2, 'name': "Other"},
  ];
  List<dynamic> suggestions = [];
  List<dynamic> dropSuggestions = [];
  // Selected dropdown value
  String? selectedItem;
  String? empName;
  String? userID;
  String? airportRegId;
  String? deptID;
  String? departmentTypeId;
  String? airportId;
  String selectedDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String selectedTime = DateFormat("HH:mm").format(DateTime.now());
  TextEditingController pickUp = TextEditingController();
  TextEditingController dropAt = TextEditingController();
  String? pickupPointLat = "";
  String? pickupPointLon = "";
  String? dropAtLat = "";
  String? dropAtLon = "";
  String bookingID = "";
  bool isLoading = false;
  String? currentPlace;
  String? selectedPlace;
  String? selectedDropPlace;
  GoogleMapController? mapController1;
  TextEditingController controller = TextEditingController();
  TextEditingController dropController = TextEditingController();
  late LatLng currentLocation;
  late LatLng destinationLatLng;
  final String apiKey = 'AIzaSyB4Z7TS_eDUaBfMH_lVq1NCOmrYZceSiwY';
  bool isCurrentLoading = true;
  Set<Marker> mapMarkers = {};
  Set<Polyline> polyLines = {};
  @override
  void onInit() {
    // TODO: implement onInit
    requestLocationPermission();
    currentLocation = const LatLng(0.0, 0.0);
    getCurrentLocation();
    loadLoginData();
    destinationLatLng = const LatLng(0.0, 0.0);
    super.onInit();
  }

  requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If location services are not enabled, ask the user to enable it
      return Future.error('Location services are disabled.');
    }

    // Check the current location permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // If permission is denied, request permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Handle permanent denial of location permission
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // If permission is granted, return the current location
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    }

    // If none of the above, return null
    log('service enabled,$serviceEnabled');

    return null;
  }

  getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Get latitude and longitude
      currentLocation = LatLng(position.latitude, position.longitude);
      log('current location is $currentLocation');
      double latitude = position.latitude;
      double longitude = position.longitude;
      // Reverse geocoding to get address
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;

        // debugPrint('Country: ${place.country}');
        // debugPrint('Locality: ${place.locality}');
        // debugPrint('Postal Code: ${place.postalCode}');
        // debugPrint('Street: ${place.street}');
        // debugPrint('Full Address: ${place.toString()}');
        currentPlace =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
        log('current place is ${currentPlace.toString()}');
        controller.text = currentPlace.toString();
        isCurrentLoading = false;
        update();
      } else {
        debugPrint('No address available for the current location.');
      }
      update();
    } catch (e) {
      debugPrint('Error while getting location details: $e');
    }
  }

  _getDirections(LatLng origin, LatLng destination) async {
    if (mapController1 == null) {
      log('mapController is not initialized yet.');
      return;
    }
    mapMarkers = {};
    polyLines = {};
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

          polyLines.add(Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ));

          mapController1?.animateCamera(
            CameraUpdate.newLatLng(origin),
          );
          update();
        }
        update();
      } else {
        log('Failed to fetch directions: ${response.statusCode}');
      }
      update();
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

  updateRoute() async {
    await _getDirections(currentLocation, destinationLatLng);
    _addMarkers();
    update();
  }

  void _addMarkers() {
    mapMarkers = {
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: destinationLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
    isCurrentLoading = false;
    update();
  }

  Future<void> searchPlaces(String input) async {
    if (input.isEmpty) return;

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final predictions = data['predictions'];

      // setState(() {
      suggestions = predictions;
      // });
      update();
    } else {
      log('Failed to load suggestions');
    }
  }

  Future<void> dropSearchPlaces(String input) async {
    if (input.isEmpty) return;

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final predictions = data['predictions'];

      // setState(() {
      dropSuggestions = predictions;
      // });
      update();
    } else {
      log('Failed to load suggestions');
    }
  }

  void handleDropdown(newValue) {
    selectedItem = newValue.toString();
    update();
  }

  loadLoginData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    log("LoadingData");
    userID = pref.getString("userID").toString();
    airportRegId = pref.getString("airportRegId").toString();
    deptID = pref.getString("deptID").toString();
    empName = '${pref.getString('firstName')} ${pref.getString('lastName')}';
    departmentTypeId = pref.getString("departmentTypeId").toString();
    airportId = pref.getString("airportId").toString();

    log("EMPID $empName");
    update();
  }

  handleDate(BuildContext context) async {
    log("Clicked on Date");
    DateTime date = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ))!;
    if (date != null) {
      //if the user has selected a date
      selectedDate = DateFormat('dd-MM-yyyy').format(date);
      log(selectedDate.toString());
      update();
    } else {
      selectedDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
      update();
    }
    update();
  }

  handleTime(BuildContext context) async {
    var time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      selectedTime = "${time.hour}:${time.minute}";
      log(selectedTime.toString());
      log("selectedTime");
      update();
    }
    update();
  }

  updatePickupCoordinates() async {
    isCurrentLoading = true;
    String pickupLocation = controller.text.toString().trim();
    debugPrint("PickUp $pickupLocation");
    const String apiKey = 'AIzaSyB4Z7TS_eDUaBfMH_lVq1NCOmrYZceSiwY';
    final encodedLocation = Uri.encodeComponent(pickupLocation);
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$encodedLocation&inputtype=textquery&fields=geometry&key=$apiKey');
    // final url = Uri.parse(
    //     'https://nominatim.openstreetmap.org/search?q=$pickupLocation&format=json&addressdetails=1&limit=1');
    // final responseP = await http.get(url);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          // Extract latitude and longitude
          pickupPointLat =
              data['candidates'][0]['geometry']['location']['lat'].toString();
          pickupPointLon =
              data['candidates'][0]['geometry']['location']['lng'].toString();

          debugPrint("Pickup Latitude: $pickupPointLat");
          debugPrint("Pickup Longitude: $pickupPointLon");
          currentLocation = LatLng(double.parse(pickupPointLat.toString()),
              double.parse(pickupPointLon.toString()));
          update(); // Update your state if necessary
        } else {
          debugPrint("No location found for: $pickupLocation");
        }
        update();
      } else {
        debugPrint("Error fetching data: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
    // updateDropAtCoordinates();
    updateRoute();
    update();
  }

  updateDropAtCoordinates() async {
    isCurrentLoading = true;
    String dropAtLocation = dropController.text.toString().trim();
    debugPrint("DropAt: $dropAtLocation");

    // Replace 'YOUR_GOOGLE_MAPS_API_KEY' with your actual API key.
    const String apiKey = 'AIzaSyB4Z7TS_eDUaBfMH_lVq1NCOmrYZceSiwY';

    // Encode location for URL safety
    final encodedLocation = Uri.encodeComponent(dropAtLocation);

    // Define Places API endpoint
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$encodedLocation&inputtype=textquery&fields=geometry&key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          // Extract latitude and longitude
          dropAtLat =
              data['candidates'][0]['geometry']['location']['lat'].toString();
          dropAtLon =
              data['candidates'][0]['geometry']['location']['lng'].toString();

          debugPrint("DropAt Latitude: $dropAtLat");
          debugPrint("DropAt Longitude: $dropAtLon");
          destinationLatLng = LatLng(double.parse(dropAtLat.toString()),
              double.parse(dropAtLon.toString()));
          log('destination latlng is $destinationLatLng');
          update(); // Update your state if necessary
        } else {
          debugPrint("No location found for: $dropAtLocation");
        }
        update();
      } else {
        debugPrint("Error fetching data: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
    // handleBooking();
    updateRoute();
    update();
  }

  handleBooking() async {
    isLoading = true;
    Map<String, dynamic> bodyMap = {
      "airportRegId": airportRegId,
      "departmentId": deptID,
      "airportId": airportId,
      "departmentTypeId": departmentTypeId,
      "BookingFor": empName,
      "date": selectedDate,
      "time": selectedTime,
      "pickUp": controller.text.toString(),
      "dropAt": dropController.text.toString(),
      "pickupLatitude": pickupPointLat.toString(),
      "pickupLongitude": pickupPointLon.toString(),
      "dropAtLatitude": dropAtLat,
      "dropAtLongitude": dropAtLon,
      "isActive": 'true',
      "status": 'Booking'
    };

    String body = jsonEncode(bodyMap);

    if (kDebugMode) {
      print("Body123 : $body");
    }

    ApiService.post('saveAndUpdatevehicleBooking', body).then((success) {
      log('status code is ${success.statusCode}');
      var data = jsonDecode(success.body);
      log('response is $data');
      if (success.statusCode == 200) {
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        isLoading = false;
        Get.to(() => const BookingStatusScreen(), arguments: data['data']);
        update();
      } else {
        isLoading = false;
        Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: data['message'].toString());
        update();
      }
    });
    update();
  }

  clearFieldsData(type) {
    log('type is $type');
    if (type == "pickup") {
      controller.clear();
      update();
    } else if (type == "dropat") {
      dropController.clear();
      update();
    }
    update();
  }


}
