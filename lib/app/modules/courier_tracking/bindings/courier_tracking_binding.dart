import 'package:get/get.dart';

import '../controllers/courier_tracking_controller.dart';

class CourierTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourierTrackingController>(
      () => CourierTrackingController(),
    );
  }
}
