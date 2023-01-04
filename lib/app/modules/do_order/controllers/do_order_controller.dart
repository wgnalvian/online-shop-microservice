import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:olshop/app/utils/constant.dart';
import 'package:olshop/app/utils/correct_lang.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:restart_app/restart_app.dart';

class DoOrderController extends GetxController {
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var isGetUserLocation = false.obs;
  var isChange = false.obs;
  var inputName = TextEditingController();
  var paymentMethod = "COD".obs;
  var inputAlamat = TextEditingController();
  var inputTelepon = TextEditingController();
  var inputJumlah = TextEditingController();
  var error = {}.obs;

  bool validateInput(String text, String name) {
    if (text == "") {
      error[name] = "Value $name cannot null";
      return false;
    } else if (name == "jumlah" && !GetUtils.isNumericOnly(text)) {
      error[name] = "Value $name must be a number";
      return false;
    } else if (name == "jumlah" && double.parse(inputJumlah.value.text) < 1) {
      error[name] = "Minimal value must be 1";
      return false;
    } else {
      error[name] = "";
      return true;
    }
  }

  double getOngkir() {
    double distance = (Geolocator.distanceBetween(
            correctLatLng(lat.value),
            correctLatLng(lng.value),
            Constant.CENTER_LOCATION[0],
            Constant.CENTER_LOCATION[1]) /
        1000);
    return distance * 20000 / 10;
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
      timer = PausableTimer(const Duration(seconds: 1), () async {
        bool servicestatus = await Geolocator.isLocationServiceEnabled();
        if (servicestatus) {
          timer
            ..reset()
            ..start();
          if (lat.value == 0.0 && lng.value == 0.0) {
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            lat.value = position.latitude;
            lng.value = position.longitude;
            isGetUserLocation.value = true;
          }
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
    super.onInit();
  }
}
