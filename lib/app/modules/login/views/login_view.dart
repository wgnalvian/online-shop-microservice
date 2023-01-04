import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:olshop/app/controllers/user_controller.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _userC = Get.find<UserController>();
    return Scaffold(
        backgroundColor: Color(0xFF03071E).withOpacity(1),
        body: SizedBox.expand(
          child: Stack(alignment: Alignment.center, children: [
            Positioned(
              top: -140,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(400)),
                child: Container(
                  width: 500,
                  height: 500,
                  color: Color(0xFFF5FF00),
                ),
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Lottie.asset("asset/lottie/login.json",
                  width: Get.width * 0.8, height: Get.height * 0.5),
              Text(
                "Sign In",
                style: TextStyle(
                    color: Color(0xFFF5FF00),
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
              Obx(() {
                return _userC.loading.value
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : SignInButton(Buttons.GoogleDark, onPressed: () {
                        _userC.signInWithGoogle();
                      });
              })
            ]),
          ]),
        ));
  }
}
