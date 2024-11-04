import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../PageOne/views/page_one_view.dart';
import '../../PageTwo/views/page_two_view.dart';
import '../../PageThree/views/page_three_view.dart';
import '../../home_new/views/home_new_view.dart';
import '../../userProfile/views/user_profile_view.dart';
import '../../weatherForecast/views/weather_forecast_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final BottomNavigationController bottomNavigationController =
      Get.put(BottomNavigationController());
  final screens = [
    HomeNewView(),
    PageThreeView(),
    PageTwoView(),
    WeatherForecastView(),
    UserProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
          () => IndexedStack(
            index: bottomNavigationController.selectedIndex.value,
            children: screens,
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          items: const [
            TabItem(
              icon: Icons.home_work_outlined,
              title: 'Home',
            ),
            TabItem(
              icon: Icons.home_work,
              title: 'Home2',
            ),
            TabItem(
              icon: Icons.history,
              title: 'History',
            ),
            TabItem(
              icon: Icons.sunny_snowing,
              title: 'Weather',
            ),
            TabItem(
              icon: Icons.manage_accounts_outlined,
              title: 'Account',
            ),
          ],
          onTap: (index) {
            bottomNavigationController.changeIndex(index);
          },
          backgroundColor: Colors.deepOrangeAccent,
        ));
  }
}
