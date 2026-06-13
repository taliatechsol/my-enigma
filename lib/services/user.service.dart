// ignore_for_file: camel_case_types, avoid_print, library_prefixes

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'apiService.dart';

class userService extends GetxService {
  Future<dynamic> registerUser(String username, String email,
      String mobileNumber, String pharmacyName, String pharmacyCode) async {
    try {
      final dataObject = {
        "userName": username,
        "mobileNumber": mobileNumber,
        "email": email,
        "pharmacyCode": pharmacyCode,
        "pharmacyName": pharmacyName
      };

      final response = await ApiService.fetchWithRetry(
        'user',
        method: 'POST',
        body: dataObject,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 409) {
        return {"status": 409, "message": "User already exists"};
      } else {
        return {"status": response.statusCode, "message": "Server error"};
      }
    } on TimeoutException {
      return {"status": 408, "message": "Request timeout"};
    } catch (e) {
      return {"status": 500, "message": e.toString()};
    }
  }

  Future<dynamic> registerPassword(String password, String id) async {
    try {
      final dataObject = {"password": password, "_id": id};
      final response = await ApiService.fetchWithRetry(
        'user/password',
        method: 'POST',
        body: dataObject,
      );

      return _handleResponse(response);
    } on TimeoutException {
      return {"status": 408, "message": "Request timeout"};
    } catch (e) {
      return {"status": 500, "message": e.toString()};
    }
  }

  Future<dynamic> otpVerification(String otp, String id) async {
    try {
      final dataObject = {"otp": otp, '_id': id};
      final response = await ApiService.fetchWithRetry(
        'user/otp',
        method: 'POST',
        body: dataObject,
      );

      return _handleResponse(response);
    } on TimeoutException {
      return {"status": 408, "message": "Request timeout"};
    } catch (e) {
      return {"status": 500, "message": e.toString()};
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      return {"status": response.statusCode, "message": "API Error"};
    }
  }
}
