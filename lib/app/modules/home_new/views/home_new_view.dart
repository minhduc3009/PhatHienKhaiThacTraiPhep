import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../controllers/home_new_controller.dart';
import '../constants/color_constant.dart';
import '../constants/icon_constant.dart';
import '../constants/image_constant.dart';
import '../features/article/screens/article_screen.dart';
import '../features/cultivation_menu/screens/cultivation_screen.dart';
import '../features/guide/screens/guide_screen.dart';
import '../features/plant_processing/screens/plant_processing_screen.dart';
import '../features/article/models/article_model.dart';
import '../features/article/screens/article_detail_screen.dart';
import '../features/article/widgets/article_widget.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeNewView extends StatefulWidget {
  @override
  _HomeNewViewState createState() => _HomeNewViewState();
}

class _HomeNewViewState extends State<HomeNewView> {
  // HomeNewView({super.key});
  final HomeNewController controller = Get.put(HomeNewController());
  final dataBase = FirebaseDatabase.instance.ref();

  final _information = informasi;
  final mapMenu = {
    IconConstant.cultivationMenu: "Fertilizer calculation",
    IconConstant.quizMenu: "Pests and Plant Diseases",
    IconConstant.recipesMenu: "Farming tips",
  };

  // double humidity = mycontroller.doam_khongkhi.value;
  // double ph = mycontroller.do_ph.value;
  // double humidity_dat = mycontroller.doam_dat.value;
  // Hàm này để đọc dữ liệu từ Firebase Realtime Database
  void fetchDataFromFirebase() {
    // Thực hiện logic để đọc nhiệt độ và độ ẩm từ Firebase
    // Sử dụng setState để cập nhật giá trị temperature và humidity
  }

  _HomeNewViewState() {
    dataBase.child('ESP32').once().then((snap) {}).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Image.asset(ImageConstant.topHomeDecoration),
              ),
              Positioned(
                bottom: 10,
                right: 20,
                left: 20,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: ColorConstant.primaryColor.withOpacity(0.2),
                          blurRadius: 16,
                          offset: Offset(1, 1),
                        ),
                      ]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageConstant.logoApp,
                          height: 40,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My App AIoT-Nano",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 10,
          ),
          // ignore: prefer_const_constructors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status System",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Obx(
            () => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
          Obx(
            () => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 10,
            color: Colors.grey.withOpacity(0.1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "History Data",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ArticleScreen()));
                  },
                  child: const Text(
                    "See all",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.primaryColor),
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.only(bottom: 24),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {},
              );
            }),
          ),
        ],
      ),
    ));
  }
}
