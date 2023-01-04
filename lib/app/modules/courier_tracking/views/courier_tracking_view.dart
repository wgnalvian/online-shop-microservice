import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:olshop/app/routes/app_pages.dart';
import 'package:olshop/app/utils/constant.dart';
import 'package:olshop/app/utils/correct_lang.dart';

import '../controllers/courier_tracking_controller.dart';

class CourierTrackingView extends GetView<CourierTrackingController> {
  const CourierTrackingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final thisC = Get.find<CourierTrackingController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF03071E),
        title: const Text('Courier Tracking'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.offNamed(Routes.ORDER);
              },
              icon: Icon(Icons.shopping_bag))
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.getTriggres(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data != null) {
            return Stack(
              children: [
                Obx(() {
                  List<Marker> listMarker = [];
                  if (snapshot.data!.docs.isNotEmpty) {
                    for (var element in snapshot.data!.docs) {
                      if (element.data().containsKey("lat")) {
                        listMarker.add(
                          Marker(
                              point: LatLng(
                                  correctLatLng(double.parse(element['lat'])),
                                  correctLatLng(double.parse(element['lng']))),
                              builder: (context) => GestureDetector(
                                    onTap: () {
                                      controller.isCollapse.value =
                                          !controller.isCollapse.value;
                                      if (controller.isCollapse.value) {
                                        controller.selected.value = {
                                          "lat": correctLatLng(
                                              double.parse(element['lat'])),
                                          "lng": correctLatLng(
                                              double.parse(element['lng'])),
                                          "plat": correctLatLng(double.parse(
                                              element['position']['lat'])),
                                          "plng": correctLatLng(double.parse(
                                              element['position']['lng'])),
                                          "name": element["name"]
                                        };

                                        controller.idSelected.value =
                                            element.id;
                                      } else {
                                        controller.selected.value = {};
                                      }
                                    },
                                    child: const Image(
                                      image: AssetImage('asset/image/bis.png'),
                                    ),
                                  )),
                        );
                        listMarker.add(
                          Marker(
                              point: LatLng(
                                  correctLatLng(
                                      double.parse(element['position']['lat'])),
                                  correctLatLng(double.parse(
                                      element['position']['lng']))),
                              builder: (context) => GestureDetector(
                                    onTap: () {
                                      controller.isCollapse.value =
                                          !controller.isCollapse.value;
                                      if (controller.isCollapse.value) {
                                        controller.selected.value = {
                                          "lat": correctLatLng(
                                              double.parse(element['lat'])),
                                          "lng": correctLatLng(
                                              double.parse(element['lng'])),
                                          "plat": correctLatLng(double.parse(
                                              element['position']['lat'])),
                                          "plng": correctLatLng(double.parse(
                                              element['position']['lng'])),
                                          "name": element["name"]
                                        };

                                        controller.idSelected.value =
                                            element.id;
                                      } else {
                                        controller.selected.value = {};
                                      }
                                    },
                                    child: const Image(
                                      image:
                                          AssetImage('asset/image/target.png'),
                                    ),
                                  )),
                        );
                      }
                    }
                  }

                  List<Marker> getListTriger() {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return snapshot.data!.docs.map((e) {
                        if (e.data().toString().contains("lat")) {
                          return Marker(
                              point: LatLng(
                                  correctLatLng(double.parse(e['lat'])),
                                  correctLatLng(double.parse(e['lng']))),
                              builder: (context) => GestureDetector(
                                    onTap: () {
                                      controller.isCollapse.value =
                                          !controller.isCollapse.value;
                                      if (controller.isCollapse.value) {
                                        controller.selected.value = {
                                          "lat": correctLatLng(
                                              double.parse(e['lat'])),
                                          "lng": correctLatLng(
                                              double.parse(e['lng'])),
                                          "plat": correctLatLng(double.parse(
                                              e['position']['lat'])),
                                          "plng": correctLatLng(double.parse(
                                              e['position']['lng'])),
                                        };

                                        controller.idSelected.value = e.id;
                                      } else {
                                        controller.selected.value = {};
                                      }
                                    },
                                    child: const Image(
                                      image: AssetImage('asset/image/bis.png'),
                                    ),
                                  ));
                        } else {
                          return Marker(
                            point: LatLng(0.0000, 0.00000),
                            builder: (context) {
                              return Container();
                            },
                          );
                        }
                      }).toList();
                    } else {
                      return [];
                    }
                  }

                  return thisC.isGetUserLocation.value
                      ? FlutterMap(
                          options: MapOptions(
                            onTap: ((tapPosition, point) {
                              controller.isCollapse.value = false;
                              controller.selected.value = {};
                            }),
                            minZoom: 5,
                            maxZoom: 18,
                            zoom: 13,
                            center: LatLng(
                                controller.lat.value, controller.lng.value),
                          ),
                          layers: [
                            TileLayerOptions(
                                fastReplace: true,
                                errorTileCallback: (tile, error) async {},
                                urlTemplate:
                                    "https://api.mapbox.com/styles/v1/wgnalvian/${Constant.styleId}/tiles/256/{z}/{x}/{y}@2x?access_token=${Constant.accessToken}",
                                additionalOptions: {
                                  'mapStyleId': Constant.styleId,
                                  'accessToken': Constant.accessToken
                                }),
                            MarkerLayerOptions(markers: [
                              Marker(
                                  point: LatLng(controller.lat.value,
                                      controller.lng.value),
                                  builder: (context) => const Image(
                                        image: AssetImage(
                                            'asset/image/location.png'),
                                      )),
                              ...listMarker
                            ])
                          ],
                        )
                      : Center(
                          child: lottie.Lottie.asset(
                              "asset/lottie/loading.json",
                              width: Get.width * 0.8,
                              height: Get.height * 0.5),
                        );
                }),
                ValueListenableBuilder<bool>(
                  valueListenable: controller.isCollapse,
                  builder: (context, val, _) => AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    left: 0,
                    right: 0,
                    bottom: val ? 20 : -150,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        width: 250,
                        height: 110,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(25, 12, 20, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                "${controller.selected.value["name"]} ( ${controller.getDistance(controller.selected.value).toStringAsFixed(2)} KM )",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              FutureBuilder<String>(
                                  future: controller
                                      .getLocation(controller.selected.value),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Text(
                                        snapshot.data!,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 25,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.LOCATION_DETAIL,
                                        arguments: controller.idSelected.value);
                                    Get.delete<CourierTrackingController>();
                                  },
                                  child: Text("Detail"),
                                  style: ElevatedButton.styleFrom(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: lottie.Lottie.asset("asset/lottie/loading.json",
                  width: Get.width * 0.8, height: Get.height * 0.5),
            );
          }
        },
      ),
    );
  }
}
