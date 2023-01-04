import 'package:get/get.dart';

import '../modules/courier_tracking/bindings/courier_tracking_binding.dart';
import '../modules/courier_tracking/views/courier_tracking_view.dart';
import '../modules/do_order/bindings/do_order_binding.dart';
import '../modules/do_order/views/do_order_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/location_detail/bindings/location_detail_binding.dart';
import '../modules/location_detail/views/location_detail_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../utils/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.DO_ORDER,
      page: () => DoOrderView(),
      binding: DoOrderBinding(),
      children: [
        GetPage(
          name: _Paths.DO_ORDER,
          page: () => DoOrderView(),
          binding: DoOrderBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.COURIER_TRACKING,
      page: () => CourierTrackingView(),
      binding: CourierTrackingBinding(),
    ),
    GetPage(
      name: _Paths.LOCATION_DETAIL,
      page: () => LocationDetailView(),
      binding: LocationDetailBinding(),
    ),
  ];
}
