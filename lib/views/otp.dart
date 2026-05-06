// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:pharmacy/widgets/otp.dart';

class otpPage extends StatelessWidget {
  const otpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: otpWidget(),
      ),
    );
  }
}
