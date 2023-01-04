import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:olshop/app/controllers/product_controller.dart';
import 'package:olshop/app/controllers/user_controller.dart';
import 'package:olshop/app/models/product_model.dart';
import 'package:olshop/app/modules/home/widgets/bottom_sheet_widget.dart';
import 'package:olshop/app/routes/app_pages.dart';
import 'package:olshop/app/utils/constant.dart';
import 'package:olshop/app/utils/number_format.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userC = Get.find<UserController>();
    final prodctC = Get.find<ProductController>();
    return Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            prodctC.listProducts.value = [];
            Get.offAllNamed(Routes.ORDER);
          },
          child: Container(
            width: 100,
            height: 40,
            child: FittedBox(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.shopping_bag,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: Text(
                  "Pesanan",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ])),
            decoration: BoxDecoration(
                color: Colors.orange[400],
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        backgroundColor: Color(0xFF03071E),
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
                backgroundImage:
                    NetworkImage(_userC.photoUrl.value) as ImageProvider),
          ),
          backgroundColor: Color(0xFF03071E),
          title: Text(_userC.name.value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFFF5FF00))),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  prodctC.listProducts.value = [];
                  _userC.logout();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: FutureBuilder<RxList>(
            future: prodctC.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Obx(() => Container(
                        child: Padding(
                      padding: EdgeInsets.all(8),
                      child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 7 / 15,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8),
                          children: List.generate(
                            snapshot.data!.length,
                            (index) {
                              final listProducts = prodctC.listProducts.value;
                              return Material(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(20),
                                elevation: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Stack(children: [
                                          InteractiveViewer(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Image.network(
                                                "${Constant.API}/images/${listProducts[index].image[0]}",
                                                fit: BoxFit.fill,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return CircularProgressIndicator();
                                                },
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              prodctC
                                                  .makeALoveWithProduct(
                                                      listProducts[index].id)
                                                  .then((value) {
                                                listProducts[index].isFavorite =
                                                    !listProducts[index]
                                                        .isFavorite;
                                                prodctC.listProducts.refresh();
                                              });

                                              // listProducts[index].isFavorite =
                                              //     !listProducts[index]
                                              //         .isFavorite;
                                              // prodctC.listProducts.refresh();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: listProducts[index]
                                                          .isFavorite
                                                      ? Icon(
                                                          Icons.favorite,
                                                          size: 45,
                                                          color: Colors.pink,
                                                        )
                                                      : Icon(
                                                          Icons.favorite_border,
                                                          size: 45,
                                                        )),
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: Material(
                                            color: Color(0xFF03071E),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                    child: Text(
                                                      listProducts[index].name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${convertToIdr(listProducts[index].price, 2)}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color:
                                                            Color(0xFFF5FF00),
                                                      )),
                                                  SizedBox(height: 5),
                                                  SizedBox(
                                                      height: 10,
                                                      child: Text(
                                                        listProducts[index]
                                                            .description,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                                  SizedBox(height: 5),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Color(
                                                                    0xFFF5FF00)),
                                                        onPressed: () {
                                                          Get.bottomSheet(
                                                            BottomSheetWidget(
                                                              product:
                                                                  listProducts[
                                                                      index],
                                                            ),
                                                          );
                                                        },
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .shopping_bag_outlined,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              Text(
                                                                'Pesan',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            ])),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                    )));
              } else {
                return Center(
                  child: Lottie.asset("asset/lottie/loading.json",
                      width: Get.width * 0.8, height: Get.height * 0.5),
                );
              }
            }));
  }
}
