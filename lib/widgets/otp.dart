// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pharmacy/controllers/form.controller.dart';

class otpWidget extends GetView<formController> {
  otpWidget({Key? key}) : super(key: key);

  final formController _formControllerMsg = Get.put(formController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.05,
            ),
            Center(
              child: Image.asset('assets/images/icon.png'),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text(
                  "Verify your number with the OTP sent to your Mobile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            OtpTextField(
              numberOfFields: 4,
              borderColor: const Color(0xFF512DA8),
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                //handle validation or checks here
                _formControllerMsg.otpValidator(code);
              },
              onSubmit: (String value) {
                _formControllerMsg.otpVerification(value);
              },
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(70, 0, 0, 0),
                  child: Center(
                    child: Text(
                      "I didn't recieve the code,",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text("Verification Code"),
                            content: Text('Code will be resent '),
                          );
                        });
                  },
                  child: const Text(
                    "Resend OTP",
                  ),
                  style: TextButton.styleFrom(
                      primary: Colors.green,
                      textStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            SizedBox(
              height: size.height * 1.04,
            ),
          ],
        ),
      ),
    );
  }
}
