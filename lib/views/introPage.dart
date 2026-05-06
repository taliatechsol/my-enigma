// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class intro_page extends StatefulWidget {
  const intro_page({Key? key}) : super(key: key);

  @override
  State<intro_page> createState() => _intro_pageState();
}

bool isLoading = true;

class _intro_pageState extends State<intro_page> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void onIntroEnd(context) {
    Get.toNamed("/signUp");
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  void initState() {
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      child: Container(
        child: isLoading
            ? const Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                ),
              )
            : IntroductionScreen(
                key: introKey,
                globalBackgroundColor: Colors.white,
                globalHeader: Align(
                  alignment: Alignment.topRight,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, right: 16),
                      child: _buildImage('images/icon.png', 100),
                    ),
                  ),
                ),
                globalFooter: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    child: const Text(
                      'Lets go right away!',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    onPressed: () => onIntroEnd(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green.shade300),
                    ),
                  ),
                ),
                pages: [
                  PageViewModel(
                    title: "Place Orders",
                    body:
                        "Instead of having to buy an entire stock, order in any quantity you want.",
                    image: Image.asset("assets/images/img1.png"),
                    decoration: pageDecoration,
                  ),
                  PageViewModel(
                    title: "Track & Trace",
                    body: "Track the order on the go.",
                    image: Image.asset("assets/images/img2.jpg"),
                    decoration: pageDecoration,
                  ),
                  PageViewModel(
                    title: "Order Book in your hands",
                    body:
                        "Go online and reduce the cost of maintaining the stock of medicines more efficiently.",
                    image: Image.asset("assets/images/img3.png"),
                    decoration: pageDecoration,
                  ),
                ],
                onDone: () => onIntroEnd(context),
                // onSkip: () => onIntroEnd(context), // You can override onSkip callback
                showSkipButton: true,
                skipOrBackFlex: 0,
                nextFlex: 0,
                skip: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.green),
                ),
                next: const Icon(
                  Icons.arrow_forward,
                  color: Colors.green,
                ),
                done: const Text('Sign Up',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                curve: Curves.fastLinearToSlowEaseIn,
                controlsMargin: const EdgeInsets.all(16),
                controlsPadding: kIsWeb
                    ? const EdgeInsets.all(12.0)
                    : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                dotsDecorator: const DotsDecorator(
                  size: Size(10.0, 10.0),
                  color: Colors.grey,
                  activeSize: Size(22.0, 10.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
                dotsContainerDecorator: const ShapeDecoration(
                  color: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
      ),
    );
  }
}
