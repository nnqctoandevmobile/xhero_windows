import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Print content to console in debug mode using GetX logging
void printConsole(String content) {
  if (kDebugMode) {
    Get.log(content);
  }
}

// Check if the device is a Samsung Z Fold based on screen dimensions
bool isSamsungZFold(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  final double widthInPixels = size.width;
  final double heightInPixels = size.height;

  return widthInPixels > 500 && heightInPixels < 1000;
}

// Return optimized size for phone, Z Fold, or tablet based on screen width
double optimizedSize({
  required double phone,
  required double zfold,
  required double tablet,
  required BuildContext context,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth > 500) {
    return isSamsungZFold(context) ? zfold : tablet;
  } else {
    return phone;
  }
}

// Capitalize each word in a string
String capitalForText(String value) {
  String text = value;
  String capitalizedText = text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');
  return capitalizedText;
}
