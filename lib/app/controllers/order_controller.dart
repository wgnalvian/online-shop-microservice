import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:olshop/app/controllers/user_controller.dart';
import 'package:olshop/app/models/product_model.dart';
import 'package:olshop/app/routes/app_pages.dart';
import "package:http/http.dart" as http;
import 'package:olshop/app/utils/constant.dart';

class OrderController extends GetxController {
  final userC = Get.find<UserController>();
  var isLoading = false.obs;

  Future<String> getTransactionStatus(String orderId) async {
    final body = {"orderId": orderId};

    final bodyEncode = jsonEncode(body);
    String url = "${Constant.API_PAY}/va/status";
    try {
      final response = await http.post(Uri.parse(url), body: bodyEncode);
      Map<String, dynamic> responseDecode = jsonDecode(response.body);

      return responseDecode["transaction_status"];
    } catch (err) {
      return "";
    }
  }

  String getVaNumber(QueryDocumentSnapshot<Map<String, dynamic>> orderDetail) {
    switch (orderDetail["payment_method"]) {
      case "PERMATA":
        return orderDetail["bank_transfer_detail"]["permata_va_number"]
            .toString();
      case "BNI":
        return orderDetail["bank_transfer_detail"]["va_numbers"][0]["va_number"]
            .toString();
      case "BCA":
        return orderDetail["bank_transfer_detail"]["va_numbers"][0]["va_number"]
            .toString();
      default:
        return "";
    }
  }

  void makeOrder(
      String paymentMethod,
      Product product,
      String name,
      String address,
      Map position,
      String ongkir,
      String amount,
      String telepon) async {
    try {
      isLoading.value = true;
      final firestore = FirebaseFirestore.instance.collection("orders");

      if (paymentMethod != "COD") {
        String url = Constant.API_PAY + "/va/charge";

        final body = {
          "channel": paymentMethod,
          "items": [
            {
              "id": "item1",
              "price": double.parse(product.price),
              "ongkir": double.parse(ongkir),
              "quantity": double.parse(amount),
              "product_details": product.toMap()
            }
          ],
          "costumer": {
            "first_name": name,
            "last_name": "",
            "email": userC.email.value,
            "phone": telepon
          }
        };

        final bodyEncode = jsonEncode(body);

        final response = await http.post(Uri.parse(url), body: bodyEncode);

        final responseDecode = jsonDecode(response.body);
        await firestore.add({
          "product": product.toMap(),
          "name": name,
          "payment_method": paymentMethod,
          "payment_type": "bank_transfer",
          "bank_transfer_detail": responseDecode,
          "address": address,
          "position": position,
          "telepon": telepon,
          "userId": userC.userId.value,
          "ongkir": ongkir,
          "amount": amount,
          "created": DateTime.now().toIso8601String()
        });
      } else {
        await firestore.add({
          "product": product.toMap(),
          "name": name,
          "address": address,
          "telepon": telepon,
          "payment_method": 'COD',
          "payment_type": "COD",
          "position": position,
          "userId": userC.userId.value,
          "ongkir": ongkir,
          "amount": amount,
          "created": DateTime.now().toIso8601String()
        });
      }
      isLoading.value = false;
      Get.offNamed(Routes.ORDER);
    } catch (err) {
      isLoading.value = false;
      throw err;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userC.userId.value)
        .snapshots();
  }
}
