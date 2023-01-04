import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:olshop/app/routes/app_pages.dart';
import 'package:olshop/app/utils/correct_lang.dart';

import '../controllers/location_detail_controller.dart';

class LocationDetailView extends GetView<LocationDetailController> {
  const LocationDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final detailC = Get.find<LocationDetailController>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offNamed(Routes.COURIER_TRACKING);
        },
        child: Icon(Icons.home),
      ),
      body: Stack(children: [
        FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Image(
            image: AssetImage("asset/image/bg.jpg"),
          ),
        ),
        Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(200)),
          ),
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: detailC.getTrigger(),
            builder: (context, snapshot) {
              if (snapshot.data != null &&
                  !snapshot.data!.data().toString().contains("name")) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => Get.offAllNamed(Routes.HOME));
              }
              if (snapshot.connectionState == ConnectionState.active) {
                return Obx(() {
                  if (detailC.isGetUserLocation.value == true &&
                      snapshot.data!.data().toString().contains("name")) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snapshot.data!['name'],
                            style: TextStyle(color: Colors.black, fontSize: 50),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.airline_stops,
                                size: 50,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                detailC.getDistance(
                                    correctLatLng(double.parse(
                                        snapshot.data!["position"]["lat"])),
                                    correctLatLng(double.parse(
                                        snapshot.data!['position']['lng'])),
                                    {
                                      "lat": correctLatLng(
                                          double.parse(snapshot.data!["lat"])),
                                      "lng": correctLatLng(
                                          double.parse(snapshot.data!["lng"]))
                                    })[0].toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 50),
                              ),
                              Text(
                                "KM",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 50,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                detailC.getDistance(
                                    correctLatLng(double.parse(
                                        snapshot.data!["position"]["lat"])),
                                    correctLatLng(double.parse(
                                        snapshot.data!['position']['lng'])),
                                    {
                                      "lat": correctLatLng(
                                          double.parse(snapshot.data!["lat"])),
                                      "lng": correctLatLng(
                                          double.parse(snapshot.data!["lng"]))
                                    })[1].toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 50),
                              ),
                              Text(
                                "Minutes",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ]),
    );
  }
}
