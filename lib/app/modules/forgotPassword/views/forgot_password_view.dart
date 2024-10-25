import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  TextEditingController forgotPasswordController = TextEditingController();
  ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Forgot Password Screen"),
      ),
      // ignore: avoid_unnecessary_containers
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Container(
              height: 350,
              alignment: Alignment.center,
              child: Lottie.asset("assets/images/farm_animation.json"),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                    controller: forgotPasswordController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(),
                    ))),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  var forgetEmail = forgotPasswordController.text.trim();
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: forgetEmail)
                        .then((value) => {
                              // ignore: avoid_print
                              print("Email Sent!!!"),
                              // Get.off(() => const LoginScreen()),
                            });
                  } on FirebaseAuthException catch (e) {
                    // ignore: avoid_print
                    print("Error $e");
                  }
                },
                child: const Text("Send Email")),
          ],
        )),
      ),
    );
  }
}
