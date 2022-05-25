// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class loginPage extends StatelessWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height * 0.05,
              ),
              Center(
                child: Image.asset("assets/images/icon.png"),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Center(
                  child: GestureDetector(
                onTap: () => Get.toNamed('/intro'),
                child: const ButtonBar(
                  children: <Widget>[
                    Text("Go Back"),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
