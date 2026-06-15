// ignore_for_file: camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/services/user.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class formController extends GetxController {
  late TextEditingController userName;
  late TextEditingController pharmacyName;
  late TextEditingController pharmacyCode;
  late TextEditingController email;
  late TextEditingController mobileNumber;
  late TextEditingController passwordTextController;
  late TextEditingController confirmpasswordTextController;
  late TextEditingController otpTextController;

  final RxInt message = 0.obs;

  @override
  void onInit() {
    super.onInit();
    userName = TextEditingController();
    pharmacyName = TextEditingController();
    pharmacyCode = TextEditingController();
    email = TextEditingController();
    mobileNumber = TextEditingController();
    passwordTextController = TextEditingController();
    confirmpasswordTextController = TextEditingController();
    otpTextController = TextEditingController();
  }

  @override
  void onClose() {
    userName.dispose();
    pharmacyName.dispose();
    pharmacyCode.dispose();
    email.dispose();
    mobileNumber.dispose();
    passwordTextController.dispose();
    confirmpasswordTextController.dispose();
    otpTextController.dispose();
    super.onClose();
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    } else if (!value.contains('@') || !value.contains('.')) {
      return "Enter correct Email address";
    }
    return null;
  }

  String? userNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Username cannot be empty";
    } else if (value.length < 5) {
      return "Username Should be more than 5 chars";
    }
    return null;
  }

  String? pharmacyNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Pharmacy Name cannot be empty";
    } else if (value.length < 5) {
      return "Pharmacy Name Should be more than 5 chars";
    }
    return null;
  }

  String? pharmacyCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Pharmacy Code cannot be empty";
    } else if (value.length < 6) {
      return "Pharmacy Code Should be more than 6 chars";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    } else if (value.length < 2) {
      return "password should be more than 2 chars";
    }
    return null;
  }

  String? mobileNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Mobile number cannot be empty";
    } else if (value.length < 10) {
      return "Enter a valid mobile number";
    }
    return null;
  }

  String? otpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "OTP cannot be empty";
    } else if (value.length < 4) {
      return "value is not of appropriate length";
    }
    return null;
  }

  void submit(context) async {
    message.value = 600; // Loading state

    try {
      final user = await Get.find<userService>().registerUser(
        userName.text.trim(),
        email.text.trim().toLowerCase(),
        mobileNumber.text.trim(),
        pharmacyName.text.trim(),
        pharmacyCode.text.trim()
      );

      if (user['status'] == 200 && user['message'] == 'Success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userID", user['data']['_id']);
        message.value = 200;
        Get.toNamed("/password");
      } else if (user['status'] == 500) {
        message.value = 500;
      } else if (user['status'] == 409) {
        message.value = 409;
      } else {
        message.value = user['status'] ?? 500;
      }
    } catch (e) {
      message.value = 500;
    }
  }

  void passwordSubmission(context) async {
    message.value = 600;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userID");
      if (userId == null) {
        message.value = 400;
        return;
      }

      final passwordSub = await Get.find<userService>().registerPassword(
          passwordTextController.text, userId);

      if (passwordSub['status'] == 200) {
        message.value = 200;
        Get.toNamed("/otp");
      } else {
        message.value = 409;
      }
    } catch (e) {
      message.value = 500;
    }
  }

  void otpVerification(String otp) async {
    message.value = 600;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userID");
      if (userId == null) {
        message.value = 400;
        return;
      }

      final otpVerf = await Get.find<userService>().otpVerification(
          otp, userId);

      if (otpVerf['status'] == 200) {
        message.value = 200;
        // Proceed to next page or success
      } else {
        message.value = 409;
      }
    } catch (e) {
      message.value = 500;
    }
  }
}
