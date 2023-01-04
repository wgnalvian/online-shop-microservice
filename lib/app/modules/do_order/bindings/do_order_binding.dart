import 'package:get/get.dart';

import '../controllers/do_order_controller.dart';

class DoOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoOrderController>(
      () => DoOrderController(),
    );
  }
}
