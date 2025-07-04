// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resource/assets_constant/zod_constant.dart';
import 'colors.dart';

class CommonConstants {
  static int deepLinkId = 0;
  static const double extraSmallText = 12;
  static const double extraSmallTitle = 14;
  static const double smallText = 14;
  static const double smallTitle = 16;
  static const double mediumText = 16;
  static const double mediumTitle = 18;
  static const double hintText = 16;
  static const double largeText = 18;
  static const double largeTitle = 18;
  static const double extraLargeText = 20;
  static const double extraLargeTitle = 22;
  static const double largePrice = 20;
  static const double price = 18;
  static const double exLargePrice = 22;
  static const double lable = 14;
  static const String light = 'Light';
  static const String medium = 'Medium';
  static const String bold = 'Bold';
  static const String fuzzyBubbles_bold = 'FuzzyBubbles-Bold';
  static const String museoModerno = 'MuseoModerno';
  static const String utmBitsumishi = 'UTM-Bitsumishi-Pro';
  static const String mulish = 'Mulish';
  static const Map<int, String> zodiacMapIcons = {
    1: ZodiacsConstants.zod_the_rat,
    2: ZodiacsConstants.zod_the_ox,
    3: ZodiacsConstants.zod_the_tiger,
    4: ZodiacsConstants.zod_the_cat,
    5: ZodiacsConstants.zod_the_dragon,
    6: ZodiacsConstants.zod_the_snake,
    7: ZodiacsConstants.zod_the_horse,
    8: ZodiacsConstants.zod_the_goat,
    9: ZodiacsConstants.zod_the_monkey,
    10: ZodiacsConstants.zod_the_rooster,
    11: ZodiacsConstants.zod_the_dog,
    12: ZodiacsConstants.zod_the_pig,
  };
  static const Map<String, Color> colorOf5Elements = {
    'kim': Color(0xffECAD06),
    'hoa': Color(0xffBD181B),
    'moc': Color(0xff078E46),
    'thuy': Color(0xff1C69FF),
    'tho': Color(0xff86490D),
    // refferal
    'hoang': Color(0xffFFC23F),
    'hac': Color(0xff8C8C8C),
  };
  static Map<String, Color> colorOfStatuss = {
    'binh_thuong': AppColor.grayTextwhiteColor,
    'hoi_tot': AppColor.colorBlueDark,
    'rat_tot': AppColor.colorGreenDark,
    'tot': AppColor.newPrimaryColor1,
  };
  static Map<String, Color> colorOfDeathTypes = {
    'Nhập mộ': AppColor.colorGreenDark,
    'Trùng tang': AppColor.colorRed,
    'Thiên di': AppColor.primaryColor,
  };
  static const Map<String, int> starsOfStatus = {
    'tot': 3,
    'hoi_tot': 2,
    'rat_tot': 4,
    'binh_thuong': 1,
  };
  static List<String> allOfCodesData = [
    'sang-cat',
    'xay-dung',
    'cong-viec-trong-dai',
    'cuoi-hoi',
    'tho-cung',
  ];

  static List<LunarHour> lunarHours = [
    LunarHour(code: 'giap tys', ZodiacsConstants.zod_the_rat),
    LunarHour(code: 'at suu', ZodiacsConstants.zod_the_ox),
    LunarHour(code: 'binh dan', ZodiacsConstants.zod_the_tiger),
    LunarHour(code: 'dinh mao', ZodiacsConstants.zod_the_cat),
    LunarHour(code: 'mau thin', ZodiacsConstants.zod_the_dragon),
    LunarHour(code: 'ky tyj', ZodiacsConstants.zod_the_snake),
    LunarHour(code: 'canh ngo', ZodiacsConstants.zod_the_horse),
    LunarHour(code: 'tan mui', ZodiacsConstants.zod_the_goat),
    LunarHour(code: 'nham than', ZodiacsConstants.zod_the_monkey),
    LunarHour(code: 'quy dau', ZodiacsConstants.zod_the_rooster),
    LunarHour(code: 'giap tuat', ZodiacsConstants.zod_the_dog),
    LunarHour(code: 'at hoi', ZodiacsConstants.zod_the_pig),
    LunarHour(code: 'binh tys', ZodiacsConstants.zod_the_rat),
    LunarHour(code: 'dinh suu', ZodiacsConstants.zod_the_ox),
    LunarHour(code: 'mau dan', ZodiacsConstants.zod_the_tiger),
    LunarHour(code: 'ky mao', ZodiacsConstants.zod_the_cat),
    LunarHour(code: 'canh thin', ZodiacsConstants.zod_the_dragon),
    LunarHour(code: 'tan tyj', ZodiacsConstants.zod_the_snake),
    LunarHour(code: 'nham ngo', ZodiacsConstants.zod_the_horse),
    LunarHour(code: 'quy mui', ZodiacsConstants.zod_the_goat),
    LunarHour(code: 'giap than', ZodiacsConstants.zod_the_monkey),
    LunarHour(code: 'at dau', ZodiacsConstants.zod_the_rooster),
    LunarHour(code: 'binh tuat', ZodiacsConstants.zod_the_dog),
    LunarHour(code: 'dinh hoi', ZodiacsConstants.zod_the_pig),
    LunarHour(code: 'mau tys', ZodiacsConstants.zod_the_rat),
    LunarHour(code: 'ky suu', ZodiacsConstants.zod_the_ox), // kỷ sửu
    LunarHour(code: 'canh dan', ZodiacsConstants.zod_the_tiger),
    LunarHour(code: 'tan mao', ZodiacsConstants.zod_the_cat),
    LunarHour(code: 'nham thin', ZodiacsConstants.zod_the_dragon),
    LunarHour(code: 'quy tyj', ZodiacsConstants.zod_the_snake),
    LunarHour(code: 'giap ngo', ZodiacsConstants.zod_the_horse),
    LunarHour(code: 'at mui', ZodiacsConstants.zod_the_goat),
    LunarHour(code: 'binh than', ZodiacsConstants.zod_the_monkey),
    LunarHour(code: 'dinh dau', ZodiacsConstants.zod_the_rooster),
    LunarHour(code: 'mau tuat', ZodiacsConstants.zod_the_dog),
    LunarHour(code: 'ky hoi', ZodiacsConstants.zod_the_pig),
    LunarHour(code: 'canh tys', ZodiacsConstants.zod_the_rat),
    LunarHour(code: 'tan suu', ZodiacsConstants.zod_the_ox), // tân sửu
    LunarHour(code: 'nham dan', ZodiacsConstants.zod_the_tiger),
    LunarHour(code: 'quy mao', ZodiacsConstants.zod_the_cat),
    LunarHour(code: 'giap thin', ZodiacsConstants.zod_the_dragon),
    LunarHour(code: 'at tyj', ZodiacsConstants.zod_the_snake),
    LunarHour(code: 'binh ngo', ZodiacsConstants.zod_the_horse),
    LunarHour(code: 'dinh mui', ZodiacsConstants.zod_the_goat),
    LunarHour(code: 'mau than', ZodiacsConstants.zod_the_monkey),
    LunarHour(code: 'ky dau', ZodiacsConstants.zod_the_rooster),
    LunarHour(code: 'canh tuat', ZodiacsConstants.zod_the_dog),
    LunarHour(code: 'tan hoi', ZodiacsConstants.zod_the_pig),
    LunarHour(code: 'nham tys', ZodiacsConstants.zod_the_rat),
    LunarHour(code: 'quy suu', ZodiacsConstants.zod_the_ox),
    LunarHour(code: 'giap dan', ZodiacsConstants.zod_the_tiger),
    LunarHour(code: 'at mao', ZodiacsConstants.zod_the_cat),
    LunarHour(code: 'binh thin', ZodiacsConstants.zod_the_dragon),
    LunarHour(code: 'dinh tyj', ZodiacsConstants.zod_the_snake),
    LunarHour(code: 'mau ngo', ZodiacsConstants.zod_the_horse),
    LunarHour(code: 'ky mui', ZodiacsConstants.zod_the_goat),
    LunarHour(code: 'canh than', ZodiacsConstants.zod_the_monkey),
    LunarHour(code: 'tan dau', ZodiacsConstants.zod_the_rooster),
    LunarHour(code: 'nham tuat', ZodiacsConstants.zod_the_dog),
    LunarHour(code: 'quy hoi', ZodiacsConstants.zod_the_pig),
  ];
  static List<String> allOfThingsData = [
    "trong-cay",
    "khoi-cong",
    "sua-chua",
    "pha-do",
    "dong-tho",
    "do-mong",
    "do-mai",
    "cat-noc",
    "mo-cong",
    "boi-hoan-long-mach",
    "nhap-trach",
    "ta-dat",
    "khanh-thanh",
    "khai-truong",
    "mo-cua-hang",
    "chuyen-nha",
    "ban-nha",
    "dap-dap",
    "ngan-de",
    "dao-gieng",
    "lap-gieng",
    'ngay-nham-chuc',
    'ngay-nhan-cong-viec-moi',
    'ngay-ra-mat-san-pham',
    'giao-dich',
    'chuyen-vi-tri-ban-tho',
    'boc-bat-huong',
    'tu-tao-lai-ban-tho',
    'them-bat-huong',
    'thay-ban-tho',
    'giai-xa-ban-tho',
    'ngay-an-hoi',
    'ngay-lai-mat',
    'ngay-dam-ngo',
    'ngay-cuoi',
    "dong-tho-xay-ho",
    "dao-mo-cu-mo-lap-van",
    "ha-tieu",
    "dung-bia",
    "ta-mo",
    "sua-mo",
  ];
  static const String extrabold = 'ExtraBold';
  static const String semibold = 'SemiBold';
  static const String comfortaa = 'Comfor';
  static const String manrope = 'Manrope';
  static const String nunito = 'Nunito';
  static String orderID = '';
  static const int emailType = 1;
  static const int phoneType = 2;
  static const int signUpOtp = 1;
  static const int forgotPasswordOtp = 2;
  static const int dialogFail = 1;
  static const int dialogSuccess = 2;
  static const int dialogDelete = 3;
  static const int incomingUp = 4;
  static const int inconnect = 5;
  static const int maxWidthByDesign = 375;
  static const int maxHeightByDesign = 812;
  static const int refund = 6;
  static const int gift = 7;
  static const dateFormat = 'dd MMM yyyy';
  static const statusEnable = 'enable';
  static const statusDisable = 'disable';
  static const statusDeposited = 'deposited';
  static const vnd = '₫';
  static const int signInPhone = 0;
  static const int signInFB = 1;
  static const int signInGG = 2;
  static const int signInApple = 3;
  static const int signInLinkedIn = 4;
  static const int zeroIdx = 0;
  static const int firstIdx = 1;
  static const int secondIdx = 2;
  static const int thirdIdx = 3;

  static const List<Color> surveyQuestion = [
    Color(0xFF8A4026),
    Color(0xFF966D32),
    Color(0xFFA78041),
    Color(0xFFBA9653),
    Color(0xFFD8B870),
    Color(0xFFE4C67B),
    Color(0xFFDBB565),
    Color(0xFFD9B160),
    Color(0xFFD2A550),
    Color(0xFFD0A14B),
    Color(0xFFD5A750),
    Color(0xFFDDB258),
    Color(0xFFE4BD61),
    Color(0xFFF4D576),
    Color(0xFFF8E881),
    Color(0xFFF2DF7B),
    Color(0xFFE7C969),
    Color(0xFFE3C263),
    Color(0xFFF0D35A),
    Color(0xFFF9DF58),
    Color(0xFFEFD052),
    Color(0xFFDBB640),
    Color(0xFFD2AA38),
    Color(0xFFC69930),
    Color(0xFFC1932D),
    Color(0xFFC59833),
    Color(0xFFD2A744),
    Color(0xFFEAC565),
    Color(0xFFDCB755),
    Color(0xFFD5AF4C),
    Color(0xFFCBA542),
  ];

  static List<double> stopsSurveyQuestion = [
    0.0, // #8A4026 -10.92%
    0.02, // #966D32 -9.61%
    0.04, // #A78041 -7%
    0.06, // #BA9653 -5.69%
    0.10, // #D8B870 -0.46%
    0.12, // #E4C67B 0.85%
    0.15, // #DBB565 4.77%
    0.17, // #D9B160 6.08%
    0.20, // #D2A550 10%
    0.23, // #D0A14B 12.62%
    0.27, // #D5A750 16.54%
    0.31, // #DDB258 20.46%
    0.35, // #E4BD61 24.39%
    0.41, // #F4D576 29.62%
    0.48, // #F8E881 37.46%
    0.52, // #F2DF7B 41.39%
    0.59, // #E7C969 47.93%
    0.63, // #E3C263 51.85%
    0.70, // #F0D35A 59.69%
    0.75, // #F9DF58 64.92%
    0.80, // #EFD052 70.16%
    0.88, // #DBB640 79.31%
    0.92, // #D2AA38 85.85%
    0.97, // #C69930 92.39%
    0.99, // #C1932D 98.92%
    1.0, // #C59833 100.23% ~ 100%
    1.01, // #D2A744 104.15%
    1.05, // #EAC565 106.77%
    1.08, // #DCB755 110.69%
    1.10, // #D5AF4C 113.31%
    1.13, // #CBA542 115.92%
  ];

  static const List<Color> gradientsNameTop1 = [
    Color(0xFF8A4026),
    Color(0xFF966D32),
    Color(0xFFA78041),
    Color(0xFFBA9653),
    Color(0xFFD8B870),
    Color(0xFFE4C67B),
    Color(0xFFDBB565),
    Color(0xFFD9B160),
    Color(0xFFD2A550),
    Color(0xFFD0A14B),
    Color(0xFFD5A750),
    Color(0xFFDDB258),
    Color(0xFFD2AA38),
    Color(0xFFC69930),
    Color(0xFFC1932D),
    Color(0xFFC59833),
    Color(0xFFD2A744),
    Color(0xFFEAC565),
    Color(0xFFDCB755),
    Color(0xFFD5AF4C),
    Color(0xFFCBA542),
  ];

  static List<Color> titleCategoryGradient = [
    const Color(0xFFA78041),
    const Color(0xFFBA9653),
    const Color(0xFFD8B870),
    const Color(0xFFE4C67B),
    const Color(0xFFDBB565),
    const Color(0xFFD9B160),
    const Color(0xFFD2A550),
    const Color(0xFFD0A14B),
    const Color(0xFFD5A750),
    const Color(0xFFDDB258),
    const Color(0xFFE4BD61),
    const Color(0xFFF4D576),
    const Color(0xFFF8E4A2),
    const Color(0xFFFBE194),
    const Color(0xFFF0D35A),
    const Color(0xFFDAC771),
    const Color(0xFFD2A744),
    const Color(0xFFEAC565),
    const Color(0xFFDCB755),
    const Color(0xFFD5AF4C),
    const Color(0xFFCBA542),
  ];

  static List<double> stopsTitleCategoryGradient = [
    0.0, // -13.45% → tương ứng 0.0
    0.01, // -12.26%
    0.03, // -9.87%
    0.04, // -8.68%
    0.10, // -3.91%
    0.11, // -2.72%
    0.13, // 0.86%
    0.14, // 2.06%
    0.17, // 5.63%
    0.19, // 8.02%
    0.22, // 11.6%
    0.25, // 15.18%
    0.28, // 18.76%
    0.33, // 23.53%
    0.41, // 30.69%
    0.45, // 34.27%
    0.51, // 40.23%
    0.55, // 43.81%
    0.61, // 50.97%
    0.66, // 55.74%
    0.75, // 68.19%
    0.89, // 84.23%
    0.93, // 92.99%
    0.94, // 93.92%
    0.98, // 97.5%
    1.0, // 99.88%
    1.02, // 102.27% → sẽ được tự động giới hạn ở 1.0 trong Flutter
  ];

  static List<Color> strokeCategoryGradient = [
    const Color(0xFFC3962E),
    const Color.fromARGB(255, 142, 93, 23),
    const Color(0xFF996D1D),
    const Color(0xFFD09B2F),
    const Color(0xFFF2B73A),
    const Color(0xFFFFC23F),
    const Color(0xFFB07520),
    const Color(0xFFBF9700),
    const Color(0xFFCEAD35),
    const Color(0xFFFFC23F),
  ];

  static List<double> stopsStrokeCategoryGradient = [
    0.1957,
    0.2207,
    0.3041,
    0.3791,
    0.4291,
    0.4624,
    0.5708,
    0.7374,
    0.8708,
    0.8791,
    0.8874,
    0.8958,
    0.9041,
    0.9124,
    0.9458,
    1.0,
  ];

  static const List<Color> borderLightYellow = [
    Color(0xFFE0D6AE), // 0%
    Color(0xFFE0D6AE), // 50%
    Color(0xFFC1A55E), // 100%
  ];

  static List<double> gradientStopsNameTop1 = [
    -0.6917,
    -0.6731,
    -0.6357,
    -0.617,
    -0.5423,
    -0.5236,
    -0.4676,
    -0.4489,
    -0.3929,
    -0.3555,
    -0.2994,
    -0.2434,
    0.6906,
    0.784,
    0.8774,
    0.8961,
    0.9522,
    0.9895,
    1.0456,
    1.0829,
    1.1203,
  ];

  static const List<Color> gradientsNameTop2 = [
    Color(0xFFFFFFFF),
    Color(0xFFD8D8D8),
    Color(0xFFFFFFFF),
    Color(0xFFE6E6E6),
    Color(0xFFFFFFFF),
    Color(0xFFEEEEEE),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
    Color(0xFFFCFCFC),
    Color(0xFFFFFFFF),
  ];

  static const List<Color> gradientsPoint = [
    /*
    background: linear-gradient(89.98deg, #E4C23A 26.14%, #BB9F31 45.37%, #FFE786 53.79%, #FFB472 61.96%, #FFDE5C 70.56%, #997A00 88.03%);
background-blend-mode: overlay;
background: #4F1A0461;

     */
    Color(0xFFE4C23A),
    Color(0xFFBB9F31),
    Color(0xFFFFE786),
    Color(0xFFFFB472),
    Color(0xFFFFDE5C),
    Color(0xFF997A00),
  ];
  static List<double> gradientStopsNameTop2 = [
    0.1769,
    0.2052,
    0.2476,
    0.2752,
    0.3489,
    0.4271,
    0.492,
    0.5316,
    0.6415,
    0.6826,
    0.7229,
  ];

  static const List<Color> gradientsNameTop3 = [
    Color(0xFFDB7428), // Màu cam
    Color(0xFFDB7428), // Màu cam (tương tự)
    Color(0xFF000000), // Màu đen mờ (tạm gọi là 0.2 alpha)
  ];

  static List<double> gradientStopsNameTop3 = [
    0.0, // Màu cam bắt đầu
    0.5, // Màu cam giữa
    1.0, // Màu đen mờ kết thúc
  ];

  static const List<Color> btnCalendarGradient = [
    Color(0xff8A4026),
    Color(0xff966D32),
    Color(0xffA78041),
    Color(0xffBA9653),
    Color(0xffD8B870),
    Color(0xffE4C67B),
    Color(0xffDBB565),
    Color(0xffD9B160),
    Color(0xffFDF4B8),
    Color(0xffF8E4A2),
    Color(0xffFBE194),
    Color(0xffFDEFA8),
    Color(0xffFFE98E),
    Color(0xffD5AF4C),
    Color(0xffCBA542),
  ];

  static List<Color> borderReplyAI = [
    const Color(0xFF08D4EB).withAlpha((0.0 * 255).toInt()),
    const Color(0xFFB4FEF1),
    const Color(0xFFEBFEFB),
    const Color(0xFF91FFED).withAlpha((0.0 * 255).toInt()),
  ];
  static const List<Color> selectDateGradient = [
    Color(0xFF8A4026),
    Color(0xFF966D32),
    Color(0xFFA78041),
    Color(0xFFBA9653),
    Color(0xFFD8B870),
    Color(0xFFE4C67B),
    Color(0xFFDBB565),
    Color(0xFFD9B160),
    Color(0xFFD2A550),
    Color(0xFFD0A14B),
    Color(0xFFD5A750),
    Color(0xFFDDB258),
    Color(0xFFE4BD61),
    Color(0xFFF4D576),
    Color(0xFFF8E881),
    Color(0xFFF2DF7B),
    Color(0xFFE7C969),
    Color(0xFFE3C263),
    Color(0xFFF0D35A),
    Color(0xFFF9DF58),
    Color(0xFFEFD052),
    Color(0xFFDBB640),
    Color(0xFFD2AA38),
    Color(0xFFC69930),
    Color(0xFFC1932D),
    Color(0xFFC59833),
    Color(0xFFD2A744),
    Color(0xFFEAC565),
  ];

  static List<double> selectedCalendarStops = [
    0.0,
    0.03,
    0.06,
    0.09,
    0.12,
    0.15,
    0.18,
    0.21,
    0.24,
    0.27,
    0.30,
    0.34,
    0.38,
    0.42,
    0.46,
    0.50,
    0.55,
    0.60,
    0.65,
    0.70,
    0.75,
    0.80,
    0.85,
    0.88,
    0.90,
    0.92,
    0.94,
    0.96,
  ];

  static const List<Color> gradientsText = [
    Color(0xffF2DF7B),
    Color(0xffF4D576),
    Color(0xffDBB565),
    Color(0xffEFCE52),
    Color(0xffD2AA38),
    Color(0xffD8B870),
    Color(0xffE4C67B),
    Color(0xffDBB565),
    Color(0xffE7C969),
    Color(0xffE3C263),
    Color(0xffF0D35A),
    Color(0xffF9DF58),
    Color(0xffEFD052),
    Color(0xffDBB640),
    Color(0xffD2AA38),
    Color(0xffEAC565),
    Color(0xffDCB755),
    Color(0xffD5AF4C),
  ];
  static const List<Color> gradientsBtn = [
    Color(0xffF2DF7B),
    Color(0xffF4D576),
    Color(0xffD2AA38),
    Color(0xffD0A14B),
    Color(0xffF2DF7B),
    Color(0xffE7C969),
    Color(0xffE3C263),
    Color(0xffF0D35A),
    Color(0xffF9DF58),
    Color(0xffEFD052),
    Color(0xffDBB640),
    Color(0xffD2AA38),
    Color(0xffC59833),
    Color(0xffD5AF4C),
    Color.fromARGB(255, 255, 196, 46),
  ];
  static const List<Color> homeMenu = [
    Color.fromARGB(255, 242, 206, 98),
    Color(0xffF4D576),
    Color(0xffF4D576),
    Color.fromARGB(255, 232, 183, 58),
  ];
  static const List<Color> name = [
    Color(0xffF2DF7B),
    Color(0xffF4D576),
    Color(0xffDBB565),
    Color(0xffDBB565),
  ];
  static const List<Color> title = [
    Color(0xffF4D576),
    Color(0xffDBB565),
    Color(0xffDBB565),
  ];
  static const List<Color> gradientRed = [
    Color.fromARGB(255, 156, 33, 2),
    Color.fromARGB(255, 213, 58, 37),
    Color.fromARGB(255, 230, 25, 25),
  ];
  static const List<Color> button = [
    Color(0xffF2DF7B),
    Color(0xffF4D576),
    Color(0xffF2DF7B),
    Color(0xffE7C969),
    Color(0xffD2AA38),
  ];

  static const List<Color> gradientsLight = [
    Color(0xffF2DF7B),
    Color(0xffF4D576),
    Color(0xffDBB565),
    Color(0xffEFCE52),
    Color(0xffD2AA38),
    Color(0xffD0A14B),
    Color(0xffCBA542),
    Color(0xff8A4026),
    Color(0xff966D32),
    Color(0xffA78041),
    Color(0xffBA9653),
    Color(0xffD8B870),
    Color(0xffE4C67B),
    Color(0xffDBB565),
    Color(0xffD9B160),
    Color(0xffD2A550),
    Color(0xffD0A14B),
    Color(0xffD5A750),
    Color.fromARGB(255, 232, 200, 131),
    Color(0xffE4BD61),
    Color(0xffF4D576),
    Color(0xffF8E881),
    Color(0xffF2DF7B),
    Color(0xffE7C969),
    Color(0xffE3C263),
    Color(0xffF0D35A),
    Color(0xffF9DF58),
    Color(0xffEFD052),
    Color(0xffDBB640),
    Color(0xffD2AA38),
    Color(0xffC69930),
    Color(0xffC1932D),
    Color(0xffC59833),
    Color(0xffD2A744),
    Color(0xffEAC565),
    Color(0xffDCB755),
    Color(0xffD5AF4C),
    Color(0xffCBA542),
  ];
  static List<Color> gradientsOrange = [
    const Color(0xffc54518),
    const Color(0xFFf2994b),
    const Color(0xFFffc350),
    const Color(0xFFffa734),
    const Color(0xFFdf141b),
  ];

  static List<Color> gradientsLight50per = [
    const Color(0xffE0D6AE).withAlpha((0.5 * 255).toInt()),
    const Color(0xffE0D6AE).withAlpha((0.5 * 255).toInt()),
  ];

  static List<Color> gradientMemberBtn = [
    const Color(0xff292A2C),
    const Color(0xff000000),
  ];

  static List<Color> gradientBrownBtn = [
    const Color(0xff5C3D2B),
    const Color(0xff331F15),
  ];

  static List<Color> gradientAccountIcons = [
    const Color(0xffCC8502),
    const Color(0xff664301),
  ];
  static List<Color> gradientTextIDRankTask = [
    const Color(0xffCC8502).withAlpha(125),
    const Color(0xff664301).withAlpha(125),
  ];
  static List<Color> gradientTextInPopup = [
    AppColor.textBrownColor,
    AppColor.textBrownDark,
  ];
  static List<Color> gradientsDark = [
    AppColor.primaryColor,
    AppColor.primaryColor,
  ];
  static List<Color> gradientGreys = [
    AppColor.borderGreyColor,
    AppColor.grayTextwhiteColor.withAlpha((0.75 * 255).toInt()),
  ];
  static List<Color> gradientCalendarToday = [
    const Color(0xff8A4026),
    const Color(0xff966D32),
    const Color(0xffA78041),
    const Color(0xffBA9653),
    const Color(0xffD8B870),
    const Color(0xffE4C67B),
    const Color(0xffDBB565),
    const Color(0xffD9B160),
    const Color(0xffD2A550),
    const Color(0xffD0A14B),
    const Color(0xffD5A750),
    const Color(0xffDDB258),
    const Color(0xffE4BD61),
    const Color(0xffF4D576),
    const Color(0xffF8E881),
    const Color(0xffF2DF7B),
    const Color(0xffE7C969),
    const Color(0xffE3C263),
    const Color(0xffF0D35A),
    const Color(0xffF9DF58),
    const Color(0xffEFD052),
    const Color(0xffDBB640),
    const Color(0xffD2AA38),
    const Color(0xffC69930),
    const Color(0xffC1932D),
    const Color(0xffC59833),
    const Color(0xffD2A744),
    const Color(0xffEAC565),
    const Color(0xffDCB755),
    const Color(0xffD5AF4C),
    const Color(0xffCBA542),
  ];
  static List<Color> lightToBold = [
    const Color(0xffF2DF7B),
    const Color(0xffF4D576),
    const Color(0xffF2DF7B),
    const Color(0xffE7C969),
    const Color(0xffD2AA38),
  ];
  static List<Color> gradientstitle = [
    const Color(0xffE0D6AE),
    const Color(0xffC1A55E),
  ];
  static List<Color> gradientWhite = [
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 221, 221, 221),
  ];
  static List<Color> gradientTextWhite = [
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 255, 255, 255),
  ];
  static List<Color> gradientTextRed = [
    const Color.fromARGB(255, 202, 23, 8),
    const Color.fromARGB(255, 137, 23, 14),
  ];
  static List<Color> gradientDarkGray = [
    const Color.fromARGB(255, 169, 169, 169), // Dark Gray
    const Color.fromARGB(255, 211, 211, 211), // Light Gray
  ];
  static List<Color> gradientLightGray = [
    const Color.fromARGB(255, 240, 240, 240), // Very Light Gray
    const Color.fromARGB(255, 255, 255, 255), // White
  ];
  static List<Color> gradientGrayTab = [
    const Color(0xffF0F0F0),
    const Color(0xffD5D5D5),
    const Color(0xffF2F2F2),
  ];
  // refferal start
  static List<Color> gradientsTitleRefferal = [
    const Color(0xffE0D6AE),
    const Color(0xffE0D6AE),
    const Color(0xffC1A55E),
  ];
  static List<Color> gradientsBorderSearchVoucher = [
    const Color(0xFFC3962E),
    const Color(0xFF4E2F05),
    const Color(0xFF996D1D),
    const Color(0xFFD09B2F),
    const Color(0xFFF2B73A),
    const Color(0xFFFFC23F),
    const Color(0xFFB07520),
    const Color(0xFFFFFFFF),
    const Color(0xFFBF9700),
    const Color(0xFFF0DFAC),
    const Color(0xFFE7D18B),
    const Color(0xFFD8BC5A),
    const Color(0xFFD4B549),
    const Color(0xFFD0B03D),
    const Color(0xFFCEAD36),
    const Color(0xFFCEAD35),
    const Color(0xFFFFC23F),
  ];

  static List<Color> gradientsBorderMenuOptionTask = [
    const Color(0xFFCC8502),
    const Color(0xFF664301),
  ];

  static List<Color> gradientsBorderBottomNavTask = [
    const Color(0x00F0D35A), // rgba(240, 211, 90, 0)
    const Color(0xFFF0D35A), // #F0D35A
    const Color(0xFFF9DF58), // #F9DF58
    const Color(0xFFEFD052), // #EFD052
    const Color(0xFFDBB640), // #DBB640
    const Color(0xFFD2AA38), // #D2AA38
    const Color(0xFFC69930), // #C69930
    const Color(0xFFC1932D), // #C1932D
    const Color(0xFFC59833), // #C59833
    const Color(0xFFD2A744), // #D2A744
    const Color(0xFFEAC565), // #EAC565
    const Color(0xFFDCB755), // #DCB755
    const Color(0xFFD5AF4C), // #D5AF4C
    const Color(0xFFCBA542), // #CBA542
  ];
  static List<Color> gradientsBgTapbarRefferal = [
    const Color(0xffF0F0F0),
    const Color(0xffD5D5D5),
    const Color(0xffF2F2F2),
  ];
  static List<Color> gradientBGCodeRefferal = [
    const Color(0xffBA9653),
    const Color(0xffD8B870),
    const Color(0xffE4C67B),
    const Color(0xffDBB565),
    const Color(0xffD9B160),
    const Color(0xffD2A550),
    const Color(0xffD0A14B),
    const Color(0xffD5A750),
    const Color(0xffDDB258),
    const Color(0xffE4BD61),
    const Color(0xffF4D576),
    const Color(0xffF8E881),
    const Color(0xffF2DF7B),
    const Color(0xffE7C969),
    const Color(0xffE3C263),
    const Color(0xffF0D35A),
    const Color(0xffF9DF58),
    const Color(0xffEFD052),
    const Color(0xffDBB640),
    const Color(0xffD2AA38),
    const Color(0xffC69930),
    const Color(0xffC1932D),
    const Color(0xffC59833),
    const Color(0xffD2A744),
    const Color(0xffEAC565),
    const Color(0xffDCB755),
    const Color(0xffD5AF4C),
    const Color(0xffCBA542),
  ];
  // Birthday AI
  static List<Color> gradientBGBirthdayCard = [
    const Color(0xFF805A22), // #805A22
    const Color(0xFFF9E785), // #F9E785
    const Color(0xFFDEC267), // #DEC267
    const Color(0xFFB58837), // #B58837
    const Color(0xFF9A6419), // #9A6419
    const Color(0xFF91570E), // #91570E
    const Color(0xFFA37023), // #A37023
    const Color(0xFFCEAB53), // #CEAB53
    const Color(0xFFDDC166), // #DDC166
    const Color(0xFFEAD274), // #EAD274
    const Color(0xFFF2DE7D), // #F2DE7D
    const Color(0xFFF7E583), // #F7E583
    const Color(0xFFF9E785), // #F9E785
    const Color(0xFFF9E682), // #F9E682
    const Color(0xFFFAE67A), // #FAE67A
    const Color(0xFFFBE56D), // #FBE56D
    const Color(0xFFFDE459), // #FDE459
    const Color(0xFFFFE44D), // #FFE44D
    const Color(0xFF916025), // #916025
    const Color(0xFFA07433), // #A07433
    const Color(0xFFC9A959), // #C9A959
    const Color(0xFFF9E785), // #F9E785
  ];

  static List<double> gradientStopsBGBirthdayCard = [
    0.0, // -3.84%
    0.397, // 39.7%
    0.5058, // 50.58%
    0.7235, // 72.35%
    0.8595, // 85.95%
    0.9411, // 94.11%
    0.9683, // 96.83%
    0.9955, // 99.55%
    1.05, // 105%
    1.0772, // 107.72%
    1.1044, // 110.44%
    1.186, // 118.6%
    1.322, // 132.2%
    1.4853, // 148.53%
    1.5669, // 156.69%
    1.6485, // 164.85%
    1.7029, // 170.29%
    1.7302, // 173.02%
    2.2199, // 221.99%
    2.3015, // 230.15%
    2.492, // 249.2%
    2.6824, // 268.24%
  ];

  static List<Color> gradientBorderBirthdayCard = [
    const Color(0xFF805A22),
    const Color(0xFFF9E785),
    const Color(0xFFDEC267),
    const Color(0xFFB58837),
    const Color(0xFF9A6419),
    const Color(0xFF91570E),
    const Color(0xFFA37023),
    const Color(0xFFCEAB53),
    const Color(0xFFDDC166),
    const Color(0xFFEAD274),
    const Color(0xFFF2DE7D),
    const Color(0xFFF7E583),
    const Color(0xFFF9E785),
    const Color(0xFFF9E682),
    const Color(0xFFFAE67A),
    const Color(0xFFFBE56D),
    const Color(0xFFFDE459),
    const Color(0xFFFFE44D),
    const Color(0xFF916025),
    const Color(0xFFA07433),
    const Color(0xFFC9A959),
    const Color(0xFFF9E785),
  ];

  static List<Color> gradientBorderCard = [
    const Color(0xFFC3962E),
    const Color(0xFF4E2F05),
    const Color(0xFF996D1D),
    const Color(0xFFD09B2F),
    const Color(0xFFF2B73A),
    const Color(0xFFFFC23F),
    const Color(0xFFB07520),
    const Color(0xFFFFFFFF),
    const Color(0xFFBF9700),
    const Color(0xFFF0DFAC),
    const Color(0xFFE7D18B),
    const Color(0xFFD8BC5A),
    const Color(0xFFD4B549),
    const Color(0xFFD0B03D),
    const Color(0xFFCEAD36),
    const Color(0xFFCEAD35),
    const Color(0xFFFFC23F),
  ];

  static List<Color> gradientButton = [
    const Color(0xFFC3962E),
    const Color(0xFF4E2F05),
    const Color(0xFF996D1D),
    const Color(0xFFD09B2F),
    const Color(0xFFF2B73A),
    const Color(0xFFFFC23F),
    const Color(0xFFB07520),
    const Color(0xFFFFFFFF),
    const Color(0xFFBF9700),
    const Color(0xFFF0DFAC),
    const Color(0xFFE7D18B),
    const Color(0xFFD8BC5A),
    const Color(0xFFD4B549),
    const Color(0xFFD0B03D),
    const Color(0xFFCEAD36),
    const Color(0xFFCEAD35),
    const Color(0xFFFFC23F),
  ];
  //background: linear-gradient(359.84deg, #690F07 -26.06%, #82170A -1.61%, #A8230E 44.85%, #C52C11 91.3%, #DB3313 135.31%, #E83715 176.87%, #EC3815 218.44%);

  static List<Color> gradientRedText = [
    const Color(0xFF690F07),
    const Color(0xFF82170A),
    const Color(0xFFA8230E),
    const Color(0xFFC52C11),
    const Color(0xFFDB3313),
    const Color(0xFFE83715),
    const Color(0xFFEC3815),
  ];
  //background: linear-gradient(180deg, #5C3D2B 0%, #331F15 100%);
  static List<Color> gradientBrownText = [
    const Color(0xFF5C3D2B),
    const Color(0xFF331F15),
  ];
  //background: linear-gradient(90deg, #F0F0F0 0%, #D5D5D5 42%, #F2F2F2 100%);
  static List<Color> buttonGrey = [
    const Color(0xFFD5D5D5),
    const Color(0xFFF0F0F0),
    const Color(0xFFD5D5D5),
    const Color(0xFFF2F2F2),
  ];

  static List<Color> gradientBirthdayCard = [
    const Color(0xFF452D23).withAlpha(0),
    const Color(0xFF452D23).withAlpha(100),
    const Color(0xFF452D23).withAlpha(150),
    const Color(0xFF452D23).withAlpha(200),
    const Color(0xFF452D23),
    const Color(0xFF452D23),
  ];

  static List<Color> gradientBorderAI = [
    const Color.fromRGBO(15, 177, 183, 0.154),
    const Color.fromRGBO(15, 177, 183, 0.1188),
    const Color.fromRGBO(15, 177, 183, 0.077),
    const Color.fromRGBO(15, 177, 183, 0.0462),
    const Color.fromRGBO(15, 177, 183, 0.0286),
    const Color.fromRGBO(15, 177, 183, 0.022),
  ];

  static List<Color> gradientRanking = [
    // ignore: deprecated_member_use
    const Color(0xFFE0D6AE).withAlpha((0.25 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xFFE0D6AE).withAlpha((0.15 * 255).toInt()),
  ];

  static List<Color> gradientRankingTop3 = [
    // ignore: deprecated_member_use
    const Color(0xFFE0D6AE).withAlpha((0.5 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xFFE0D6AE).withAlpha((0.45 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xFFC1A55E).withAlpha((0.05 * 255).toInt()),
  ];
  static List<Color> gradientRankingTop2 = [
    // ignore: deprecated_member_use
    const Color(0xFFD26138).withAlpha((0.1 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xFFF89C7B).withAlpha((0.4 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xFF9F3609).withAlpha((0.05 * 255).toInt()),
  ];
  static List<Color> gradientRankingTop1 = [
    // ignore: deprecated_member_use
    const Color(0xFFDCB755).withAlpha((0.05 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xFFEBD26D).withAlpha((0.65 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xFFEDD670).withAlpha((0.75 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xFFF8E881).withAlpha((0.1 * 255).toInt()),
  ];
  static List<Color> gradientBorderRanking = [
    // ignore: deprecated_member_use
    const Color(0xFFE1D7B0).withAlpha(0),
    // ignore: deprecated_member_use
    const Color(0xFFE1D7B0),
  ];

  /*
background: #269BB9;

   */
  static List<Color> gradientTextTab = [
    // ignore: deprecated_member_use
    const Color(0xFFB17813),
    // ignore: deprecated_member_use
    const Color(0xFFB57B13),
    // ignore: deprecated_member_use
    const Color(0xFFB67B13),
    // ignore: deprecated_member_use
    const Color(0xFFB77C13),
    // ignore: deprecated_member_use
  ];
  static List<Color> gradientBrown = [
    // ignore: deprecated_member_use
    const Color(0xFFB17813),
    // ignore: deprecated_member_use
    // ignore: deprecated_member_use
    // ignore: deprecated_member_use
    const Color.fromARGB(255, 119, 80, 12),

    const Color(0xFFB17813),

    // ignore: deprecated_member_use
  ];
  static List<Color> gradientLineRanking = [
    // ignore: deprecated_member_use
    const Color(0xFFDCB755).withAlpha((0.0 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xFFF8E881),
    // ignore: deprecated_member_use
    const Color(0xFFF8E881).withAlpha((0.0 * 255).toInt()),
  ];
  // refferal end
  static String affCode = '';
  static String appsflyerId = 'v7UpMPo8TcUSVZUr5tTbgm';
  static String iosAppId = '6504331040';
  static String voucherCode = '';
  static String moneyUnit = '₫';
  static bool isAccountCheck = false;
  static List<Color> colorItemsTableMatrixQimen = [
    // ignore: deprecated_member_use
    AppColor.colorGreenDark.withAlpha((0.85 * 255).toInt()),
    // ignore: deprecated_member_use
    AppColor.colorRed.withAlpha((0.85 * 255).toInt()),
    // ignore: deprecated_member_use
    AppColor.brownLight.withAlpha((0.85 * 255).toInt()),
    // ignore: deprecated_member_use
    AppColor.colorGreenDark.withAlpha((0.85 * 255).toInt()),
    // ignore: deprecated_member_use
    AppColor.brownLight.withAlpha((0.85 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xffDCDCDC).withAlpha((0.5 * 255).toInt()),
    // ignore: deprecated_member_use
    AppColor.brownLight.withAlpha((0.85 * 255).toInt()),
    // ignore: deprecated_member_use
    AppColor.colorBlueLight.withAlpha((0.85 * 255).toInt()),
    // ignore: deprecated_member_use
    const Color(0xffDCDCDC).withAlpha((0.5 * 255).toInt()),
  ];
  static List<Color> colorsPicker = [
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.yellowAccent,
    Colors.blue,
    Colors.grey,
    Colors.indigo,
    Colors.deepOrangeAccent,
    Colors.tealAccent,
    Colors.pink,
    Colors.amber,
    Colors.deepPurple,
    Colors.brown,
    Colors.cyan,
    Colors.lime,
    Colors.orange,
    Colors.purple,
    Colors.blueGrey,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.limeAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.teal,
    Colors.yellow,
    Colors.black,
    Colors.blueAccent,
    Colors.cyanAccent,
    Colors.deepOrange,
    Colors.deepPurpleAccent,
    Colors.greenAccent,
    Colors.indigoAccent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.limeAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.tealAccent,
    const Color.fromARGB(255, 172, 100, 41),
    Colors.amberAccent,
    const Color.fromARGB(255, 1, 115, 39),
    Colors.grey.shade800,
    Colors.grey.shade600,
    Colors.grey.shade400,
    Colors.brown.shade900,
    Colors.brown.shade700,
    Colors.brown.shade500,
  ];
  static List<DireCoor> get lstDireCoor => [
    DireCoor(
      title: 'tys'.tr,
      degree: '0\u00B0',
      code: 'ngo',
      titleDirection: '(${'north'.tr})',
      codeDirection: '(${'south'.tr})',
    ),
    DireCoor(
      title: 'quy'.tr,
      degree: '15\u00B0',
      code: 'dinh',
      titleDirection: '(${'north'.tr})',
      codeDirection: '(${'south'.tr})',
    ),
    DireCoor(
      title: 'suu'.tr,
      degree: '30\u00B0',
      code: 'mui',
      titleDirection: '(${'north-east'.tr})',
      codeDirection: '(${'south-west'.tr})',
    ),
    DireCoor(
      title: 'cans'.tr,
      degree: '45\u00B0',
      code: 'khon',
      titleDirection: '(${'north-east'.tr})',
      codeDirection: '(${'south-west'.tr})',
    ),
    DireCoor(
      title: 'dan'.tr,
      degree: '60\u00B0',
      code: 'than',
      titleDirection: '(${'north-east'.tr})',
      codeDirection: '(${'south-west'.tr})',
    ),
    DireCoor(
      title: 'giap'.tr,
      degree: '75\u00B0',
      code: 'canh',
      titleDirection: '(${'east'.tr})',
      codeDirection: '(${'west'.tr})',
    ),
    DireCoor(
      title: 'mao'.tr,
      degree: '90\u00B0',
      code: 'dau',
      titleDirection: '(${'east'.tr})',
      codeDirection: '(${'west'.tr})',
    ),
    DireCoor(
      title: 'at'.tr,
      degree: '105\u00B0',
      code: 'tan',
      titleDirection: '(${'east'.tr})',
      codeDirection: '(${'west'.tr})',
    ),
    DireCoor(
      title: 'thin'.tr,
      degree: '120\u00B0',
      code: 'tuat',
      titleDirection: '(${'south-east'.tr})',
      codeDirection: '(${'north-west'.tr})',
    ),
    DireCoor(
      title: 'ton'.tr,
      degree: '135\u00B0',
      code: 'canf',
      titleDirection: '(${'south-east'.tr})',
      codeDirection: '(${'north-west'.tr})',
    ),
    DireCoor(
      title: 'tyj'.tr,
      degree: '150\u00B0',
      code: 'hoi',
      titleDirection: '(${'south-east'.tr})',
      codeDirection: '(${'north-west'.tr})',
    ),
    DireCoor(
      title: 'binh'.tr,
      degree: '165\u00B0',
      code: 'nham',
      titleDirection: '(${'south'.tr})',
      codeDirection: '(${'north'.tr})',
    ),
    DireCoor(
      title: 'ngo'.tr,
      degree: '180\u00B0',
      code: 'tys',
      titleDirection: '(${'south'.tr})',
      codeDirection: '(${'north'.tr})',
    ),
    DireCoor(
      title: 'dinh'.tr,
      degree: '195\u00B0',
      code: 'quy',
      titleDirection: '(${'south'.tr})',
      codeDirection: '(${'north'.tr})',
    ),
    DireCoor(
      title: 'mui'.tr,
      degree: '210\u00B0',
      code: 'suu',
      titleDirection: '(${'south-west'.tr})',
      codeDirection: '(${'north-east'.tr})',
    ),
    DireCoor(
      title: 'khon'.tr,
      degree: '225\u00B0',
      code: 'cans',
      titleDirection: '(${'south-west'.tr})',
      codeDirection: '(${'north-east'.tr})',
    ),
    DireCoor(
      title: 'than'.tr,
      degree: '240\u00B0',
      code: 'dan',
      titleDirection: '(${'south-west'.tr})',
      codeDirection: '(${'north-east'.tr})',
    ),
    DireCoor(
      title: 'canh'.tr,
      degree: '255\u00B0',
      code: 'giap',
      titleDirection: '(${'west'.tr})',
      codeDirection: '(${'east'.tr})',
    ),
    DireCoor(
      title: 'dau'.tr,
      degree: '270\u00B0',
      code: 'mao',
      titleDirection: '(${'west'.tr})',
      codeDirection: '(${'east'.tr})',
    ),
    DireCoor(
      title: 'tan'.tr,
      degree: '285\u00B0',
      code: 'at',
      titleDirection: '(${'west'.tr})',
      codeDirection: '(${'east'.tr})',
    ),
    DireCoor(
      title: 'tuat'.tr,
      degree: '300\u00B0',
      code: 'thin',
      titleDirection: '(${'north-west'.tr})',
      codeDirection: '(${'south-east'.tr})',
    ),
    DireCoor(
      title: 'canf'.tr,
      degree: '315\u00B0',
      code: 'ton',
      titleDirection: '(${'north-west'.tr})',
      codeDirection: '(${'south-east'.tr})',
    ),
    DireCoor(
      title: 'hoi'.tr,
      degree: '330\u00B0',
      code: 'tyj',
      titleDirection: '(${'north-west'.tr})',
      codeDirection: '(${'south-east'.tr})',
    ),
    DireCoor(
      title: 'nham'.tr,
      degree: '345 \u00B0',
      code: 'binh',
      titleDirection: '(${'north'.tr})',
      codeDirection: '(${'south'.tr})',
    ),
  ];

  static DireCoor? findByDegree(int degree) {
    for (var direCoor in lstDireCoor) {
      if (direCoor.degree == '$degree\u00B0') {
        return direCoor;
      }
    }
    return null; // Return null if no matching degree is found
  }

  static final vietnameseToChineseZodiac = {
    'Giáp Tý': '甲子',
    'Giáp Dần': '甲寅',
    'Giáp Thìn': '甲辰',
    'Giáp Ngọ': '甲午',
    'Giáp Thân': '甲申',
    'Giáp Tuất': '甲戌',
    'Ất Sửu': '乙丑',
    'Ất Mão': '乙卯',
    'Ất Tỵ': '乙巳',
    'Ất Mùi': '乙未',
    'Ất Dậu': '乙酉',
    'Ất Hợi': '乙亥',
    'Bính Tý': '丙子',
    'Bính Dần': '丙寅',
    'Bính Thìn': '丙辰',
    'Bính Ngọ': '丙午',
    'Bính Thân': '丙申',
    'Bính Tuất': '丙戌',
    'Đinh Sửu': '丁丑',
    'Đinh Mão': '丁卯',
    'Đinh Tỵ': '丁巳',
    'Đinh Mùi': '丁未',
    'Đinh Dậu': '丁酉',
    'Đinh Hợi': '丁亥',
    'Mậu Tý': '戊子',
    'Mậu Dần': '戊寅',
    'Mậu Thìn': '戊辰',
    'Mậu Ngọ': '戊午',
    'Mậu Thân': '戊申',
    'Mậu Tuất': '戊戌',
    'Kỷ Sửu': '己丑',
    'Kỷ Mão': '己卯',
    'Kỷ Tỵ': '己巳',
    'Kỷ Mùi': '己未',
    'Kỷ Dậu': '己酉',
    'Kỷ Hợi': '己亥',
    'Canh Tý': '庚子',
    'Canh Dần': '庚寅',
    'Canh Thìn': '庚辰',
    'Canh Ngọ': '庚午',
    'Canh Thân': '庚申',
    'Canh Tuất': '庚戌',
    'Tân Sửu': '辛丑',
    'Tân Mão': '辛卯',
    'Tân Tỵ': '辛巳',
    'Tân Mùi': '辛未',
    'Tân Dậu': '辛酉',
    'Tân Hợi': '辛亥',
    'Nhâm Tý': '壬子',
    'Nhâm Dần': '壬寅',
    'Nhâm Thìn': '壬辰',
    'Nhâm Ngọ': '壬午',
    'Nhâm Thân': '壬申',
    'Nhâm Tuất': '壬戌',
    'Quý Sửu': '癸丑',
    'Quý Mão': '癸卯',
    'Quý Tỵ': '癸巳',
    'Quý Mùi': '癸未',
    'Quý Dậu': '癸酉',
    'Quý Hợi': '癸亥',
  };

  static final vietnameseToUSAZodiac = {
    'Giáp Tý': 'Jia Rat',
    'Giáp Dần': 'Jia Tiger',
    'Giáp Thìn': 'Jia Dragon',
    'Giáp Ngọ': 'Jia Horse',
    'Giáp Thân': 'Jia Monkey',
    'Giáp Tuất': 'Jia Dog',
    'Ất Sửu': 'Yi Ox',
    'Ất Mão': 'Yi Rabbit',
    'Ất Tỵ': 'Yi Snake',
    'Ất Mùi': 'Yi Goat',
    'Ất Dậu': 'Yi Rooster',
    'Ất Hợi': 'Yi Pig',
    'Bính Tý': 'Bing Rat',
    'Bính Dần': 'Bing Tiger',
    'Bính Thìn': 'Bing Dragon',
    'Bính Ngọ': 'Bing Horse',
    'Bính Thân': 'Bing Monkey',
    'Bính Tuất': 'Bing Dog',
    'Đinh Sửu': 'Ding Ox',
    'Đinh Mão': 'Ding Rabbit',
    'Đinh Tỵ': 'Ding Snake',
    'Đinh Mùi': 'Ding Goat',
    'Đinh Dậu': 'Ding Rooster',
    'Đinh Hợi': 'Ding Pig',
    'Mậu Tý': 'Wu Rat',
    'Mậu Dần': 'Wu Tiger',
    'Mậu Thìn': 'Wu Dragon',
    'Mậu Ngọ': 'Wu Horse',
    'Mậu Thân': 'Wu Monkey',
    'Mậu Tuất': 'Wu Dog',
    'Kỷ Sửu': 'Ji Ox',
    'Kỷ Mão': 'Ji Rabbit',
    'Kỷ Tỵ': 'Ji Snake',
    'Kỷ Mùi': 'Ji Goat',
    'Kỷ Dậu': 'Ji Rooster',
    'Kỷ Hợi': 'Ji Pig',
    'Canh Tý': 'Geng Rat',
    'Canh Dần': 'Geng Tiger',
    'Canh Thìn': 'Geng Dragon',
    'Canh Ngọ': 'Geng Horse',
    'Canh Thân': 'Geng Monkey',
    'Canh Tuất': 'Geng Dog',
    'Tân Sửu': 'Xin Ox',
    'Tân Mão': 'Xin Rabbit',
    'Tân Tỵ': 'Xin Snake',
    'Tân Mùi': 'Xin Goat',
    'Tân Dậu': 'Xin Rooster',
    'Tân Hợi': 'Xin Pig',
    'Nhâm Tý': 'Ren Rat',
    'Nhâm Dần': 'Ren Tiger',
    'Nhâm Thìn': 'Ren Dragon',
    'Nhâm Ngọ': 'Ren Horse',
    'Nhâm Thân': 'Ren Monkey',
    'Nhâm Tuất': 'Ren Dog',
    'Quý Sửu': 'Gui Ox',
    'Quý Mão': 'Gui Rabbit',
    'Quý Tỵ': 'Gui Snake',
    'Quý Mùi': 'Gui Goat',
    'Quý Dậu': 'Gui Rooster',
    'Quý Hợi': 'Gui Pig',
  };
}

const APP_NAME = 'Xhero';

const IMAGE_ASSET = 'lib/resource/images/';
//direction_titleDirectiondinates

// Environment
const DEV_ENVIRONMENT = 'dev_environment';
const STAGING_ENVIRONMENT = 'staging_environment';
const PROD_ENVIRONMENT = 'prod_environment';
const DEV_V2_ENVIRONMENT = 'devv_2_environment';
const UAT_V2_ENVIRONMENT = 'uat_v2_environment';
const PROD_V2_ENVIRONMENT = 'prod_v2_environment';
// Define Theme
const DARK_THEME = 'DARK';
const LIGHT_THEME = 'LIGHT';

// Define Language
const VIETNAMESE_LANG = 'vi';
const ENGLISH_LANG = 'en';
const CHINESE_LANG = 'zh';

const GraphQLAuthUrl = 'GraphQLAuthUrl';
const GraphQLServiceUrl = 'GraphQLServiceUrl';
const WebSocketGraphQLUrl = 'WebSocketGraphQLUrl';
const MediaApiEnvironment = 'MediaApiEnvironment';
const DefaultLanguageCode = 'DefaultLanguageCode';
const UIAPIDomain = 'UIAPIDomain';
const ClientAPIDomain = 'ClientAPIDomain';
const FILEAPIDomain = 'FILEAPIDomain';

class DireCoor {
  String title;
  String degree;
  String code;
  String codeDirection;
  String titleDirection;
  DireCoor({
    required this.title,
    required this.degree,
    required this.code,
    required this.codeDirection,
    required this.titleDirection,
  });
}

class LunarHour {
  final String code;
  final String image;

  LunarHour(this.image, {required this.code});
}
