// ignore_for_file: camel_case_types, avoid_print, library_prefixes

import 'package:get/get.dart';
import 'apiService.dart' as globalService;

class userService extends GetConnect {
  String apiURL = globalService.baseURL;

  Future<dynamic> registerUser(String username, String email,
      String mobileNumber, String pharmacyName, String pharmacyCode) async {
    final dataObject = {
      "userName": username,
      "mobileNumber": mobileNumber,
      "email": email,
      "pharmacyCode": pharmacyCode,
      "pharmacyName": pharmacyName
    };

    final response = await post(apiURL + 'user', dataObject);

    if (response.statusCode == 500 || response.statusCode == 404) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    }
  }

  Future<dynamic> registerPassword(String password, String _id) async {
    final dataObject = {"password": password, "_id": _id};
    final response = await post(apiURL + 'user/password', dataObject);

    if (response.statusCode == 500 || response.statusCode == 404) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    }
  }

  Future<dynamic> otpVerification(String otp, String _id) async {
    final dataObject = {"otp": otp, '_id': _id};
    final response = await post(apiURL + 'user/otp', dataObject);

    if (response.statusCode == 500 || response.statusCode == 404) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    }
  }
}
