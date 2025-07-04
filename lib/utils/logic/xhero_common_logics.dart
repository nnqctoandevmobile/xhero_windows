import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/colors.dart';
import '../../constants/common.dart';

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

// Convert a number to Roman numerals
String toRomanNumeral(int number) {
  if (number < 1 || number > 3999) {
    throw ArgumentError("Number out of range (must be between 1 and 3999)");
  }

  const romanNumerals = [
    ['M', 1000],
    ['CM', 900],
    ['D', 500],
    ['CD', 400],
    ['C', 100],
    ['XC', 90],
    ['L', 50],
    ['XL', 40],
    ['X', 10],
    ['IX', 9],
    ['V', 5],
    ['IV', 4],
    ['I', 1],
  ];

  final stringBuffer = StringBuffer();
  for (final pair in romanNumerals) {
    final symbol = pair[0] as String;
    final value = pair[1] as int;
    while (number >= value) {
      stringBuffer.write(symbol);
      number -= value;
    }
  }
  return stringBuffer.toString();
}

// Calculate the number of days until a specified date
int daysUntil(String dateString) {
  try {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime targetDate = format.parse(dateString);

    int difference = targetDate.difference(today).inDays;

    return difference;
  } catch (e) {
    return 0;
  }
}

// Capitalize each word in a TextEditingController's text
void capitalizeWords(TextEditingController controller) {
  String text = controller.text;
  String capitalizedText = text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');

  if (capitalizedText != text) {
    controller.value = controller.value.copyWith(
      text: capitalizedText,
      selection: TextSelection.collapsed(offset: capitalizedText.length),
    );
  }
}

// Check if two years are less than 18 years apart
bool isLessThan18YearsApart(String yearString1, String yearString2) {
  int year1 = int.tryParse(yearString1) ?? 0;
  int year2 = int.tryParse(yearString2) ?? 0;

  int difference = (year1 - year2).abs();
  return difference < 18;
}

// Format a date string to ensure consistent dd/mm/yyyy format
String formatDate(String date) {
  List<String> parts = date.split('/');

  if (parts.length != 3) {
    throw const FormatException(
      "Ngày không hợp lệ. Định dạng đúng là dd/mm/yyyy",
    );
  }

  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  String year = parts[2];

  String formattedDay = formatWithLeadingZero(day);
  String formattedMonth = formatWithLeadingZero(month);

  return '$formattedDay/$formattedMonth/$year';
}

// Format a number with a leading zero if less than 10
String formatWithLeadingZero(int number) {
  return number < 10 ? '0$number' : '$number';
}

// Get the zodiac index based on the zodiac name
int getZodiacIndex(String zodiac) {
  const zodiacs = [
    'tys',
    'suu',
    'dan',
    'mao',
    'thin',
    'tyj',
    'ngo',
    'mui',
    'than',
    'dau',
    'tuat',
    'hoi',
  ];

  final index = zodiacs.indexOf(zodiac.toLowerCase());
  return index != -1 ? index + 1 : 0;
}

// Format hour to HH:00 format (duplicate of formatHourSecond)
String formatHour(int hour) {
  if (hour < 0 || hour > 23) {
    throw ArgumentError('Hour must be between 0 and 23');
  }

  String formattedHour = hour.toString().padLeft(2, '0');
  return '$formattedHour:00';
}

// Get color based on death type key from constants
Color getColorByDeathType(String key) {
  return CommonConstants.colorOfDeathTypes[key] ?? AppColor.primaryColor;
}

// Compress an image file and save it to the documents directory
Future<String> compressImageString(String imagePath) async {
  try {
    final compressedImageBytes = await FlutterImageCompress.compressWithFile(
      imagePath,
      minHeight: 1024,
      minWidth: 1024,
      quality: 90,
    );

    final directory = await getApplicationDocumentsDirectory();
    final compressedImagePath = '${directory.path}/compressed_screenshot.png';
    final compressedImageFile = File(compressedImagePath);

    await compressedImageFile.writeAsBytes(compressedImageBytes!);

    return compressedImagePath;
  } catch (e) {
    printConsole('Error compressing image: $e');
    return imagePath;
  }
}

// Get color based on status key from constants
Color getColorByStatus(String key) {
  return CommonConstants.colorOfStatuss[key] ?? AppColor.primaryColor;
}