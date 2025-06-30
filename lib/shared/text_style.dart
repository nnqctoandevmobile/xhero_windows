import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/common.dart';

class TextAppStyle {
  TextStyle appBarTitle() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: 14,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle appBarTitleLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: 14,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle iconMenuHomeTitle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w900,
      fontFamily: CommonConstants.fuzzyBubbles_bold,
    );
  }

  //*NormalText: FontWeight: Normal, fontsize: 10,12,14,16,18, color: Black
  TextStyle normalTextStyleExtraSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle normalTextStyleSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle normalTextStyle() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle normalTextStyleTheme(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle normalTextStyleLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle normalTextStyleExtraLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.medium,
    );
  }

  //light-text
  TextStyle normalTextStyleExtraSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle normalTextStyleSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle normalTextStyleLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle normalTextStyleLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle normalTextStyleExtraLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.medium,
    );
  }

  //*ThinText: FontWeight: W400, fontsize: 10,12,14,16,18, color: Black
  TextStyle thinTextStyleExtraSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle thinTextStyleSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle thinTextStyle() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle thinTextStyleLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle thinTextStyleExtraLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.light,
    );
  }

  //light_text
  TextStyle thinTextStyleExtraSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle thinTextStyleSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle thinTextStyleLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle thinTextStyleLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle thinTextStyleExtraLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.light,
    );
  }

  //*Semibold: FontWeight: SemiBold, fontsize: 10,12,14,16,18, color: Black
  TextStyle semiBoldTextStyleExtraSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle semiBoldTextStyleSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle semiBoldTextStyle() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle semiBoldTextStyleLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle semiBoldTextStyleExtraLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.semibold,
    );
  }

  //light-text
  TextStyle semiBoldTextStyleExtraSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle semiBoldTextStyleSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle semiBoldTextStyleLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle semiBoldTextStyleLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle semiBoldTextStyleExtraLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.semibold,
    );
  }

  //*titleText: FontWeight: Bold, fontsize: 10,12,14,16,18, color: Black
  TextStyle titleStyleExtraSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle titleStyleSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle titleStyle() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle titleStyleLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle titleStyleExtraLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.bold,
    );
  }

  //light-text
  TextStyle titleStyleExtraSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle titleStyleSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle titleStyleLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle titleStyleLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle titleStyleExtraLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.bold,
    );
  }

  //*superText: FontWeight: ExtraBold, fontsize: 10,12,14,16,18, color: Black
  TextStyle superStyleExtraSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle superStyleSmall() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle superStyle() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle superStyleLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle superStyleExtraLarge() {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  //light-text
  TextStyle superStyleExtraSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle superStyleSmallLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle superStyleLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle superStyleLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle superStyleExtraLargeLight() {
    return TextStyle(
      color: AppColor.textLightColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  //hint_text_stype
  TextStyle hintTextGrey() {
    return TextStyle(
      color: AppColor.grayTextwhiteColor,
      fontSize: 14,
      fontFamily: CommonConstants.light,
    );
  }

  //=======================APPLY-THEME===========================
  TextStyle themeFlexibleSize(BuildContext context, double size) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: size,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle themeAppBarTitle(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: 20.0,
      fontWeight: FontWeight.w900,
      fontFamily: 'Pattaya-Regular',
    );
  }

  TextStyle themeBottomMenuTitle(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'Pattaya-Regular',
    );
  }

  TextStyle themeAppBarTitleLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: 16,
      fontFamily: CommonConstants.extrabold,
    );
  }

  //*NormalText: FontWeight: Normal, fontsize: 10,12,14,16,18, color: Black
  TextStyle themeMediumExtraSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle themeMediumSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle themeMedium(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle themeMediumLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle themeMediumExtraLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.medium,
    );
  }

  //light-text
  TextStyle themeMediumExtraSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle themeMediumSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle themeMediumLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle themeMediumLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.medium,
    );
  }

  TextStyle themeMediumExtraLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.medium,
    );
  }

  //*ThinText: FontWeight: W400, fontsize: 10,12,14,16,18, color: Black
  TextStyle themeThinExtraSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle themeThinSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle themeThin(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle themeThinLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle themeThinExtraLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.light,
    );
  }

  //light_text
  TextStyle themeThinExtraSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle themeThinSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle themeThinLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle themeThinLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.light,
    );
  }

  TextStyle themeThinExtraLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.light,
    );
  }

  //*Semibold: FontWeight: SemiBold, fontsize: 10,12,14,16,18, color: Black
  TextStyle themeSemiBoldExtraSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle themeSemiBoldSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle themeSemiBold(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle themeSemiBoldLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle themeSemiBoldExtraLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.semibold,
    );
  }

  //light-text
  TextStyle themeSemiBoldExtraSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle themeSemiBoldSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle themeSemiBoldLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle themeSemiBoldLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.semibold,
    );
  }

  TextStyle themeSemiBoldExtraLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.semibold,
    );
  }

  //*titleText: FontWeight: Bold, fontsize: 10,12,14,16,18, color: Black
  TextStyle themeBoldExtraSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle themeBoldSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle themeBold(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle themeBoldLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle themeBoldExtraLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.bold,
    );
  }

  //light-text
  TextStyle themeBoldExtraSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle themeBoldSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle themeBoldLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle themeBoldLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.bold,
    );
  }

  TextStyle themeBoldExtraLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.bold,
    );
  }

  //*superText: FontWeight: ExtraBold, fontsize: 10,12,14,16,18, color: Black
  TextStyle themeExtraBoldExtraSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle themeExtraBoldSmall(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle themeExtraBold(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle themeExtraBoldLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle themeExtraBoldExtraLarge(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  //light-text
  TextStyle themeExtraBoldExtraSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraSmallText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle themeExtraBoldSmallLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle themeExtraBoldLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.mediumText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle themeExtraBoldLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.largeText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  TextStyle themeExtraBoldExtraLargeLight(BuildContext context) {
    return TextStyle(
      color: AppColor.primaryColor,
      fontSize: CommonConstants.extraLargeText,
      fontFamily: CommonConstants.extrabold,
    );
  }

  //hint_text_stype
  TextStyle themeHint(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.outline,
      fontSize: CommonConstants.smallText,
      fontFamily: CommonConstants.medium,
    );
  }
}
