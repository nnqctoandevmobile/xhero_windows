import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../resource/assets_constant/btn_constant.dart';
import '../../constants/colors.dart';
import '../../constants/common.dart';
import '../../resource/assets_constant/pu_constants.dart';
import '../../utils/logic/common_widget.dart';
import '../../utils/logic/xhero_common_logics.dart';
import '../text_style.dart';

class PopupErrorState {
  static void show({
    required BuildContext context,
    required String title,
  }) {
    showDialog(
      context: context,
      barrierColor: AppColor.blackColor75,
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            backgroundColor: AppColor.transparentColor,
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: optimizedSize(
                                phone: 88,
                                zfold: 80,
                                tablet: 80,
                                context: context)),
                        width: optimizedSize(
                            phone: getResponsiveWidth(context),
                            zfold: getResponsiveWidth(context) / 1.25,
                            tablet: getResponsiveWidth(context) / 1.25,
                            context: context),
                        height: optimizedSize(
                            phone: 248,
                            zfold: 280,
                            tablet: 348,
                            context: context),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(PopupConstants.pu_error_state),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: optimizedSize(
                                        phone: 0,
                                        zfold: 48,
                                        tablet: 68,
                                        context: context)),
                                child: GradientText(title,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    colors: CommonConstants.gradientTextInPopup,
                                    textAlign: TextAlign.center,
                                    gradientDirection: GradientDirection.ttb,
                                    style: TextAppStyle()
                                        .normalTextStyle()
                                        .copyWith(
                                            color: AppColor.brownLight,
                                            height: 1.35,
                                            shadows: [
                                          Shadow(
                                              // bottomRight
                                              offset: const Offset(-1, 1),
                                              color: AppColor.whiteColor
                                                  .withAlpha(
                                                      (0.25 * 255).toInt())),
                                          Shadow(
                                              // bottomRight
                                              offset: const Offset(0, 1),
                                              color: AppColor.secondaryColor
                                                  .withAlpha(
                                                      (0.25 * 255).toInt())),
                                        ])),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width > 500
                                  ? 0
                                  : 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              onTapWidget(
                                onTap: () {
                                  Navigator.pop(context, true);
                                },
                                child: Container(
                                  height: optimizedSize(
                                      phone: 40,
                                      zfold: 48,
                                      tablet: 60,
                                      context: context),
                                  width: optimizedSize(
                                      phone: 128,
                                      zfold: 168,
                                      tablet: 208,
                                      context: context),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              ButtonConstants.btn_pu_error),
                                          fit: BoxFit.fill)),
                                  child: Center(
                                    child: Text(
                                      'try_again'.tr,
                                      style: TextAppStyle()
                                          .semiBoldTextStyleSmall()
                                          .copyWith(
                                              color: AppColor.textBrownDark,
                                              fontSize: 16,
                                              shadows: [
                                            Shadow(
                                                // bottomRight
                                                offset: const Offset(1, -1.0),
                                                color: AppColor.colorRedBold
                                                    .withAlpha(
                                                        (0.2 * 255).toInt())),
                                            Shadow(
                                                // topRight
                                                offset: const Offset(0, -1),
                                                color: AppColor.colorRedBold
                                                    .withAlpha(
                                                        (0.25 * 255).toInt())),
                                          ]),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )));
      },
    );
  }
}
