import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:olshop/app/utils/correct_lang.dart';
import 'package:pausable_timer/pausable_timer.dart';

class LocationDetailController extends GetxController {
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var isGetUserLocation = false.obs;
  late var idSelected;
  Stream<DocumentSnapshot<Map<String, dynamic>>> getTrigger() {
    DocumentReference<Map<String, dynamic>> triggres =
        FirebaseFirestore.instance.collection('triggers').doc(idSelected);
    return triggres.snapshots();
  }

  List getDistance(double plat, double plng, Map selected) {
    if (selected.isNotEmpty) {
      double distance = (Geolocator.distanceBetween(
              plat, plng, selected["lat"], selected["lng"]) /
          1000);

      double averageTime = distance * 1 / 40 * 60;
      return [distance, averageTime];
    } else {
      return [];
    }
  }

  @override
  void onInit() async {
    idSelected = Get.arguments;
    late final PausableTimer timer;
    try {
      timer = PausableTimer(const Duration(seconds: 1), () async {
        bool servicestatus = await Geolocator.isLocationServiceEnabled();
        if (servicestatus) {
          timer
            ..reset()
            ..start();

          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          lat.value = position.latitude;
          lng.value = position.longitude;
          isGetUserLocation.value = true;
        } else {
          timer.pause();
          await Get.defaultDialog(
              barrierDismissible: false,
              title: 'GPS is Off',
              backgroundColor: Colors.white,
              textConfirm: 'Go to GPS setting',
              onConfirm: () {
                AppSettings.openLocationSettings();
              },
              onCancel: () {
                timer
                  ..reset()
                  ..start();
              },
              textCancel: "Okey i know",
              buttonColor: Colors.blue,
              middleText: 'Please trun on a GPS');
        }
      })
        ..start();
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

    print(idSelected);
    super.onInit();
  }
}
