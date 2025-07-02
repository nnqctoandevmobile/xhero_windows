// ignore_for_file: use_super_parameters, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../resource/assets_constant/frames_constant.dart';
import '../../../resource/assets_constant/icon_constants.dart';
import '../../constants/colors.dart';
import '../../constants/common.dart';
import '../../resource/assets_constant/images_constants.dart';
import '../../utils/logic/common_widget.dart';
import '../text_style.dart';
import 'gradient_border_container.dart';

class CustomShowCaseWidget extends StatelessWidget {
  final GlobalKey keySC;
  final String title;
  final String description;
  final Widget child;
  final int index;
  final isFinished;

  const CustomShowCaseWidget({
    Key? key,
    required this.keySC,
    required this.title,
    required this.description,
    required this.child,
    required this.index,
    this.isFinished = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      movingAnimationDuration: const Duration(milliseconds: 1000),
      key: keySC,
      height: 180,
      width: Get.width - 32,
      // targetBorderRadius: BorderRadius.circular(100),
      container: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColor.lightBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: const GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: CommonConstants.gradientsLight,
                      ),
                      width: 2,
                    ),
                    image: const DecorationImage(
                      image: AssetImage(ImageConstants.img_bg_show_view),
                      fit: BoxFit.fill,
                    ),
                  ),
                  width: Get.width - 32,
                  height: 116,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Image.asset(
                              FrameConstants.fr_show_case,
                              width: 80,
                              height: 80,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'xhero_guides_you_now'.tr,
                                  style: TextAppStyle().titleStyle(),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  description.tr,
                                  style: TextAppStyle().normalTextStyleSmall(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: Get.width - 32,
                  child: Row(
                    mainAxisAlignment: isFinished
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isFinished)
                        GradientBorderContainer(
                          lstColor: CommonConstants.gradientDarkGray,
                          padding: const EdgeInsets.all(1),
                          margin: EdgeInsets.zero,
                          radius: 100,
                          child: onTapWidget(
                            onTap: () {
                              ShowCaseWidget.of(context).dismiss();
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                    colors: CommonConstants.gradientLightGray,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Text(
                                            'skip'.tr,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextAppStyle()
                                                .semiBoldTextStyle()
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: AppColor
                                                      .grayTextwhiteColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 27,
                                      height: 27,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: AppColor.grayTextwhiteColor
                                              .withAlpha((0.45 * 255).toInt()),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.clear_rounded,
                                          size: 22,
                                          color: AppColor.grayTextwhiteColor
                                              .withAlpha((0.85 * 255).toInt()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      GradientBorderContainer(
                        lstColor: CommonConstants.gradientAccountIcons,
                        padding: const EdgeInsets.all(1),
                        margin: EdgeInsets.zero,
                        radius: 100,
                        child: onTapWidget(
                          onTap: () async {
                            ShowCaseWidget.of(context).next();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: const LinearGradient(
                                  colors: CommonConstants.button,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          isFinished ? 'done'.tr : 'next'.tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextAppStyle()
                                              .semiBoldTextStyle()
                                              .copyWith(
                                                fontSize: 12,
                                                color: AppColor.textBrownDark,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  isFinished
                                      ? Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            border: const GradientBoxBorder(
                                              gradient: LinearGradient(
                                                colors: CommonConstants.button,
                                              ),
                                            ),
                                            gradient: LinearGradient(
                                              colors: CommonConstants
                                                  .gradientBrownBtn,
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: AppColor.actionTextYellow,
                                              size: 20,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            border: const GradientBoxBorder(
                                              gradient: LinearGradient(
                                                colors: CommonConstants.button,
                                              ),
                                            ),
                                            gradient: LinearGradient(
                                              colors: CommonConstants
                                                  .gradientBrownBtn,
                                            ),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              IconConstants
                                                  .ic_arrow_right_gradient,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: AppColor.brownLight),
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: CommonConstants.gradientAccountIcons,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextAppStyle()
                          .titleStyleExtraLargeLight()
                          .copyWith(color: const Color(0xfffaf8f0)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}
