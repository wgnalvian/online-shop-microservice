import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as LocationP;
import 'package:olshop/app/utils/correct_lang.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:restart_app/restart_app.dart';

class CourierTrackingController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var isGetUserLocation = false.obs;
  final ValueNotifier<bool> isCollapse = ValueNotifier(false);
  var idSelected = "".obs;
  RxMap selected = {}.obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> getTriggres() {
    final triggres = firestore
        .collection('triggers')
        .where("orderId", isEqualTo: Get.arguments);

    return triggres.snapshots();
  }

  void changeIsCollapse() {
    isCollapse.value = !isCollapse.value;
  }

  double getDistance(Map selected) {
    if (selected.isNotEmpty) {
      return (Geolocator.distanceBetween(selected['plat'], selected['plng'],
              selected["lat"], selected["lng"]) /
          1000);
    } else {
      return 0;
    }
  }

  Future<String> getLocation(Map selected) async {
    if (selected.isNotEmpty) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(selected["lat"], selected["lng"]);
        Placemark place = placemarks[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      } catch (err) {
        print(err.toString());
        return "Lokasi tidak diketahui";
      }
    } else {
      return "Lokasi tidak diketahui";
    }
  }

  @override
  void onInit() async {
    late final PausableTimer timer;
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          await Get.defaultDialog(
              title: 'Permission Location is needed',
              middleText: 'Please allow this application to know your location',
              textCancel: "Restart App",
              onCancel: () {
                Restart.restartApp();
              });
        }
      }

      LocationP.Location location = LocationP.Location();

      var _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      var _permissionGranted = await location.hasPermission();
      if (_permissionGranted == LocationP.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != LocationP.PermissionStatus.granted) {
          return;
        }
      }
      location.onLocationChanged
          .listen((LocationP.LocationData currentLocation) {
        lat.value = correctLatLng(currentLocation.latitude ?? 0);
        lng.value = correctLatLng(currentLocation.longitude ?? 0);
        isGetUserLocation.value = true;
      });

      //   timer = PausableTimer(const Duration(milliseconds: 500), () async {
      //     bool servicestatus = await Geolocator.isLocationServiceEnabled();
      //     if (servicestatus) {
      //       timer
      //         ..reset()
      //         ..start();

      //       Position position = await Geolocator.getCurrentPosition(
      //           desiredAccuracy: LocationAccuracy.high);

      //       isGetUserLocation.value = true;
      //     } else {
      //       timer.pause();
      //       await Get.defaultDialog(
      //           barrierDismissible: false,
      //           title: 'GPS is Off',
      //           backgroundColor: Colors.white,
      //           textConfirm: 'Go to GPS setting',
      //           onConfirm: () {
      //             AppSettings.openLocationSettings();
      //           },
      //           onCancel: () {
      //             timer
      //               ..reset()
      //               ..start();
      //           },
      //           textCancel: "Okey i know",
      //           buttonColor: Colors.blue,
      //           middleText: 'Please trun on a GPS');
      //     }
      //   })
      //     ..start();
    } catch (e) {
      await Get.defaultDialog(
          barrierDismissible: false,
          title: 'Error',
          textConfirm: 'Close App',
          confirmTextColor: Colors.white,
          onConfirm: () {
            SystemNavigator.pop();
          },
          buttonColor: Colors.blue,
          middleText: 'Your device cannot running this app');
    }

    super.onInit();
  }
}
