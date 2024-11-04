import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> checkUser() async {
  User? firebaseUser = FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    Get.toNamed(Routes.HOME);
  } else {}
}

// ignore: must_be_immutable
class LoginView extends GetView<LoginController> {
  LoginView({super.key});
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // checkUser();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Login Screen"),
      ),
      // ignore: avoid_unnecessary_containers
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Container(
              height: 350,
              alignment: Alignment.center,
              child: Lottie.asset("assets/images/Animation_MachineLearning.json"),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                    controller: loginEmailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(),
                    ))),
            const SizedBox(
              height: 15.0,
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                    controller: loginPasswordController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: Icon(Icons.visibility),
                      hintText: 'Password',
                      enabledBorder: OutlineInputBorder(),
                    ))),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  var loginEmail = loginEmailController.text.trim();
                  var logiPassword = loginPasswordController.text.trim();
                  try {
                    final User? firebaseUser = (await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: loginEmail, password: logiPassword))
                        .user;
                    if (firebaseUser != null) {
                      print("firebaseUser ---> $firebaseUser");
                      Get.toNamed(Routes.HOME);
                    } else {}
                  } on FirebaseAuthException catch (e) {
                    // ignore: avoid_print
                    print("Error $e");
                  }
                },
                child: const Text("Log in")),
            const SizedBox(
              height: 10.0,
            ),
            // ignore: avoid_unnecessary_containers
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.FORGOT_PASSWORD);
              },
              child: Container(
                child: const Card(
                    child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Forgot password?"),
                )),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            // ignore: avoid_unnecessary_containers
            GestureDetector(
              onTap: (() {
                Get.toNamed(Routes.SIGN_UP);
              }),
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: const Card(
                    child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Do not have an account. Register?"),
                )),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

loginServices(String userName, String userPhone, String userEmail,
    String userPassword) async {
  User? userid = FirebaseAuth.instance.currentUser;
  try {
    await FirebaseFirestore.instance.collection("users").doc(userid!.uid).set({
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'createdAt': DateTime.now(),
      'userId': userid.uid,
    }).then((value) => {
          FirebaseAuth.instance.signOut(),
          Get.toNamed(Routes.LOGIN),
        });
  } on FirebaseAuthException catch (e) {
    // ignore: avoid_print
    print("Error $e");
  }
}
