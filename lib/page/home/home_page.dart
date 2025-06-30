import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xhero_windows_app/page/home/widget/menu_item.dart';

import '../../constants/common.dart';
import '../../shared/multi_appear_widgets/gradient_text_menu_stroke_gradient.dart';
import '../../utils/data/list_menu_home.dart';
import '../../utils/logic/xhero_common_logics.dart';
import 'dart:html' as html;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedFileName;
  String? selectedFilePath;

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
              Expanded(
                child: Container(
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
                        text: capitalForText(
                          'Danh sách tính năng'.tr.toUpperCase(),
                        ),
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

                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = (constraints.maxWidth ~/ 200)
                                .clamp(2, 5); // auto responsive
                            return GridView.count(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.2,
                              children: List.generate(lstMenuLocal.length, (
                                index,
                              ) {
                                final menu = lstMenuLocal[index];
                                return MenuItem(
                                  menu: menu,
                                  onTap: () {
                                    if (index == 0) {
                                      //
                                    } else if (index == 1) {
                                      //
                                    } else if (index == 2) {
                                      // bản đồ gió
                                      html.window.open(
                                        'https://www.msn.com/vi-vn/weather/maps/wind',
                                        '_blank',
                                      );
                                    } else if (index == 3) {
                                      //
                                    } else if (index == 4) {
                                      //
                                    }
                                  },
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
