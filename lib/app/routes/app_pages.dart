import 'package:get/get.dart';

import '../modules/PageOne/bindings/page_one_binding.dart';
import '../modules/PageOne/views/page_one_view.dart';
import '../modules/PageThree/bindings/page_three_binding.dart';
import '../modules/PageThree/views/page_three_view.dart';
import '../modules/PageTwo/bindings/page_two_binding.dart';
import '../modules/PageTwo/views/page_two_view.dart';
import '../modules/forgotPassword/bindings/forgot_password_binding.dart';
import '../modules/forgotPassword/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/splash_screen_view.dart';
import '../modules/home_new/bindings/home_new_binding.dart';
import '../modules/home_new/views/home_new_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/signUp/bindings/sign_up_binding.dart';
import '../modules/signUp/views/sign_up_view.dart';
import '../modules/userProfile/bindings/user_profile_binding.dart';
import '../modules/userProfile/views/user_profile_view.dart';
import '../modules/weatherForecast/bindings/weather_forecast_binding.dart';
import '../modules/weatherForecast/views/weather_forecast_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH, // Đặt tên cho màn hình SplashScreen
      page: () => SplashScreen(), // Tạo màn hình SplashScreen
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.USER_PROFILE,
      page: () => UserProfileView(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_ONE,
      page: () => PageOneView(),
      // binding: PageOneBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_TWO,
      page: () => PageTwoView(),
      binding: PageTwoBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_THREE,
      page: () => PageThreeView(),
      binding: PageThreeBinding(),
    ),
    GetPage(
      name: _Paths.WEATHER_FORECAST,
      page: () => WeatherForecastView(),
      binding: WeatherForecastBinding(),
    ),
    GetPage(
      name: _Paths.HOME_NEW,
      page: () => HomeNewView(),
      binding: HomeNewBinding(),
    ),
  ];
}
