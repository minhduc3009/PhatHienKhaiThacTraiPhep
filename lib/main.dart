import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'generated/locales.g.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      title: "AIoT-Nano",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      translationsKeys: AppTranslation.translations,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
