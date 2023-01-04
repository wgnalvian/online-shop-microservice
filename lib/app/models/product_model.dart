// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  String price;
  String description;
  List image;
  bool isFavorite = false;
  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.image});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, description: $description, image: $image)';
  }
}
