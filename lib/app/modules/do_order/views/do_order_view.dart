import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:olshop/app/controllers/order_controller.dart';
import 'package:olshop/app/controllers/product_controller.dart';
import 'package:olshop/app/models/product_model.dart';
import 'package:olshop/app/routes/app_pages.dart';
import 'package:olshop/app/utils/constant.dart';
import 'package:flutter_map/src/layer/marker_layer.dart' as marker;
import 'package:olshop/app/utils/number_format.dart';
import 'package:smart_select/smart_select.dart';

import '../controllers/do_order_controller.dart';

class DoOrderView extends GetView<DoOrderController> {
  const DoOrderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final param = Get.arguments;
    final productC = Get.find<ProductController>();
    final doOrderC = Get.find<DoOrderController>();
    final orderC = Get.find<OrderController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF03071E),
          title: const Text('Lengkapi Detail Pesanan'),
          centerTitle: true,
        ),
        body: FutureBuilder<Product>(
            future: productC.getProductById(param),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Obx(() {
                  if (doOrderC.isGetUserLocation.value) {
                    return Material(
                      color: Color(0xFF03071E),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                  onChanged: (value) {
                                    doOrderC.isChange.value = true;
                                    doOrderC.validateInput(
                                        doOrderC.inputName.value.text, "name");
                                  },
                                  controller: doOrderC.inputName,
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.pink)),
                                    errorStyle: TextStyle(color: Colors.pink),
                                    fillColor: Color(0xFFF5FF00),
                                    filled: true,
                                    errorText: doOrderC.isChange.value &&
                                            doOrderC.error
                                                .containsKey("name") &&
                                            doOrderC.error["name"] != ""
                                        ? doOrderC.error["name"]
                                        : null,
                                    prefixIcon: Icon(
                                        Icons.supervised_user_circle_sharp),
                                    label: Text("Name"),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                            style: BorderStyle.solid)),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                  onChanged: (value) {
                                    doOrderC.isChange.value = true;
                                    doOrderC.validateInput(
                                        doOrderC.inputAlamat.value.text,
                                        "alamat");
                                  },
                                  controller: doOrderC.inputAlamat,
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.pink)),
                                    errorStyle: TextStyle(color: Colors.pink),
                                    fillColor: Color(0xFFF5FF00),
                                    filled: true,
                                    errorText: doOrderC.isChange.value &&
                                            doOrderC.error
                                                .containsKey("alamat") &&
                                            doOrderC.error["alamat"] != ""
                                        ? doOrderC.error["alamat"]
                                        : null,
                                    prefixIcon: Icon(
                                        Icons.not_listed_location_outlined),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                    label: Text("Alamat"),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                            style: BorderStyle.solid)),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                  onChanged: (value) {
                                    doOrderC.isChange.value = true;
                                    doOrderC.validateInput(
                                        doOrderC.inputTelepon.value.text,
                                        "telepon");
                                  },
                                  keyboardType: TextInputType.phone,
                                  controller: doOrderC.inputTelepon,
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.pink)),
                                    errorStyle: TextStyle(color: Colors.pink),
                                    fillColor: Color(0xFFF5FF00),
                                    filled: true,
                                    errorText: doOrderC.isChange.value &&
                                            doOrderC.error
                                                .containsKey("telepon") &&
                                            doOrderC.error["telepon"] != ""
                                        ? doOrderC.error["telepon"]
                                        : null,
                                    prefixIcon: Icon(Icons.phone),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                    label: Text("Telepon"),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                            style: BorderStyle.solid)),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                  onChanged: (value) {
                                    doOrderC.isChange.value = true;
                                    doOrderC.validateInput(
                                        doOrderC.inputJumlah.value.text,
                                        "jumlah");
                                  },
                                  controller: doOrderC.inputJumlah,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.pink)),
                                    errorStyle: TextStyle(color: Colors.pink),
                                    fillColor: Color(0xFFF5FF00),
                                    filled: true,
                                    errorText: doOrderC.isChange.value &&
                                            doOrderC.error
                                                .containsKey("jumlah") &&
                                            doOrderC.error["jumlah"] != ""
                                        ? doOrderC.error["jumlah"]
                                        : null,
                                    prefixIcon: Icon(Icons.numbers),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                    label: Text("Jumlah"),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                            style: BorderStyle.solid)),
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 50,
                                child: Wrap(children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  Text(
                                    "Tentukan titik antar barang dengan benar.",
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    " Jarak titik antar barang dengan toko mempengaruhi biaya ongkir",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ]),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                width: Get.width,
                                height: 200,
                                child: FlutterMap(
                                  options: MapOptions(
                                    onTap: (tapPosition, point) {
                                      doOrderC.lat.value = point.latitude;
                                      doOrderC.lng.value = point.longitude;
                                    },
                                    minZoom: 5,
                                    maxZoom: 18,
                                    zoom: 10,
                                    center: LatLng(
                                        doOrderC.lat.value, doOrderC.lng.value),
                                  ),
                                  layers: [
                                    TileLayerOptions(
                                        fastReplace: true,
                                        urlTemplate:
                                            "https://api.mapbox.com/styles/v1/wgnalvian/${Constant.styleId}/tiles/256/{z}/{x}/{y}@2x?access_token=${Constant.accessToken}",
                                        additionalOptions: {
                                          'mapStyleId': Constant.styleId,
                                          'accessToken': Constant.accessToken
                                        }),
                                    MarkerLayerOptions(markers: [
                                      marker.Marker(
                                          point: LatLng(doOrderC.lat.value,
                                              doOrderC.lng.value),
                                          builder: (context) => const Image(
                                                image: AssetImage(
                                                    'asset/image/location.png'),
                                              )),
                                      marker.Marker(
                                          point: LatLng(
                                              Constant.CENTER_LOCATION[0],
                                              Constant.CENTER_LOCATION[1]),
                                          builder: (context) => const Image(
                                                image: AssetImage(
                                                    'asset/image/toko.png'),
                                              ))
                                    ])
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Barang",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      " : ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.yellow,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Harga",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      " : ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "${convertToIdr(snapshot.data!.price, 2)}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.yellow,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ongkir",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      " : ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "${convertToIdr(doOrderC.getOngkir().toStringAsFixed(0), 2)}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.yellow,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: SmartSelect<String>.single(
                                    tileBuilder: (context, value) => S2Tile(
                                        value: value.value,
                                        onTap: () {
                                          value.showModal();
                                        },
                                        title: Text(
                                          "Payment Method",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    title: 'Payment Method',
                                    choiceItems: [
                                      S2Choice<String>(
                                          selected: true,
                                          value: 'COD',
                                          title: 'COD'),
                                      S2Choice<String>(
                                          value: 'BCA', title: 'BCA'),
                                      S2Choice<String>(
                                          value: 'BNI', title: 'BNI'),
                                      S2Choice<String>(
                                          value: 'PERMATA', title: 'Permata'),
                                    ],
                                    value: doOrderC.paymentMethod.value,
                                    onChange: (value) {
                                      doOrderC.paymentMethod.value =
                                          value.value;
                                    }),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.yellow,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      " : ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "${convertToIdr((doOrderC.getOngkir() + (double.parse(snapshot.data!.price) * (doOrderC.inputJumlah.value.text == "" ? 1 : double.parse(doOrderC.inputJumlah.value.text)))).toStringAsFixed(0), 2)}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (doOrderC.validateInput(
                                              doOrderC.inputName.text,
                                              "name") &&
                                          doOrderC.validateInput(
                                              doOrderC.inputAlamat.text,
                                              "alamat") &&
                                          doOrderC.validateInput(
                                              doOrderC.inputJumlah.text,
                                              "jumlah")) {
                                        orderC.makeOrder(
                                            doOrderC.paymentMethod.value,
                                            snapshot.data!,
                                            doOrderC.inputName.text,
                                            doOrderC.inputAlamat.text,
                                            {
                                              "lat":
                                                  doOrderC.lat.value.toString(),
                                              "lng":
                                                  doOrderC.lng.value.toString()
                                            },
                                            doOrderC
                                                .getOngkir()
                                                .toStringAsFixed(0),
                                            doOrderC.inputJumlah.value.text,
                                            doOrderC.inputTelepon.value.text);
                                      }
                                    },
                                    child: orderC.isLoading.value
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text("Pesan Sekarang")),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    onPressed: () {
                                      Get.offNamed(Routes.HOME);
                                    },
                                    child: Text("Batal")),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Lottie.asset("asset/lottie/loading.json",
                          width: Get.width * 0.8, height: Get.height * 0.5),
                    );
                  }
                });
              } else {
                return Center(
                  child: Lottie.asset("asset/lottie/loading.json",
                      width: Get.width * 0.8, height: Get.height * 0.5),
                );
              }
            }));
  }
}
