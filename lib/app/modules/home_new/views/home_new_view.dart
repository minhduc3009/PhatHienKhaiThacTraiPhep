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

  void fetchDataFromFirebase() {
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
                              "PlantSR",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            // Image.asset(
                            //   ImageConstant.logoTextApp,
                            //   height: 18,
                            // ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Blog provides scientific knowledge \nand crop technology",
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
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: 120, // Điều chỉnh chiều cao ở đây
                      child: SfRadialGauge(
                        title: GaugeTitle(
                            text:
                                'Temperature:\n${controller.nhiet_do.value} C'),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 33,
                                  color: Colors.green),
                              GaugeRange(
                                  startValue: 34,
                                  endValue: 66,
                                  color: Colors.yellow),
                              GaugeRange(
                                  startValue: 67,
                                  endValue: 100,
                                  color: Colors.red),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(value: controller.nhiet_do.value),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 100,
                        width: 90, // Điều chỉnh chiều cao ở đây
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors
                                    .teal, // Foreground color (text color) for the 'On' button
                              ),
                              onPressed: () {
                                print("On Relay1");
                                controller.updateRelayState_1(true);
                              },
                              child: const Text(
                                'On Relay1',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors
                                    .teal, // Foreground color (text color) for the 'On' button
                              ),
                              onPressed: () {
                                print("OFFFF Relay1");
                                controller.updateRelayState_1(false);
                              },
                              child: const Text(
                                'Off Relay1',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 100,
                      width: 120, // Điều chỉnh chiều cao ở đây
                      child: SfRadialGauge(
                        title: GaugeTitle(
                            text:
                                'Air humidity:\n${controller.doam_khongkhi.value}%'),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 33,
                                  color: Colors.green),
                              GaugeRange(
                                  startValue: 34,
                                  endValue: 66,
                                  color: Colors.yellow),
                              GaugeRange(
                                  startValue: 67,
                                  endValue: 100,
                                  color: Colors.red),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                  value: double.tryParse(controller
                                          .doam_khongkhi.value
                                          .toString()) ??
                                      0.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: 120, // Điều chỉnh chiều cao ở đây
                      child: SfRadialGauge(
                        title:
                            GaugeTitle(text: 'PH:\n ${controller.do_ph.value}'),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 14,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 5,
                                  color: Colors.green),
                              GaugeRange(
                                  startValue: 5,
                                  endValue: 10,
                                  color: Colors.yellow),
                              GaugeRange(
                                  startValue: 10,
                                  endValue: 14,
                                  color: Colors.red),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(value: controller.do_ph.value),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 100,
                        width: 90, // Điều chỉnh chiều cao ở đây
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors
                                    .teal, // Foreground color (text color) for the 'On' button
                              ),
                              onPressed: () {
                                print("ON Relay2");
                                controller.updateRelayState_2(true);
                              },
                              child: const Text(
                                'On Relay2',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors
                                    .teal, // Foreground color (text color) for the 'On' button
                              ),
                              onPressed: () {
                                print("OFFFF Relay2");
                                controller.updateRelayState_2(false);
                              },
                              child: const Text(
                                'Off Relay2',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 100,
                      width: 120, // Điều chỉnh chiều cao ở đây
                      child: SfRadialGauge(
                        title: GaugeTitle(
                            text:
                                'Soil moisture:\n${controller.doam_dat.value}%'),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 33,
                                  color: Colors.green),
                              GaugeRange(
                                  startValue: 34,
                                  endValue: 66,
                                  color: Colors.yellow),
                              GaugeRange(
                                  startValue: 67,
                                  endValue: 100,
                                  color: Colors.red),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                  value: double.tryParse(controller
                                          .doam_dat.value
                                          .toString()) ??
                                      0.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  mapMenu.length,
                  (index) => GestureDetector(
                        onTap: () {
                          if (mapMenu.values.elementAt(index) ==
                              "Fertilizer calculation") {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OnBoardingScreen()));
                          } else if (mapMenu.values.elementAt(index) ==
                              "Pests and Plant Diseases") {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CultivationScreen()));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PengolahanScreen()));
                          }
                        },
                        child: Container(
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorConstant.primaryColor
                                            .withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      ),
                                    ]),
                                child: Image(
                                    width: 32,
                                    height: 32,
                                    image: Svg(mapMenu.keys.elementAt(index))),
                              ),
                              Text(
                                mapMenu.values.elementAt(index),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      )),
            ),
          ),
          SizedBox(
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
                Text(
                  "Article",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ArticleScreen()));
                  },
                  child: Text(
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
            itemCount: 5,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ArticleDetailScreen(
                          source: _information[index].sumber)));
                },
                child: CardArtikel(
                  data: _information[index],
                ),
              );
            }),
          ),
        ],
      ),
    ));
  }
}