import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/sign_up_controller.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class SignUpView extends GetView<SignUpController> {
  SignUpView({Key? key}) : super(key: key);
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign Up Screen"),
      ),
      // ignore: avoid_unnecessary_containers
      body: SingleChildScrollView(
        // ignore: avoid_unnecessary_containers
        child: Container(
            child: Column(
          children: [
            Container(
              height: 200,
              alignment: Alignment.center,
              child: Lottie.asset("assets/images/farm_animation.json"),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Username',
                      enabledBorder: OutlineInputBorder(),
                    ))),
            const SizedBox(
              height: 15.0,
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                    controller: userPhoneController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Phone',
                      enabledBorder: OutlineInputBorder(),
                    ))),
            const SizedBox(
              height: 15.0,
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                    controller: userEmailController,
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
                    controller: userPasswordController,
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
                  var userName = userNameController.text.trim();
                  var userPhone = userPhoneController.text.trim();
                  var userEmail = userEmailController.text.trim();
                  var userPassword = userPasswordController.text.trim();
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: userEmail, password: userPassword)
                      .then((value) => {
                            print("_____________signUpUser__________ --> OK"),
                            signUpUser(
                              userName,
                              userPhone,
                              userEmail,
                              userPassword,
                            )
                          });
                  Get.toNamed(Routes.LOGIN);
                },
                child: const Text("SignUp")),
            const SizedBox(
              height: 10.0,
            ),
            // ignore: avoid_unnecessary_containers
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.LOGIN);
              },
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: const Card(
                    child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Already have an account. Login?"),
                )),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

signUpUser(String userName, String userPhone, String userEmail,
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
        });
  } on FirebaseAuthException catch (e) {
    // ignore: avoid_print
    print("Error $e");
  }
}
