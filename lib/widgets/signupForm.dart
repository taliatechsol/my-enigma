// ignore_for_file: camel_case_types, file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/controllers/form.controller.dart';
import 'package:pharmacy/widgets/dialog.dart';

class signupForm extends GetView<formController> {
  signupForm({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  final formController _formControllerMsg = Get.put(formController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: identical(_formControllerMsg.message, 600)
          ? BlurryDialog("Data Validation Error",
              "Data Entered in the form is not valid !!!! please check and enter the values")
          : identical(_formControllerMsg.message, 500)
              ? BlurryDialog("Error while creating the user",
                  "Server could not process the information. Kindly enter the info please !!!!")
              : identical(_formControllerMsg.message, 409)
                  ? BlurryDialog("User Present",
                      "A user already uses the same mobile number.. Add a new mobile number !!")
                  : SafeArea(
                      child: Scaffold(
                        body: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: size.height * 0.05,
                                ),
                                Center(
                                  child: Image.asset("assets/images/icon.png"),
                                ),
                                SizedBox(
                                  height: size.height * 0.05,
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                  child: Center(
                                    child: Text(
                                      "Welcome to MEDZY",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                const Center(
                                  child: Text(
                                    "Fill up this form while we wait for you on",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    " the other side ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 40, 40, 20),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.person_rounded),
                                      hintText: "What do people call you?",
                                      labelText: "Username",
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: _formControllerMsg.userName,
                                    validator: (value) {
                                      return _formControllerMsg
                                          .userNameValidator(value!);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 20),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.mark_as_unread_outlined),
                                      hintText: "Your email id ...",
                                      labelText: "Email",
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _formControllerMsg.email,
                                    validator: (value) {
                                      return _formControllerMsg
                                          .emailValidator(value!);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 20),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        icon:
                                            Icon(Icons.tablet_android_outlined),
                                        hintText: "Your mobile number",
                                        labelText: "Mobile Number"),
                                    keyboardType: TextInputType.number,
                                    controller: _formControllerMsg.mobileNumber,
                                    validator: (value) {
                                      return _formControllerMsg
                                          .mobileNumberValidator(value!);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 20),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        icon:
                                            Icon(Icons.local_pharmacy_outlined),
                                        hintText: "Name of your pharmacy",
                                        labelText: "Pharmacy Name"),
                                    keyboardType: TextInputType.text,
                                    controller: _formControllerMsg.pharmacyName,
                                    validator: (value) {
                                      return _formControllerMsg
                                          .pharmacyNameValidator(value!);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 20),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        icon: Icon(Icons.code),
                                        hintText: "Your Pharmacy Code",
                                        labelText: "Pharmacy Code"),
                                    keyboardType: TextInputType.text,
                                    controller: _formControllerMsg.pharmacyCode,
                                    validator: (value) {
                                      return _formControllerMsg
                                          .pharmacyCodeValidator(value!);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 40, 40, 50),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.toNamed('/intro');
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey),
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Processing your data ",
                                              ),
                                            ),
                                          );
                                          controller.submit(context);
                                        },
                                        child: const Text(
                                          "Next",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.green),
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
    );
  }
}
