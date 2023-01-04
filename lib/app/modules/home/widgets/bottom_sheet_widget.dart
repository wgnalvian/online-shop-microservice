import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:olshop/app/controllers/product_controller.dart';
import 'package:olshop/app/models/product_model.dart';
import 'package:olshop/app/routes/app_pages.dart';
import 'package:olshop/app/utils/constant.dart';
import 'package:olshop/app/utils/number_format.dart';

class BottomSheetWidget extends StatelessWidget {
  Product product;
  BottomSheetWidget({Key? key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF03071E),
      child: SingleChildScrollView(
        // physics: ClampingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 50,
            color: Color(0xFF03071E),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                product.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFFF5FF00)),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          InteractiveViewer(
            child: Material(
              color: Colors.white,
              child: Center(
                child: SizedBox(
                  height: 150,
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 5,
                      );
                    },
                    itemCount: product.image.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          height: 150,
                          child: Image.network(
                              "${Constant.API}/images/${product.image[index]}"));
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Harga",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  "${convertToIdr(product.price, 2)}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.yellow,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  child: ListView(children: [
                    Text(
                      product.description,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.yellow),
                onPressed: () {
                  Get.find<ProductController>().listProducts.value = [];
                  Get.offAllNamed(Routes.DO_ORDER, arguments: product.id);
                },
                child: Text(
                  "Pesan Sekarang",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.bottomBarHeight,
          )
        ]),
      ),
    );
  }
}
