import 'package:get/get.dart';

import '../controllers/page_two_controller.dart';

class PageTwoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageTwoController>(
      () => PageTwoController(),
    );
  }
}
