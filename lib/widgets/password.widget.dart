// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy/controllers/form.controller.dart';
import 'package:pharmacy/widgets/dialog.dart';

class passwordForm extends StatefulWidget {
  const passwordForm({Key? key}) : super(key: key);

  @override
  _passwordFormState createState() => _passwordFormState();
}

class _passwordFormState extends State<passwordForm> {
  final _formController = Get.put(formController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: identical(_formController.message, 600)
          ? BlurryDialog("Data Validation Error",
              "Data Entered in the form is not valid !!!! please check and enter the values")
          : identical(_formController.message, 500)
              ? BlurryDialog("Error while creating the user",
                  "Server could not process the information. Kindly enter the info please !!!!")
              : identical(_formController.message, 409)
                  ? BlurryDialog("User Present",
                      "A user already uses the same mobile number.. Add a new mobile number !!")
                  : Scaffold(
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
                                  "Enter your password to secure your account",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 20),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.lock_rounded),
                                    hintText: "What is your maiden name?",
                                    labelText: "Password",
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  controller:
                                      _formController.passwordTextController,
                                  obscureText: true,
                                  obscuringCharacter: "*",
                                  validator: (value) {
                                    return _formController
                                        .passwordValidator(value);
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 20),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.lock_rounded),
                                    hintText: "Confirm your password",
                                    labelText: "Confirm Password",
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: _formController
                                      .confirmpasswordTextController,
                                  obscureText: true,
                                  obscuringCharacter: "*",
                                  validator: (value) {
                                    return _formController
                                        .passwordValidator(value);
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
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.grey),
                                        shadowColor:
                                            WidgetStateProperty.all<Color>(
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
                                        if (_formKey.currentState?.validate() == true) {
                                          _formKey.currentState?.save();
                                          _formController.passwordSubmission(context);
                                        }
                                      },
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                        ),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.green),
                                        shadowColor:
                                            WidgetStateProperty.all<Color>(
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
    );
  }
}
