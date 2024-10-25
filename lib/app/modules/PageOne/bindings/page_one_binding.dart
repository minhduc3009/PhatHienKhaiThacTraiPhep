import 'package:get/get.dart';

import '../controllers/page_one_controller.dart';

class PageOneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageOneController>(
      () => PageOneController(),
    );
  }
}
