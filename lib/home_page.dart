import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'constants/colors.dart';
import 'constants/common.dart';
import 'extreme_by_image.dart';
import 'shared/multi_appear_widgets/gradient_text_menu_stroke_gradient.dart';
import 'shared/multi_appear_widgets/gradient_text_stroke.dart';
import 'shared/text_style.dart';
import 'utils/logic/xhero_common_logics.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedFileName;
  String? selectedFilePath;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      setState(() {
        selectedFileName = path.split('\\').last;
        selectedFilePath = path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Đã chọn ảnh: $selectedFileName",
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          backgroundColor: const Color.fromARGB(255, 253, 246, 213),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isWide = width > 800;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.05,
          horizontal: width * 0.05,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo & Slogan
              Column(
                children: [
                  Image.asset(
                    'assets/ic_launcher.png',
                    width: width * 0.2,
                    height: width * 0.2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 239, 193, 25),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Image.asset(
                          'assets/logo_with_slogan.png',
                          width: isWide ? 200 : width * 0.3,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 239, 193, 25),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Bottom Box
              Container(
                width: isWide ? width * 0.75 : width * 0.95,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(255, 239, 193, 25),
                  ),
                ),
                child: Column(
                  children: [
                    GradientTextWithStrokeMenu(
                      text: capitalForText('extreme_compass'.tr.toUpperCase()),
                      strokeWidth: 1,
                      maxline: 2,
                      fontSize: optimizedSize(
                        phone: 24,
                        zfold: 26,
                        tablet: 28,
                        context: context,
                      ),
                      textGradient: LinearGradient(
                        transform: const GradientRotation(
                          75.75 * (math.pi / 180),
                        ),
                        colors: CommonConstants.titleCategoryGradient,
                        stops: CommonConstants.stopsTitleCategoryGradient,
                      ),
                      strokeGradient: LinearGradient(
                        // startAngle: 346.44 * math.pi / 180,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: CommonConstants.strokeCategoryGradient,
                        stops: CommonConstants.stopsStrokeCategoryGradient,
                      ),
                      style: const TextStyle(
                        inherit: true,
                        letterSpacing: 0.6,
                        height: 1.2,
                        fontFamily: 'UTM-Bitsumishi-Pro',
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            color: Color(0xff412C04),
                            blurRadius: 5,
                          ),
                          Shadow(
                            offset: Offset(-0.6, 0.5),
                            color: Color(0xff825400),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Divider(
                      color: Color.fromARGB(255, 239, 193, 25),
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 16),
                    GradientText(
                      'Tải bản vẽ từ thiết bị để lập cực',
                      colors: const [
                        Color.fromARGB(255, 206, 169, 3),
                        Color.fromARGB(255, 238, 209, 82),
                        Color.fromARGB(255, 224, 160, 22),
                        Color.fromARGB(255, 238, 209, 82),
                      ],
                      style: TextAppStyle().normalTextStyle(),
                    ),
                    const SizedBox(height: 20),

                    /// Ảnh chọn hoặc đã chọn
                    selectedFilePath == null
                        ? GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: isWide ? width * 0.15 : width * 0.25,
                              height: isWide ? width * 0.15 : width * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.yellow.withAlpha(40),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 1,
                                  color: const Color.fromARGB(
                                    255,
                                    239,
                                    193,
                                    25,
                                  ),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.add_circled_solid,
                                  color: Color.fromARGB(255, 239, 193, 25),
                                  size: 60,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: isWide
                                        ? width * 0.125
                                        : width * 0.25,
                                    height: isWide
                                        ? width * 0.125
                                        : width * 0.25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 1,
                                        color: const Color.fromARGB(
                                          255,
                                          239,
                                          193,
                                          25,
                                        ),
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(selectedFilePath!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ClipRRect(
                                        borderRadius: BorderRadiusGeometry.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                        child: Container(
                                          width: width,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          color: Colors.black26,
                                          child: Text(
                                            selectedFileName ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                255,
                                                239,
                                                193,
                                                25,
                                              ),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _pickImage();
                                    },
                                    child: Container(
                                      width: isWide
                                          ? width * 0.15
                                          : width * 0.3,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 230, 227, 214),
                                            Color.fromARGB(255, 255, 249, 221),
                                            Color.fromARGB(255, 248, 241, 227),
                                            Color.fromARGB(255, 160, 158, 147),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          width: 2,
                                          color: const Color.fromARGB(
                                            255,
                                            175,
                                            175,
                                            172,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 4),

                                            Text(
                                              'Ảnh khác',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 2,
                                                  ),
                                              child: Icon(Icons.image),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  InkWell(
                                    onTap: () {
                                      if (selectedFilePath != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ExtremeByImage(
                                              filePath: selectedFilePath!,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: isWide
                                          ? width * 0.15
                                          : width * 0.3,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 206, 169, 3),
                                            Color.fromARGB(255, 238, 209, 82),
                                            Color.fromARGB(255, 224, 160, 22),
                                            Color.fromARGB(255, 238, 209, 82),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          width: 2,
                                          color: const Color.fromARGB(
                                            255,
                                            236,
                                            230,
                                            197,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 8),
                                          Text(
                                            'Tiếp tục',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            child: Icon(Icons.arrow_right_alt),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
