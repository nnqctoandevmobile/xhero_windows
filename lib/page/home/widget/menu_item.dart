import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:xhero_windows_app/utils/logic/common_widget.dart';

import '../../../constants/common.dart';
import '../../../shared/multi_appear_widgets/gradient_text_menu_stroke_gradient.dart';
import '../../../utils/logic/xhero_common_logics.dart';
import '../../../utils/model/menu_item_model.dart';

class MenuItem extends StatelessWidget {
  final MenuItemModel menu;
  final VoidCallback onTap;
  const MenuItem({super.key, required this.menu, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return onTapWidget(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(menu.icon, width: 100, height: 100, fit: BoxFit.contain),
          const SizedBox(height: 12),
          GradientTextWithStrokeMenu(
            text: capitalForText(menu.title),
            strokeWidth: 1,
            maxline: 2,
            fontSize: optimizedSize(
              phone: 16,
              zfold: 18,
              tablet: 20,
              context: context,
            ),
            textGradient: LinearGradient(
              transform: const GradientRotation(75.75 * (math.pi / 180)),
              colors: CommonConstants.titleCategoryGradient,
              stops: CommonConstants.stopsTitleCategoryGradient,
            ),
            strokeGradient: LinearGradient(
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
        ],
      ),
    );
  }
}
