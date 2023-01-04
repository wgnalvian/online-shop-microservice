import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:olshop/app/controllers/user_controller.dart';
import 'package:olshop/app/models/product_model.dart';
import 'package:olshop/app/utils/constant.dart';

class ProductController extends GetxController {
  RxList listProducts = [].obs;
  final userC = Get.find<UserController>();

  Future<Product> getProductById(String id) async {
    String url = "${Constant.API}/api/product/$id";
    try {
      final response = await http.get(Uri.parse(url));
      final responseBody = jsonDecode(response.body);
      return Product(
          id: responseBody["id"].toString(),
          name: responseBody["name"],
          price: responseBody["price"],
          description: responseBody["description"],
          image: []);
    } catch (error) {
      throw error;
    }
  }

  Future<RxList> getProducts() async {
    final loveCollection = await FirebaseFirestore.instance.collection('love');
    try {
      String url = "${Constant.API}/api/products";
      final response = await http.get(Uri.parse(url));

      final responseBody = jsonDecode(response.body);
      for (var element in responseBody) {
        List images = [];
        for (var image in element["image"]) {
          images.add(image["image"]);
        }

        listProducts.add(Product(
            id: element['id'].toString(),
            name: element['name'],
            price: element['price'],
            description: element['description'],
            image: images));
      }

      final dataLove = await loveCollection
          .where('userId', isEqualTo: userC.userId.value)
          .get();



      if (dataLove.docs.isNotEmpty) {
        print('sini');

        for(int i = 0;i < dataLove.docs.length;i++){
          final index = listProducts
              .indexWhere((element) => element.id == dataLove.docs[i].data()['productId']);
          if (index != -1) {
            listProducts[index].isFavorite = dataLove.docs[i].data()['value'];
          }
        }


      }

      return listProducts;
    } catch (err) {
      throw err;
    }
  }

  Future<String> makeALoveWithProduct(String productId) async {
    final loveCollection = await FirebaseFirestore.instance.collection('love');
    final dataLove = await loveCollection
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userC.userId.value)
        .limit(1)
        .get();

    if (dataLove.docs.isEmpty) {
      loveCollection.add({
        'userId': userC.userId.value,
        'productId': productId,
        'value': true,
      });
    } else {
      loveCollection.doc(dataLove.docs.first.id).update({
        'productId': productId,
        'userId': userC.userId.value,
        'value': !dataLove.docs.first.data()['value']
      });
    }
    return '';
  }
}
