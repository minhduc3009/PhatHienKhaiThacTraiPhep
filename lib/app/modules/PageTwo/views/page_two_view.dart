import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/page_two_controller.dart';

class PageTwoView extends GetView<PageTwoController> {
  const PageTwoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageTwoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PageTwoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
