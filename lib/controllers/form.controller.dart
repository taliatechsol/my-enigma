// ignore_for_file: camel_case_types, body_might_complete_normally_nullable, avoid_print, unnecessary_null_comparison

// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pharmacy/models/response.model.dart';
import 'package:pharmacy/services/user.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class formController extends GetxController {
  TextEditingController userName = TextEditingController();
  TextEditingController pharmacyName = TextEditingController();
  TextEditingController pharmacyCode = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmpasswordTextController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final RxInt message = 0.obs;

  String emailValidator(String value) {
    if (value == null) {
      return "value is null";
    } else if (value.isEmpty || value.contains('@') || value.isEmail) {
      return "Enter correct Email address";
    } else {
      return value;
    }
  }

  String userNameValidator(String value) {
    if (value == null) {
      return "value is null";
    } else if (value.isEmpty) {
      return '';
    } else if (value.length < 5) {
      return "Username Should be more than 5 chars";
    } else {
      return value;
    }
  }

  String pharmacyNameValidator(String value) {
    if (value == null) {
      return "value is null";
    } else if (value.isEmpty || value.length < 5) {
      return "Pharamcy Name Should be more than 5 chars";
    } else {
      return value;
    }
  }

  String pharmacyCodeValidator(String value) {
    if (value == null) {
      return "value is null";
    } else if (value.isEmpty || value.length < 6) {
      return "Pharmacy Code Should be more than 6 chars";
    } else {
      return value;
    }
  }

  String passwordValidator(String value) {
    if (value == null) {
      return "value is null";
    } else if (value.isEmpty || value.length < 2) {
      return "password should be more than 2 chars";
    } else {
      return value;
    }
  }

  String mobileNumberValidator(String value) {
    if (value == null) {
      return "value is null";
    } else if (value.isEmpty || value.length < 10) {
      return "Enter a valid mobile number";
    } else {
      return value;
    }
  }

  String otpValidator(String value) {
    if (value == null) {
      return "value is null";
    } else if (value.isEmpty || value.length < 4) {
      return "value is not of appropriate length";
    } else {
      return value;
    }
  }

  void submit(context) async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      message.value = 600;
    } else {
      _formKey.currentState?.save();
      final user = await userService().registerUser(userName.text, email.text,
          mobileNumber.text, pharmacyName.text, pharmacyCode.text);
      if (user['status'] == 200 && user['message'] == 'Success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userID", user['data']['_id']);
        Get.toNamed("/password");
      } else if (user['status'] == 500) {
        message.value = 500;
      } else if (user['status'] == 409) {
        message.value = 409;
      } else {
        message.value = 200;
      }
    }
  }

  void passwordSubmission(context) async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      message.value = 600;
    } else {
      _formKey.currentState?.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final passwordSub = await userService().registerPassword(
          passwordTextController.text, prefs.getString("userID")!);
      if (passwordSub['status'] == 200) {
        Get.toNamed("/otp");
      } else {
        message.value = 409;
      }
    }
  }

  void otpVerification(context) async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      message.value = 600;
    } else {
      _formKey.currentState?.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final otpVerf = await userService()
          .otpVerification(otpTextController.text, prefs.getString("userID")!);
      if (otpVerf['status'] == 200) {
      } else {
        message.value = 409;
      }
    }
  }
}
