import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class BodyWithBackgroundLight extends StatelessWidget {
  final Widget child;
  final String? background;

  const BodyWithBackgroundLight({
    super.key,
    required this.child,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(color: Color(0xffbc8d49)),
        ),
        Container(
            width: Get.width,
            height: Get.height,
            color: AppColor.grayTextBoldColor,
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),
        Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(background!),
              fit: BoxFit.cover,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
