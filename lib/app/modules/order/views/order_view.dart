import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:olshop/app/modules/order/widgets/bottom_sheet.dart';
import 'package:olshop/app/routes/app_pages.dart';

import '../../../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final orderC = Get.find<OrderController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF03071E),
          title: const Text('Pesanan'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.offNamed(Routes.HOME);
                },
                icon: Icon(Icons.home))
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: orderC.getOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Material(
                  color: Color(0xFF03071E),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Get.bottomSheet(BottomSheetWidget(
                            order: snapshot.data!.docs[index],
                          ));
                        },
                        leading: SizedBox(
                          height: 15,
                          child: Image.asset(
                            "asset/image/${snapshot.data!.docs[index]['payment_method'].toString().toLowerCase()}.png",
                            alignment: Alignment.center,
                          ),
                        ),
                        title: Text(
                          snapshot.data!.docs[index].id,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF5FF00)),
                        ),
                        subtitle: Text(
                          snapshot.data!.docs[index]["product"]["name"],
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          DateFormat.yMMMMEEEEd()
                              .format(DateTime.parse(
                                  snapshot.data!.docs[index]["created"]))
                              .toString(),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      );
                    },
                  ),
                );
              }

              return Center(
                child: Lottie.asset("asset/lottie/loading.json",
                    width: Get.width * 0.8, height: Get.height * 0.5),
              );
            }));
  }
}
