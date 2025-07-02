import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../constants/colors.dart';
import '../../constants/common.dart';
import '../../resource/assets_constant/icon_constants.dart';
import '../../resource/assets_constant/images_constants.dart';
import '../../shared/multi_appear_widgets/body_with_bg_light.dart';
import '../../shared/text_style.dart';
import 'xhero_common_logics.dart';

class CommonWidget {
  static AppBar appBar(
    BuildContext context,
    String title, {
    void Function()? callback,
    IconData? backIcon,
    Color? color,
    bool? automaticallyImplyLeading,
  }) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      leading: backIcon == null
          ? null
          : IconButton(
              icon: Icon(backIcon, color: color),
              onPressed: () {
                if (callback != null) {
                  callback();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColor.whiteColor,
          fontFamily: 'Rubik',
        ),
      ),
      backgroundColor: Colors.green,
      elevation: 0,
    );
  }

  static SizedBox rowHeight({double height = 30}) {
    return SizedBox(height: height);
  }

  static SizedBox rowWidth({double width = 30}) {
    return SizedBox(width: width);
  }

  static Future<void> snackBar(String error) async {
    Get.snackbar(
      'error_system'.tr,
      error,
      backgroundColor: AppColor.colorRed,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

Widget onTapWidget({
  required Widget child,
  double radius = 0.0,
  required void Function()? onTap,
}) {
  return InkWell(
    splashColor: AppColor.blackColor.withAlpha((0.05 * 255).toInt()),
    borderRadius: BorderRadius.circular(radius),
    highlightColor: AppColor.grayTextwhiteColor.withAlpha((0.15 * 255).toInt()),
    onTap: onTap,
    child: child,
  );
}

double widthFlexible(double designWidth) {
  return designWidth * (Get.width / CommonConstants.maxWidthByDesign);
}

double heightFlexible(double designHeight) {
  return designHeight * (Get.height / CommonConstants.maxHeightByDesign);
}

double getResponsiveWidth(BuildContext context) {
  return MediaQuery.of(context).size.width > 500 ? (Get.width) : Get.width;
}

Widget loadingLogoState() {
  return Center(
    child: SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              backgroundColor: AppColor.grayTextwhiteColor.withAlpha(
                (0.25 * 255).toInt(),
              ),
              strokeWidth: 1.5,
              color: AppColor.primaryColor,
            ),
          ),
          Image.asset(IconConstants.ic_bmb_center_active, width: 26),
        ],
      ),
    ),
  );
}

TextStyle custom3DTextStyle(BuildContext context) {
  return TextStyle(
    inherit: true,
    fontSize: optimizedSize(phone: 16, zfold: 18, tablet: 20, context: context),
    color: AppColor.textLightColor,
    fontFamily: CommonConstants.extrabold,
    shadows: [
      Shadow(
        // bottomRight
        offset: const Offset(0, 2),
        color: AppColor.borderYellow.withAlpha((0.5 * 255).toInt()),
      ),
      Shadow(
        // topRight
        offset: const Offset(-2, 2),
        color: AppColor.textBrownColor,
      ),
    ],
  );
}

Widget frameCommonWidget({
  required Widget body,
  required String titleAppbar,
  Widget? drawer,
  Function()? onTap,
  bool? isHiddenBack,
  bool? isShowAction,
  bool? isNotExpanded,
  bool? isChangePadding,
  String? background,
  Widget? action,
  bool? resizeToAvoidBottomInset,
  double? width,
  GlobalKey<ScaffoldState>? scaffoldKey,
}) {
  return Scaffold(
    key: scaffoldKey,
    drawer: drawer,
    body: Stack(
      children: [
        BodyWithBackgroundLight(background: background, child: body),
        Container(
          width: Get.width,
          height: 108,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstants.img_bg_appbar),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            height: heightFlexible(100),
            padding: isChangePadding == true
                ? const EdgeInsets.fromLTRB(16, 8, 4, 8)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 54,
                  margin: const EdgeInsets.only(right: 12),
                  child: isHiddenBack == true
                      ? const SizedBox.shrink()
                      : onTapWidget(
                          onTap: onTap ?? Get.back,
                          child: SvgPicture.asset(
                            IconConstants.ic_arrow_back_auth,
                            width: 54,
                            height: 40,
                          ),
                        ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: GradientText(
                      titleAppbar,
                      textAlign: TextAlign.center,
                      colors: CommonConstants.gradientsText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextAppStyle().appBarTitleLight().copyWith(
                        fontSize: 18,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width ?? 54,
                  margin: const EdgeInsets.only(left: 12),
                  child: isShowAction == true
                      ? Align(
                          alignment: Alignment
                              .bottomRight, // Căn chỉnh widget con ở giữa
                          child: action ?? const SizedBox(width: 54),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
  );
}
