import 'package:get/get.dart';
import 'package:pharmacy/views/index.dart';
import 'package:pharmacy/views/introPage.dart';
import 'package:pharmacy/views/login.dart';
import 'package:pharmacy/views/otp.dart';
import 'package:pharmacy/views/password.dart';
import 'package:pharmacy/views/signup.dart';

class Routes {
  static final routes = [
    GetPage(name: "/", page: () => const firstPage()),
    GetPage(name: "/intro", page: () => const intro_page()),
    GetPage(name: "/login", page: () => const loginPage()),
    GetPage(name: "/signUp", page: () => signup()),
    GetPage(name: "/password", page: () => password()),
    GetPage(name: "/otp", page: () => const otpPage()),
    
  ];
}
