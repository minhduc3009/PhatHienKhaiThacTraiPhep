import 'package:get/get.dart';

import '../controllers/home_new_controller.dart';

class HomeNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeNewController>(
      () => HomeNewController(),
    );
  }
}
