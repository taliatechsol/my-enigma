// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/controllers/form.controller.dart';
import 'package:pharmacy/widgets/password.widget.dart';

class password extends StatelessWidget {
  password({Key? key}) : super(key: key);

  final formController controller = Get.put(formController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: passwordForm(),
      ),
    );
  }
}
