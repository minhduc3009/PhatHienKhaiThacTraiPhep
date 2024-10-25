import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/page_one_controller.dart';
import '../ui/camera.dart';
import '../ui/gallery.dart';

class PageOneView extends GetView<PageOneController> {
  PageOneView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBarExample();
  }
}

class BottomNavigationBarExample extends StatelessWidget {
  BottomNavigationBarExample({Key? key});
  final BottomNavigationBarController bottomNavigationBarController =
      Get.put(BottomNavigationBarController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan - Predict plant diseases"),
      ),
      body: Obx(() {
        final _selectedIndex =
            bottomNavigationBarController.selectedIndex.value;
        // final cameraIsAvailable =
        //     bottomNavigationBarController.cameraIsAvailable.value;
        final _widgetOptions = bottomNavigationBarController.widgetOptions;

        return _widgetOptions.elementAt(_selectedIndex);
      }),
    );
  }
}

class BottomNavigationBarController extends GetxController {
  // static BottomNavigationBarController get to => Get.find();

  var selectedIndex = 0.obs;
  var cameraIsAvailable = (Platform.isAndroid || Platform.isIOS).obs;
  late CameraDescription cameraDescription;

  List<Widget> widgetOptions = [];

  @override
  void onInit() {
    super.onInit();
    initPages();
  }

  void initPages() async {
    widgetOptions = [const GalleryScreen()];

    if (cameraIsAvailable.value) {
      final cameras = await availableCameras();
      cameraDescription = cameras.first;
      widgetOptions.add(CameraScreen(camera: cameraDescription));
    }
  }
}
