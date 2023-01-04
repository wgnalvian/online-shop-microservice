import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Travels'),
      home: Scaffold(
          backgroundColor: Color(0xFF03071E).withOpacity(1),
          body: SizedBox.expand(
            child: Stack(children: [
              Positioned(
                top: -120,
                left: -70,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(400)),
                  child: Container(
                    width: 500,
                    height: 500,
                    color: Color(0xFFF5FF00),
                  ),
                ),
              ),
              SizedBox.expand(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("asset/lottie/onnline-shop.json",
                          width: Get.width * 0.8, height: Get.height * 0.5),
                      Text(
                        "Pak Cik Kumar",
                        style: TextStyle(
                            color: Color(0xFFF5FF00),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Onnline Shop",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ]),
              ),
            ]),
          )),
    );
  }
}
