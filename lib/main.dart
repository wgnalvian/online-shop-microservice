import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:olshop/app/controllers/order_controller.dart';
import 'package:olshop/app/controllers/product_controller.dart';
import 'package:olshop/app/controllers/user_controller.dart';
import 'package:olshop/app/utils/splash_screen.dart';
import 'package:olshop/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final uid = await prefs.getString("uid");
  final userC = Get.put(UserController(), permanent: true);
  Get.put(ProductController(), permanent: true);
  Get.put(OrderController(), permanent: true);
  runApp(FutureBuilder(
    future: Future.delayed(Duration(seconds: 5)),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Travels'),
          title: "Application",
          initialRoute: uid != null ? Routes.HOME : Routes.LOGIN,
          // initialRoute: Routes.HOME,
          getPages: AppPages.routes,
        );
        return SplashScreen();
      }

      return SplashScreen();
    },
  ));
}
