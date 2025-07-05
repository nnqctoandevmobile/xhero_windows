// // ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:xhero_windows_app/utils/logic/xhero_common_logics.dart';

// import '../../../constants/colors.dart';
// import '../../../shared/multi_appear_widgets/show_popup_permission_handle.dart';


// class LocationPage extends StatefulWidget {
//   @override
//   _LocationPageState createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   @override
//   void initState() {
//     super.initState();
//     _checkPermissionAndGetLocation();
//   }

//   Future<void> _checkPermissionAndGetLocation() async {
//     if (await _handleLocationPermission()) {
//       await _getCurrentLocation();
//     } else {
//       if (mounted) {
//         showPopuppermissinHandle(
//             context: context,
//             icon: Icons.wrong_location_rounded,
//             title: 'locationPermissionDenied'.tr,
//             content: 'locationPermissionContent'.tr,
//             permission: Permission.location);
//       }
//     }
//   }

//   Future<bool> _handleLocationPermission() async {
//     var status = await Permission.location.status;
//     if (status.isDenied) {
//       status = await Permission.location.request();
//     }

//     if (status.isGranted) {
//       return true;
//     } else if (status.isPermanentlyDenied ||
//         status.isRestricted ||
//         status.isLimited) {
//       setState(() {
//         address = "location_access_denied".tr;
//       });
//       return false;
//     }
//     return false; // If permission is denied or not granted, return false
//   }

//   String address = '';

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       await _getAddressFromLatLng(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         address = "${'unable_to_get_location'.tr}: $e";
//       });
//     }
//   }

//   Future<String> _getAddressFromLatLng(double lat, double long) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

//       if (placemarks.isNotEmpty) {
//         // Concatenate non-null components of the address
//         var streets = placemarks.reversed
//             .map((placemark) => placemark.street)
//             .where((street) => street != null);

//         // Filter out unwanted parts
//         streets = streets.where((street) =>
//             street!.toLowerCase() !=
//             placemarks.reversed.last.locality!
//                 .toLowerCase()); // Remove city names
//         streets = streets
//             .where((street) => !street!.contains('+')); // Remove street codes

//         address += streets.join(', ');

//         address += ', ${placemarks.reversed.last.subLocality ?? ''}';
//         address += ', ${placemarks.reversed.last.locality ?? ''}';
//         address += ', ${placemarks.reversed.last.administrativeArea ?? ''}';
//         address += ', ${placemarks.reversed.last.postalCode ?? ''}';
//         address += placemarks.reversed.last.country ?? '';
//         setState(() {});
//       }

//       printConsole("Your Address for ($lat, $long) is: $address");

//       return address;
//     } catch (e) {
//       printConsole("Error getting placemarks: $e");
//       return "No Address";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('my_location'.tr),
//       ),
//       body: Center(
//         child: Text(
//           address,
//           style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: AppColor.primaryColor),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
