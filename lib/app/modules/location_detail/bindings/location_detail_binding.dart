import 'package:get/get.dart';

import '../controllers/location_detail_controller.dart';

class LocationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationDetailController>(
      () => LocationDetailController(),
    );
  }
}
