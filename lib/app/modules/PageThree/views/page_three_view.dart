import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/page_three_controller.dart';

class PageThreeView extends GetView<PageThreeController> {
  const PageThreeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageThreeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PageThreeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
