import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'otpwidget.dart';

class OTPscreen extends StatelessWidget {
  const OTPscreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = Get.size.width;
    double height = Get.size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 52, 48),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: OtpWidget(
            height: height,
            width: width,
          ),
        ),
      ),
    );
  }
}
