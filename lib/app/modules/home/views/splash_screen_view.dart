import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../constants/image_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // checkUser();
    initialization();
    Future.delayed(
      const Duration(seconds: 6),
      () {
        Get.offNamed(Routes.LOGIN); // Đóng màn hình SplashScreen
      },
    );
  }

  Future<void> checkUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      Get.offNamed(Routes.HOME); // Chuyển đến màn hình HOME
    } else {}
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          ImageConstant.splashLogo,
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
    );
  }
}
