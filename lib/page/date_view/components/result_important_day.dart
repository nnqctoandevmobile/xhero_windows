// // ignore_for_file: prefer_interpolation_to_compose_strings

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:gradient_borders/gradient_borders.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:xhero_windows_app/utils/logic/xhero_common_logics.dart';

// import '../../../constants/colors.dart';
// import '../../../constants/common.dart';
// import '../../../datasource/fetch_api_repository.dart';
// import '../../../resource/assets_constant/btn_constant.dart';
// import '../../../resource/assets_constant/frames_constant.dart';
// import '../../../resource/assets_constant/icon_constants.dart';
// import '../../../resource/assets_constant/images_constants.dart';
// import 'package:http/http.dart' as http;

// import '../../../shared/multi_appear_widgets/gradient_icon_widget.dart';
// import '../../../shared/multi_appear_widgets/gradient_text_stroke.dart';
// import '../../../shared/text_style.dart';
// import '../../../utils/logic/common_widget.dart';
// import 'hono_scopes.dart';


// class ResultOfImportantDayScreen extends StatefulWidget {
//   final XheroFetchApiRespository uiRepository;
//   final Map<String, dynamic> dataResult;
//   final String name;
//   final String dob;
//   final String wfName;
//   final String wfDob;
//   final String aim;
//   final String title;
//   final String gender;
//   final String deathDate;
//   final String borrowDate;
//   final String deathTime;
//   final String code;
//   final String type;
//   final bool incluDIA;
//   final bool isGiaChuNamDay;
//   final bool isGiaChuNamMonth;
//   final bool isGiaChuNuDay;
//   final bool isGiaChuNuMonth;
//   final bool isTuoiMuonDay;
//   final bool isTuoiMuonMonth;
//   const ResultOfImportantDayScreen(
//       {super.key,
//       required this.uiRepository,
//       required this.dataResult,
//       required this.name,
//       required this.dob,
//       required this.wfName,
//       required this.wfDob,
//       required this.aim,
//       required this.title,
//       required this.gender,
//       required this.deathDate,
//       required this.borrowDate,
//       required this.deathTime,
//       required this.code,
//       required this.type,
//       required this.incluDIA,
//       required this.isGiaChuNamDay,
//       required this.isGiaChuNamMonth,
//       required this.isGiaChuNuDay,
//       required this.isGiaChuNuMonth,
//       required this.isTuoiMuonDay,
//       required this.isTuoiMuonMonth});

//   @override
//   State<ResultOfImportantDayScreen> createState() =>
//       _ResultOfImportantDayScreenState();
// }

// class _ResultOfImportantDayScreenState
//     extends State<ResultOfImportantDayScreen> {
//   bool showAll = false;
//   int itemCount = 0;
//   bool isCapturing = false;
//   ScreenshotController screenshotController = ScreenshotController();
//   int getStarCount(String status) {
//     return CommonConstants.starsOfStatus[status] ?? 0;
//   }

//   bool isIncludingDIAInside(String thing) {
//     const List<String> lstThing = [
//       "trong-cay",
//       "khoi-cong",
//       "sua-chua",
//       "pha-do",
//       "dong-tho",
//       "do-mong",
//       "do-mai",
//       "cat-noc",
//       "mo-cong",
//       "boi-hoan-long-mach",
//       "nhap-trach",
//       "ta-dat",
//       "khanh-thanh",
//       "khai-truong",
//       "mo-cua-hang",
//       "chuyen-nha",
//       "ban-nha",
//       "dap-dap",
//       "ngan-de",
//       "dao-gieng",
//       "lap-gieng",
//       'ngay-nham-chuc',
//       'ngay-nhan-cong-viec-moi',
//       'ngay-ra-mat-san-pham',
//       'giao-dich',
//       'chuyen-vi-tri-ban-tho',
//       'boc-bat-huong',
//       'tu-tao-lai-ban-tho',
//       'them-bat-huong',
//       'thay-ban-tho',
//       'giai-xa-ban-tho',
//       'ngay-an-hoi',
//       'ngay-lai-mat',
//       'ngay-dam-ngo',
//       'ngay-cuoi',
//       "dong-tho-xay-ho",
//       "dao-mo-cu-mo-lap-van",
//       "ha-tieu",
//       "dung-bia",
//       "ta-mo",
//       "sua-mo"
//     ];
//     return lstThing.contains(thing);
//   }

//   List<dynamic> itemsToShow = [];
//   @override
//   Widget build(BuildContext context) {
//     double maxWidth = MediaQuery.of(context).size.width;

//     try {
//       itemCount = widget.dataResult['data']['arrDate'].length;
//       itemsToShow = showAll
//           ? widget.dataResult['data']['arrDate']
//           : widget.dataResult['data']['arrDate'].take(5).toList();
//     } catch (e) {
//       printConsole('$e');
//     }
//     return frameCommonWidget(
//         background: ImageConstants.img_bg_result_important,
//         isShowAction: !isCapturing,
//         isHiddenBack: isCapturing,
//         action: Row(
//           children: [
//             onTapWidget(
//               onTap: () async {
//                 _shareResult();
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 12),
//                 child: Image.asset(
//                   IconConstants.ic_btn_share,
//                   width: 40,
//                   height: 40,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Center(
//             child: SizedBox(
//               width: getResponsiveWidth(context),
//               child: Screenshot(
//                 controller: screenshotController,
//                 child: Column(
//                   children: [
//                     Container(
//                       width: getResponsiveWidth(context),
//                       color: isCapturing
//                           ? AppColor.whiteColor
//                           : AppColor.transparentColor,
//                       constraints: BoxConstraints(
//                         minHeight: Get.height,
//                       ),
//                       child: Stack(
//                         children: [
//                           Positioned.fill(
//                             child: Align(
//                               alignment: Alignment.topCenter,
//                               child: Container(
//                                 width: Get.width,
//                                 // Ensure height is dynamic or adjust as needed
//                                 height: Get.width / 1.5,
//                                 margin:
//                                     const EdgeInsets.only(top: 108, left: 0),
//                                 decoration: const BoxDecoration(
//                                   image: DecorationImage(
//                                     image: AssetImage(
//                                         ImageConstants.img_bg_ial_content),
//                                     fit: BoxFit.fitHeight,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(24),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox( height: 104),
//                                 Center(
//                                   child: Stack(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Image.asset(
//                                             IconConstants.ic_dai_nam_gradient,
//                                             width: 24,
//                                           ),
//                                           const SizedBox(width: 8),
//                                           GradientTextWithStroke(
//                                             text: 'important_day_result'
//                                                 .tr
//                                                 .toUpperCase(),
//                                             colors: CommonConstants.button,
//                                             style: TextAppStyle()
//                                                 .superStyle()
//                                                 .copyWith(
//                                               color: AppColor.textYellow,
//                                               shadows: [
//                                                 Shadow(
//                                                   blurRadius: 0.25,
//                                                   color: AppColor.brownLight,
//                                                   offset: const Offset(0, 0),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(width: 8),
//                                           Image.asset(
//                                             IconConstants.ic_dai_nam_gradient,
//                                             width: 24,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox( height: 16),
//                                 widget.title == 'Trùng tang'
//                                     ? const SizedBox()
//                                     : _infoTHIENArea(),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Center(
//                                       child: Image.asset(
//                                         '' == 'vi'
//                                             ? FrameConstants.fr_nhan_label
//                                             : '' == 'en'
//                                                 ? FrameConstants
//                                                     .fr_nhan_label_en
//                                                 : FrameConstants
//                                                     .fr_nhan_label_zh,
//                                         width: optimizedSize(
//                                             phone: 100,
//                                             zfold: 148,
//                                             tablet: 180,
//                                             context: context),
//                                         fit: BoxFit.fitHeight,
//                                       ),
//                                     ),
//                                     const SizedBox( height: 8),
//                                     widget.code == 'cuoi-hoi'
//                                         ? _weeding()
//                                         : Column(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text('${'full_name'.tr}: ',
//                                                       style: TextAppStyle()
//                                                           .titleStyle()),
//                                                   Expanded(
//                                                     child: Text(
//                                                         widget.name == ''
//                                                             ? 'user_unknown'.tr
//                                                             : widget.name,
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: TextAppStyle()
//                                                             .normalTextStyle()),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox( height: 8),
//                                               Row(
//                                                 children: [
//                                                   Text('${'dob_year'.tr}: ',
//                                                       style: TextAppStyle()
//                                                           .titleStyle()),
//                                                   Expanded(
//                                                     child: Text(
//                                                         '${widget.dataResult['data']['infoGiaChu']['tuoiGiaChu']}'
//                                                                 ' (${(widget.dataResult['data']['tuoiCanGiaChu']?.toString().tr ?? '') + ' ' + (widget.dataResult['data']['tuoiChiGiaChu']?.toString().tr ?? '')})',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: TextAppStyle()
//                                                             .normalTextStyle()),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox( height: 8),
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                       '${'thing_to_check'.tr}: ',
//                                                       style: TextAppStyle()
//                                                           .titleStyle()),
//                                                   Expanded(
//                                                     child: Text(
//                                                         '"' +
//                                                             widget.title +
//                                                             '"',
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: TextAppStyle()
//                                                             .normalTextStyle()),
//                                                   ),
//                                                 ],
//                                               ),
//                                               widget.borrowDate == ''
//                                                   ? const SizedBox()
//                                                   : Column(
//                                                       children: [
//                                                         const SizedBox( height: 8),
//                                                         Row(
//                                                           children: [
//                                                             Text(
//                                                                 '${'borrow_age'.tr}: ',
//                                                                 style: TextAppStyle()
//                                                                     .titleStyle()),
//                                                             Expanded(
//                                                               child: Text(
//                                                                   widget
//                                                                       .borrowDate,
//                                                                   maxLines: 1,
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis,
//                                                                   style: TextAppStyle()
//                                                                       .normalTextStyle()),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     )
//                                             ],
//                                           ),
//                                     widget.code == 'tang-su'
//                                         ? Column(
//                                             children: [
//                                               const SizedBox( height: 8),
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     'gender'.tr + ': ',
//                                                     style: TextAppStyle()
//                                                         .titleStyle(),
//                                                   ),
//                                                   Text(widget.gender.tr,
//                                                       style: TextAppStyle()
//                                                           .normalTextStyle()),
//                                                   Icon(
//                                                     widget.gender == 'male'
//                                                         ? Icons.male_rounded
//                                                         : Icons.female_rounded,
//                                                     color:
//                                                         AppColor.primaryColor,
//                                                   ),
//                                                 ],
//                                               ),
//                                               const SizedBox( height: 8),
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     'death_time'.tr + ': ',
//                                                     style: TextAppStyle()
//                                                         .titleStyle(),
//                                                   ),
//                                                   Text(widget.deathDate,
//                                                       style: TextAppStyle()
//                                                           .normalTextStyle()),
//                                                 ],
//                                               ),
//                                               const SizedBox( height: 8),
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     '(' +
//                                                         'lunar'.tr.replaceAll(
//                                                             '\n', ' ') +
//                                                         ': ',
//                                                     style: TextAppStyle()
//                                                         .normalTextStyle(),
//                                                   ),
//                                                   Text(
//                                                       formatDate(
//                                                               '${widget.dataResult['data']['lichAmShowInfo']['dayLunar']}/'
//                                                               '${widget.dataResult['data']['lichAmShowInfo']['monthLunar']}/'
//                                                               '${widget.dataResult['data']['lichAmShowInfo']['yearLunar']}') +
//                                                           ' - '
//                                                                   '${widget.dataResult['data']['CanNamMat']}'
//                                                               .tr +
//                                                           ' ' +
//                                                           '${widget.dataResult['data']['ChiNamMat']}'
//                                                               .tr +
//                                                           ')',
//                                                       style: TextAppStyle()
//                                                           .normalTextStyle()),
//                                                 ],
//                                               ),
//                                               const SizedBox( height: 8),
//                                               Visibility(
//                                                 visible: widget.deathTime != '',
//                                                 child: Row(
//                                                   children: [
//                                                     Text(
//                                                       'death_hour'.tr + ': ',
//                                                       style: TextAppStyle()
//                                                           .titleStyle(),
//                                                     ),
//                                                     Text(
//                                                         widget.dataResult[
//                                                                         'data']
//                                                                     ['timeDead']
//                                                                 ['time'] +
//                                                             ':00' +
//                                                             ' (' +
//                                                             '${widget.dataResult['data']['timeDead']['gioCan']}'
//                                                                 .tr +
//                                                             ' ' +
//                                                             '${widget.dataResult['data']['timeDead']['gioChi']}'
//                                                                 .tr +
//                                                             ')',
//                                                         style: TextAppStyle()
//                                                             .normalTextStyle()),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         : const SizedBox()
//                                   ],
//                                 ),
//                                 (!widget.incluDIA)
//                                     ? const SizedBox()
//                                     : isIncludingDIAInside(widget.type)
//                                         ? Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Container(
//                                                 height: 0.5,
//                                                 margin: const EdgeInsets.only(
//                                                     top: 12, bottom: 12),
//                                                 width: getResponsiveWidth(
//                                                         context) -
//                                                     48,
//                                                 decoration: BoxDecoration(
//                                                     color: AppColor
//                                                         .textBrownColor
//                                                         .withAlpha((0.5 * 255)
//                                                             .toInt())),
//                                               ),
//                                               Center(
//                                                 child: Image.asset(
//                                                   '' == 'vi'
//                                                       ? FrameConstants
//                                                           .fr_dia_label
//                                                       : '' ==
//                                                               'en'
//                                                           ? FrameConstants
//                                                               .fr_dia_label_en
//                                                           : FrameConstants
//                                                               .fr_dia_label_zh,
//                                                   width: optimizedSize(
//                                                       phone: 100,
//                                                       zfold: 148,
//                                                       tablet: 180,
//                                                       context: context),
//                                                   fit: BoxFit.fitHeight,
//                                                 ),
//                                               ),
//                                               const SizedBox( height: 8),
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Text(
//                                                           '${'home_coor'.tr}: ',
//                                                           style: TextAppStyle()
//                                                               .titleStyle()),
//                                                       Text(
//                                                           '${widget.dataResult['data']['dia']['toaNha']['key']}'
//                                                               .tr,
//                                                           style: TextAppStyle()
//                                                               .normalTextStyle()),
//                                                       Text(' - ',
//                                                           style: TextAppStyle()
//                                                               .normalTextStyle()),
//                                                       Text(
//                                                           '(' +
//                                                               '${widget.dataResult['data']['dia']['toaNha']['nguHanh']}'
//                                                                   .tr +
//                                                               ')',
//                                                           style: TextAppStyle()
//                                                               .normalTextStyle()
//                                                               .copyWith(
//                                                                   color: getColorByElement(
//                                                                       widget.dataResult['data']['dia']['toaNha']
//                                                                               [
//                                                                               'nguHanh'] ??
//                                                                           'tho'))),
//                                                     ],
//                                                   ),
//                                                   const SizedBox( height: 8),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Text('${'select_date'.tr}: ',
//                                                       style: TextAppStyle()
//                                                           .titleStyle()),
//                                                   Expanded(
//                                                     child: Row(
//                                                       children: List.generate(
//                                                           widget
//                                                               .dataResult[
//                                                                   'data']['dia']
//                                                                   [
//                                                                   'hanhNgayChon']
//                                                               .length, (index) {
//                                                         return Text(
//                                                             (index + 1 ==
//                                                                     widget
//                                                                         .dataResult['data']
//                                                                             ['dia'][
//                                                                             'hanhNgayChon']
//                                                                         .length)
//                                                                 ? '${widget.dataResult['data']['dia']['hanhNgayChon'][index]}'
//                                                                         .tr
//                                                                         .toUpperCase() +
//                                                                     ''
//                                                                 : '${widget.dataResult['data']['dia']['hanhNgayChon'][index]}'
//                                                                         .tr
//                                                                         .toUpperCase() +
//                                                                     ' ➤ ',
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             maxLines: 1,
//                                                             style: TextAppStyle()
//                                                                 .superStyle()
//                                                                 .copyWith(
//                                                                     fontSize:
//                                                                         16,
//                                                                     color:
//                                                                         getColorByElement(widget.dataResult['data']['dia']['hanhNgayChon'][index] ?? 'tho')));
//                                                       }),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ],
//                                           )
//                                         : const SizedBox(),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     widget.code == 'tang-su'
//                                         ? Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               const SizedBox( height: 16),
//                                               Container(
//                                                 width:
//                                                     getResponsiveWidth(context),
//                                                 padding:
//                                                     const EdgeInsets.all(12),
//                                                 decoration: BoxDecoration(
//                                                     image: DecorationImage(
//                                                         image: AssetImage(
//                                                             ImageConstants
//                                                                 .img_bg_extend_important),
//                                                         fit: BoxFit.fill)),
//                                                 child: Stack(
//                                                   children: [
//                                                     Positioned.fill(
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Container(
//                                                             width:
//                                                                 getResponsiveWidth(
//                                                                         context) /
//                                                                     1.5,
//                                                             height:
//                                                                 getResponsiveWidth(
//                                                                         context) /
//                                                                     1.5,
//                                                             // height: getResponsiveWidth(context) / 2,
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(12),
//                                                             decoration: const BoxDecoration(
//                                                                 image: DecorationImage(
//                                                                     image: AssetImage(
//                                                                         'assets/images/img_bg_dainam_trans.png'),
//                                                                     fit: BoxFit
//                                                                         .fill)),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         const SizedBox( height: 4),
//                                                         Center(
//                                                           child: Text(
//                                                             'result_calculate_trung_tang'
//                                                                 .tr
//                                                                 .toUpperCase(),
//                                                             style: TextAppStyle()
//                                                                 .superStyleSmall(),
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           height: 0.5,
//                                                           margin:
//                                                               const EdgeInsets
//                                                                   .only(
//                                                                   top: 12,
//                                                                   bottom: 8),
//                                                           width:
//                                                               getResponsiveWidth(
//                                                                       context) -
//                                                                   72,
//                                                           decoration: BoxDecoration(
//                                                               color: AppColor
//                                                                   .textBrownColor),
//                                                         ),
//                                                         _case1ofTrungTang(),
//                                                         _case2and3ofTrungTang(),
//                                                         _case4ofTrungTang(),
//                                                         _case5ofTrungTang(),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               // const SizedBox( height: 8),
//                                               widget.dataResult['data']['case1']
//                                                       ['isPhamTrungTang']
//                                                   ? Column(
//                                                       children: [
//                                                         Container(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .only(
//                                                                   top: 16,
//                                                                   bottom: 4),
//                                                           child: Text(
//                                                             widget.dataResult[
//                                                                         'data']
//                                                                     ['case1']
//                                                                 ['conclusion'],
//                                                             style: TextAppStyle()
//                                                                 .semiBoldTextStyleSmall()
//                                                                 .copyWith(
//                                                                     color: AppColor
//                                                                         .colorRed),
//                                                           ),
//                                                         ),
//                                                         const SizedBox( height: 12),
//                                                         onTapWidget(
//                                                           onTap: () {
//                                                           },
//                                                           child: Center(
//                                                             child: Container(
//                                                               width: optimizedSize(
//                                                                   phone:
//                                                                       Get.width -
//                                                                           48,
//                                                                   zfold: (Get.width /
//                                                                           1.5) -
//                                                                       48,
//                                                                   tablet: (Get.width /
//                                                                           1.25) -
//                                                                       48,
//                                                                   context:
//                                                                       context),
//                                                               height:
//                                                                   optimizedSize(
//                                                                       phone: 54,
//                                                                       zfold: 62,
//                                                                       tablet:
//                                                                           74,
//                                                                       context:
//                                                                           context),
//                                                               decoration: const BoxDecoration(
//                                                                   image: DecorationImage(
//                                                                       image: AssetImage(
//                                                                           ButtonConstants
//                                                                               .btn_large_primary_active),
//                                                                       fit: BoxFit
//                                                                           .fill)),
//                                                               child: Center(
//                                                                 child: Text(
//                                                                   'book_expert'
//                                                                       .tr
//                                                                       .replaceAll(
//                                                                           '\n',
//                                                                           ' '),
//                                                                   style: custom3DTextStyle(
//                                                                       context),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         const SizedBox( height: 8),
//                                                       ],
//                                                     )
//                                                   : const SizedBox()
//                                             ],
//                                           )
//                                         : const SizedBox()
//                                   ],
//                                 ),
//                                 const SizedBox( height: 8),
//                                 widget.title == 'Trùng tang'
//                                     ? const SizedBox()
//                                     : Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             height: 0.5,
//                                             margin: const EdgeInsets.only(
//                                                 top: 12, bottom: 12),
//                                             width: getResponsiveWidth(context) -
//                                                 48,
//                                             decoration: BoxDecoration(
//                                                 color: AppColor.textBrownColor
//                                                     .withAlpha(
//                                                         (0.5 * 255).toInt())),
//                                           ),
//                                         ],
//                                       ),
//                                 widget.title == 'Trùng tang'
//                                     ? const SizedBox()
//                                     : widget.dataResult['data']['dateStart'] !=
//                                             widget.dataResult['data']['dateEnd']
//                                         ? resultWithRangeDay()
//                                         : resultWithTheOnlyDay(),
//                                 const SizedBox( height: 12),
//                                 widget.dataResult['data']['dateStart'] !=
//                                         widget.dataResult['data']['dateEnd']
//                                     ? const SizedBox()
//                                     : widget.title == 'Trùng tang'
//                                         ? const SizedBox()
//                                         : Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               RichText(
//                                                 text: TextSpan(
//                                                   text: 'day'.tr + ' ',
//                                                   style: TextAppStyle()
//                                                       .normalTextStyle()
//                                                       .copyWith(
//                                                         fontSize: 16.0,
//                                                       ),
//                                                   children: [
//                                                     TextSpan(
//                                                       text: '${widget.dataResult['data']['dateStart']} ' +
//                                                           checkDayMonthHours(widget
//                                                                           .dataResult[
//                                                                       'data'][
//                                                                   'errShowDayMonthShowOneDate'])
//                                                               .tr,
//                                                       style: TextAppStyle()
//                                                           .semiBoldTextStyle()
//                                                           .copyWith(
//                                                               color: checkDayMonthHours(
//                                                                           widget.dataResult['data']
//                                                                               [
//                                                                               'errShowDayMonthShowOneDate']) ==
//                                                                       'phu_hop'
//                                                                   ? AppColor
//                                                                       .colorGreen
//                                                                   : AppColor
//                                                                       .colorRed,
//                                                               decoration:
//                                                                   TextDecoration
//                                                                       .underline),
//                                                     ),
//                                                     TextSpan(
//                                                         text:
//                                                             ' ${'to_do_thing'.tr}',
//                                                         style: TextAppStyle()
//                                                             .normalTextStyle()),
//                                                     TextSpan(
//                                                         text:
//                                                             '''"${widget.title}".''',
//                                                         style: TextAppStyle()
//                                                             .normalTextStyle()
//                                                             .copyWith(
//                                                                 color: AppColor
//                                                                     .primaryColor)),
//                                                     TextSpan(
//                                                       text: checkDayMonthHours(
//                                                                   widget.dataResult[
//                                                                           'data']
//                                                                       [
//                                                                       'errShowDayMonthShowOneDate']) ==
//                                                               'phu_hop'
//                                                           ? ''
//                                                           : 'select_another_day_note'
//                                                               .tr,
//                                                       style: TextAppStyle()
//                                                           .semiBoldTextStyleSmall()
//                                                           .copyWith(
//                                                               color: checkDayMonthHours(
//                                                                           widget.dataResult['data']
//                                                                               [
//                                                                               'errShowDayMonthShowOneDate']) ==
//                                                                       'phu_hop'
//                                                                   ? AppColor
//                                                                       .colorGreenDark
//                                                                   : AppColor
//                                                                       .colorRed,
//                                                               fontStyle:
//                                                                   FontStyle
//                                                                       .normal),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                               const SizedBox( height: 24),
//                                               checkDayMonthHours(widget
//                                                                       .dataResult[
//                                                                   'data'][
//                                                               'errShowDayMonthShowOneDate']) ==
//                                                           'phu_hop' &&
//                                                       widget.dataResult['data']
//                                                               ?['arrDate'] !=
//                                                           null &&
//                                                       widget.dataResult['data']
//                                                           ['arrDate'] is List &&
//                                                       widget
//                                                           .dataResult['data']
//                                                               ['arrDate']
//                                                           .isNotEmpty
//                                                   ? Stack(
//                                                       children: [
//                                                         Container(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   vertical: 8),
//                                                           width:
//                                                               getResponsiveWidth(
//                                                                       context) -
//                                                                   48,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             border: const GradientBoxBorder(
//                                                                 width: 2,
//                                                                 gradient: LinearGradient(
//                                                                     colors: CommonConstants
//                                                                         .gradientsLight)),
//                                                             image: DecorationImage(
//                                                                 image: AssetImage(
//                                                                     FrameConstants
//                                                                         .fr_background_stable),
//                                                                 fit: BoxFit
//                                                                     .fill),
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         8),
//                                                           ),
//                                                           child: Stack(
//                                                             children: [
//                                                               Column(
//                                                                 children: [
//                                                                   const SizedBox( height: 
//                                                                       8),
//                                                                   Text(
//                                                                     'solar'
//                                                                         .tr
//                                                                         .toUpperCase(),
//                                                                     style: TextAppStyle()
//                                                                         .semiBoldTextStyle(),
//                                                                   ),
//                                                                   Text(
//                                                                     widget.dataResult['data']?['arrDate']?[0]
//                                                                             ?[
//                                                                             'dateSolar'] ??
//                                                                         '',
//                                                                     style: TextAppStyle()
//                                                                         .thinTextStyleSmall(),
//                                                                   ),
//                                                                   const SizedBox( height: 
//                                                                       12),
//                                                                   Text(
//                                                                     'lunar'
//                                                                         .tr
//                                                                         .replaceAll(
//                                                                             '\n',
//                                                                             ' ')
//                                                                         .toUpperCase(),
//                                                                     style: TextAppStyle()
//                                                                         .semiBoldTextStyle(),
//                                                                   ),

//                                                                   Row(
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .center,
//                                                                     children: [
//                                                                       Text(
//                                                                         (widget.dataResult['data']?['arrDate']?[0]?['dateLunar'] ??
//                                                                                 '') +
//                                                                             ' - ',
//                                                                         style: TextAppStyle()
//                                                                             .thinTextStyleSmall(),
//                                                                       ),
//                                                                       const SizedBox(width: 
//                                                                           4),
//                                                                       Text(
//                                                                         'ngu_hanh_ngay'.tr +
//                                                                             ': ',
//                                                                         style: TextAppStyle()
//                                                                             .thinTextStyleSmall(),
//                                                                       ),
//                                                                       Text(
//                                                                         '${widget.dataResult['data']?['arrDate']?[0]?['nguHanhNgay'] ?? ''}'
//                                                                             .tr
//                                                                             .toUpperCase(),
//                                                                         style: TextAppStyle()
//                                                                             .titleStyleSmall()
//                                                                             .copyWith(color: getColorByElement(widget.dataResult['data']['arrDate'][0]['nguHanhNgay'])),
//                                                                       )
//                                                                     ],
//                                                                   ),
//                                                                   // Row(
//                                                                   //   mainAxisAlignment:
//                                                                   //       MainAxisAlignment
//                                                                   //           .center,
//                                                                   //   children: [
//                                                                   //     Text(
//                                                                   //       widget.dataResult['data']?['arrDate']?[0]?['dateLunar'] ??
//                                                                   //           '',
//                                                                   //       style: TextAppStyle()
//                                                                   //           .thinTextStyle(),
//                                                                   //     ),
//                                                                   //     const SizedBox(width: 
//                                                                   //         4),
//                                                                   //     Text(
//                                                                   //       '${widget.dataResult['data']?['arrDate']?[0]?['nguHanhNgay'] ?? ''}'
//                                                                   //           .tr
//                                                                   //           .toUpperCase(),
//                                                                   //       style: TextAppStyle()
//                                                                   //           .titleStyle()
//                                                                   //           .copyWith(color: getColorByElement(widget.dataResult['data']?['arrDate']?[0]?['nguHanhNgay'] ?? '')),
//                                                                   //     ),
//                                                                   //   ],
//                                                                   // ),
//                                                                   const SizedBox( height: 
//                                                                       12),
//                                                                   Text(
//                                                                     '${widget.dataResult['data']?['arrDate']?[0]?['canChiNgay'] ?? ''}'.tr +
//                                                                         ' / ' +
//                                                                         '${widget.dataResult['data']?['arrDate']?[0]?['canChiThang'] ?? ''}'
//                                                                             .tr +
//                                                                         ' / ' +
//                                                                         '${widget.dataResult['data']?['arrDate']?[0]?['canChiNam'] ?? ''}'
//                                                                             .tr,
//                                                                     style: TextAppStyle()
//                                                                         .normalTextStyle(),
//                                                                   ),
//                                                                   const SizedBox( height: 
//                                                                       12),
//                                                                   Text(
//                                                                     'hour'
//                                                                         .tr
//                                                                         .toUpperCase(),
//                                                                     style: TextAppStyle()
//                                                                         .semiBoldTextStyle(),
//                                                                   ),
//                                                                   const SizedBox( height: 
//                                                                       12),
//                                                                   Wrap(
//                                                                     alignment:
//                                                                         WrapAlignment
//                                                                             .center,
//                                                                     spacing: 0,
//                                                                     runSpacing:
//                                                                         16,
//                                                                     children: List.generate(
//                                                                         widget.dataResult['data']?['arrDate']?[0]?['gio']?.length ??
//                                                                             0,
//                                                                         (idx) {
//                                                                       final gioData =
//                                                                           widget.dataResult['data']?['arrDate']?[0]?['gio']?[idx] ??
//                                                                               {};
//                                                                       return SizedBox(
//                                                                         width: (getResponsiveWidth(context) -
//                                                                                 48 -
//                                                                                 24 -
//                                                                                 12 -
//                                                                                 12 -
//                                                                                 4) /
//                                                                             2,
//                                                                         child:
//                                                                             Row(
//                                                                           mainAxisAlignment:
//                                                                               MainAxisAlignment.center,
//                                                                           children: [
//                                                                             ClipOval(
//                                                                               child: SizedBox(
//                                                                                 width: maxWidth > 500 ? 66 : 54,
//                                                                                 height: maxWidth > 500 ? 66 : 54,
//                                                                                 child: Image.asset(
//                                                                                   getZodiacImage(gioData['order'] ?? 0),
//                                                                                   fit: BoxFit.contain,
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                             const SizedBox(width: 4),
//                                                                             Expanded(
//                                                                               child: Column(
//                                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                 children: [
//                                                                                   Text(
//                                                                                     '${gioData['name'] ?? ''}'.tr,
//                                                                                     maxLines: 1,
//                                                                                     overflow: TextOverflow.ellipsis,
//                                                                                     style: TextAppStyle().titleStyleSmall().copyWith(fontSize: maxWidth > 500 ? 18 : 14),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     '${formatHour(gioData['start'] ?? '')}-${formatHour(gioData['end'] ?? '')}'.tr,
//                                                                                     maxLines: 1,
//                                                                                     overflow: TextOverflow.ellipsis,
//                                                                                     style: TextAppStyle().thinTextStyle().copyWith(fontSize: maxWidth > 500 ? 16 : 12),
//                                                                                   ),
//                                                                                   Text(
//                                                                                     '${gioData['nguHanh'] ?? ''}'.tr,
//                                                                                     style: TextAppStyle().semiBoldTextStyle().copyWith(fontSize: maxWidth > 500 ? 16 : 12, color: getColorByElement(gioData['nguHanh'] ?? '')),
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       );
//                                                                     }),
//                                                                   ),
//                                                                   const SizedBox( height: 
//                                                                       12),
//                                                                   Row(
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .center,
//                                                                     children: [
//                                                                       Text(
//                                                                         'TRỰC: ',
//                                                                         style: TextAppStyle()
//                                                                             .semiBoldTextStyle(),
//                                                                       ),
//                                                                       Text(
//                                                                         '${widget.dataResult['data']?['arrDate']?[0]?['truc'] ?? ''}'
//                                                                             .tr
//                                                                             .toUpperCase(),
//                                                                         style: TextAppStyle()
//                                                                             .titleStyle()
//                                                                             .copyWith(color: AppColor.colorGreenDark),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   const SizedBox( height: 
//                                                                       4),
//                                                                   Row(
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .center,
//                                                                     children: [
//                                                                       Text(
//                                                                         'TÚ: ',
//                                                                         style: TextAppStyle()
//                                                                             .semiBoldTextStyle(),
//                                                                       ),
//                                                                       Text(
//                                                                         '${widget.dataResult['data']?['arrDate']?[0]?['tu'] ?? ''}'
//                                                                             .tr
//                                                                             .toUpperCase(),
//                                                                         style: TextAppStyle()
//                                                                             .titleStyle()
//                                                                             .copyWith(color: AppColor.colorGreenDark),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   const SizedBox( height: 
//                                                                       8),
//                                                                 ],
//                                                               ),
//                                                               Positioned(
//                                                                 right: 8,
//                                                                 bottom: 0,
//                                                                 child:
//                                                                     onTapWidget(
//                                                                   onTap:
//                                                                       () async {
//                                                                     await EasyLoading.show(
//                                                                         maskType:
//                                                                             EasyLoadingMaskType.black);
//                                                                     final query = Map<
//                                                                         String,
//                                                                         dynamic>.from(widget
//                                                                             .dataResult['data']
//                                                                         [
//                                                                         'arrDate'][0]);
//                                                                     query[
//                                                                         'tuoiGiaChu'] = widget
//                                                                             .dataResult['data']
//                                                                         [
//                                                                         'tuoiGiaChu'];
//                                                                     query['type'] =
//                                                                         widget
//                                                                             .type;
//                                                                     if (widget.dataResult['data']?['dia']?['toaNha']
//                                                                             ?[
//                                                                             'key'] !=
//                                                                         null) {
//                                                                       query[
//                                                                           'toa'] = widget
//                                                                               .dataResult['data']!['dia']!['toaNha']![
//                                                                           'key'];
//                                                                     }
//                                                                     _getHonoScopes(
//                                                                         data: jsonEncode(
//                                                                             query));
//                                                                   },
//                                                                   child: Row(
//                                                                     children: [
//                                                                       Image.asset(
//                                                                         IconConstants
//                                                                             .ic_btn_dainam,
//                                                                         width:
//                                                                             40,
//                                                                         height:
//                                                                             40,
//                                                                       ),
//                                                                       const SizedBox(width: 
//                                                                           4),
//                                                                       Image.asset(
//                                                                         ImageConstants
//                                                                             .img_next_tab_feng_shui,
//                                                                         width:
//                                                                             20,
//                                                                       )
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     )
//                                                   : const SizedBox(),
//                                               const SizedBox( height: 24),
//                                               checkDayMonthHours(widget
//                                                                   .dataResult[
//                                                               'data'][
//                                                           'errShowDayMonthShowOneDate']) ==
//                                                       'phu_hop'
//                                                   ? const SizedBox()
//                                                   : onTapWidget(
//                                                       onTap: () {
//                                                       },
//                                                       child: Center(
//                                                         child: Container(
//                                                           width: optimizedSize(
//                                                               phone: Get.width -
//                                                                   48,
//                                                               zfold:
//                                                                   (Get.width /
//                                                                           1.5) -
//                                                                       48,
//                                                               tablet:
//                                                                   (Get.width /
//                                                                           1.25) -
//                                                                       48,
//                                                               context: context),
//                                                           height: optimizedSize(
//                                                               phone: 54,
//                                                               zfold: 62,
//                                                               tablet: 74,
//                                                               context: context),
//                                                           decoration: BoxDecoration(
//                                                               image: DecorationImage(
//                                                                   image: AssetImage(
//                                                                       ButtonConstants
//                                                                           .btn_large_primary_active),
//                                                                   fit: BoxFit
//                                                                       .fill)),
//                                                           child: Center(
//                                                             child: Text(
//                                                               'book_expert'
//                                                                   .tr
//                                                                   .replaceAll(
//                                                                       '\n',
//                                                                       ' '),
//                                                               style:
//                                                                   custom3DTextStyle(
//                                                                       context),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                             ],
//                                           ),
//                                 const SizedBox( height: 80),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Additional widgets or content below if needed
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         titleAppbar: capitalForText(widget.aim));
//   }

//   Widget _case1ofTrungTang() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12)
//               .copyWith(bottom: 2, top: 1),
//           decoration: BoxDecoration(
//               color: widget.dataResult['data']['case3']['isPham'] == true
//                   ? AppColor.colorRedBold
//                   : AppColor.textBrownColor,
//               borderRadius: BorderRadius.circular(4)),
//           child: Text(
//             'Trùng Tang',
//             style: TextAppStyle().semiBoldTextStyleSmallLight(),
//           ),
//         ),
//         const SizedBox( height: 8),
//         Container(
//           padding: const EdgeInsets.only(left: 6, top: 4, bottom: 6),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '• Năm ' +
//                     '${widget.dataResult['data']['case1']['year']['namCan']}'
//                         .tr +
//                     ' ' +
//                     '${widget.dataResult['data']['case1']['year']['namChi']}'
//                         .tr +
//                     ': ' +
//                     '${widget.dataResult['data']['case1']['year']['text']}'.tr,
//                 style: TextAppStyle().normalTextStyleSmall().copyWith(
//                     color: getColorByDeathType(
//                         widget.dataResult['data']['case1']['year']['text'])),
//               ),
//               const SizedBox( height: 1),
//               Text(
//                 '• Tháng ' +
//                     '${widget.dataResult['data']['case1']['month']['thangCan']}'
//                         .tr +
//                     ' ' +
//                     '${widget.dataResult['data']['case1']['month']['thangChi']}'
//                         .tr +
//                     ': ' +
//                     '${widget.dataResult['data']['case1']['month']['text']}'.tr,
//                 style: TextAppStyle().normalTextStyleSmall().copyWith(
//                     color: getColorByDeathType(
//                         widget.dataResult['data']['case1']['month']['text'])),
//               ),
//               const SizedBox( height: 1),
//               Text(
//                 '• Ngày ' +
//                     '${widget.dataResult['data']['case1']['day']['dayCan']}'
//                         .tr +
//                     ' ' +
//                     '${widget.dataResult['data']['case1']['day']['dayChi']}'
//                         .tr +
//                     ': ' +
//                     '${widget.dataResult['data']['case1']['day']['text']}'.tr,
//                 style: TextAppStyle().normalTextStyleSmall().copyWith(
//                     color: getColorByDeathType(
//                         widget.dataResult['data']['case1']['day']['text'])),
//               ),
//               const SizedBox( height: 1),
//               Text(
//                 '• Giờ ' +
//                     '${widget.dataResult['data']['case1']['hour']['gioCan']}'
//                         .tr +
//                     ' ' +
//                     '${widget.dataResult['data']['case1']['hour']['gioChi']}'
//                         .tr +
//                     ': ' +
//                     '${widget.dataResult['data']['case1']['hour']['text']}'.tr,
//                 style: TextAppStyle().normalTextStyleSmall().copyWith(
//                     color: getColorByDeathType(
//                         widget.dataResult['data']['case1']['hour']['text'])),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox( height: 2),
//         Text(
//           widget.dataResult['data']['case1']['isPhamTrungTang']
//               ? '➤ Phạm trùng tang'
//               : '➤ ${'khong_pham'.tr}',
//           style: TextAppStyle().titleStyleSmall().copyWith(
//               color: widget.dataResult['data']['case1']['isPhamTrungTang']
//                   ? AppColor.colorRedBold
//                   : AppColor.textBrownColor),
//         ),
//       ],
//     );
//   }

//   Widget _case2and3ofTrungTang() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 0.5,
//           margin: const EdgeInsets.only(top: 12, bottom: 8),
//           width: getResponsiveWidth(context) - 72,
//           decoration: BoxDecoration(color: AppColor.textBrownColor),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12)
//               .copyWith(bottom: 2, top: 1),
//           decoration: BoxDecoration(
//               color: widget.dataResult['data']['case3']['isPham'] == true
//                   ? AppColor.colorRedBold
//                   : AppColor.textBrownColor,
//               borderRadius: BorderRadius.circular(4)),
//           child: Text(
//             'Trùng Tang Liên Táng',
//             style: TextAppStyle().semiBoldTextStyleSmallLight(),
//           ),
//         ),
//         const SizedBox( height: 8),
//         Container(
//           padding: const EdgeInsets.only(left: 6, top: 4, bottom: 8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: RichText(
//             text: TextSpan(
//               text: '• Tuổi '.tr,
//               style: TextAppStyle().normalTextStyleSmall(),
//               children: [
//                 TextSpan(
//                     text:
//                         '${widget.dataResult['data']['trungTangLienTang']['tuoi']}'
//                             .tr,
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text: ' mất năm ',
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text:
//                         '${widget.dataResult['data']['trungTangLienTang']['chiNamMat']}'
//                             .tr,
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text: ', tháng ',
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text:
//                         '${widget.dataResult['data']['trungTangLienTang']['chiThangMat']}'
//                             .tr,
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text: ', ngày ',
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text:
//                         '${widget.dataResult['data']['trungTangLienTang']['chiNgayMat']}'
//                             .tr,
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text: ', giờ ',
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text:
//                         '${widget.dataResult['data']['trungTangLienTang']['chiGioMat']}'
//                             .tr,
//                     style: TextAppStyle().normalTextStyleSmall()),
//               ],
//             ),
//           ),
//         ),
//         widget.dataResult['data']['case3']['isPham'] == true
//             ? Text(
//                 '➤ Phạm trùng tang',
//                 style: TextAppStyle()
//                     .titleStyleSmall()
//                     .copyWith(color: AppColor.colorRedBold),
//               )
//             : Text(
//                 '➤ Không Phạm',
//                 style: TextAppStyle()
//                     .titleStyleSmall()
//                     .copyWith(color: AppColor.textBrownColor),
//               ),
//       ],
//     );
//   }

//   Widget _case4ofTrungTang() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 0.5,
//           margin: const EdgeInsets.only(top: 8, bottom: 8),
//           width: getResponsiveWidth(context) - 72,
//           decoration: BoxDecoration(color: AppColor.textBrownColor),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12)
//               .copyWith(bottom: 2, top: 1),
//           decoration: BoxDecoration(
//               color: widget.dataResult['data']['case4']['isPham'] == true
//                   ? AppColor.colorRedBold
//                   : AppColor.textBrownColor,
//               borderRadius: BorderRadius.circular(4)),
//           child: Text(
//             'Ngày Thần Trùng',
//             style: TextAppStyle().semiBoldTextStyleSmallLight(),
//           ),
//         ),
//         const SizedBox( height: 8),
//         Container(
//           padding: const EdgeInsets.only(left: 6, top: 4, bottom: 4),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: RichText(
//             text: TextSpan(
//               text: '• Tuổi '.tr,
//               style: TextAppStyle().normalTextStyleSmall(),
//               children: [
//                 TextSpan(
//                     text:
//                         '${widget.dataResult['data']['ngayThanTrung']['tuoi']}'
//                             .tr,
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text: ', ngày ',
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text: '${widget.dataResult['data']['ngayThanTrung']['canNgayMat']}'
//                             .tr +
//                         ' ' +
//                         '${widget.dataResult['data']['ngayThanTrung']['chiNgayMat']}'
//                             .tr,
//                     style: TextAppStyle().normalTextStyleSmall()),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox( height: 4),
//         widget.dataResult['data']['case4']['isPham'] == true
//             ? Text(
//                 '➤ Phạm trùng tang',
//                 style: TextAppStyle()
//                     .titleStyleSmall()
//                     .copyWith(color: AppColor.colorRedBold),
//               )
//             : Text(
//                 '➤ Không Phạm ngày Thần trùng',
//                 style: TextAppStyle()
//                     .titleStyleSmall()
//                     .copyWith(color: AppColor.textBrownColor),
//               ),
//       ],
//     );
//   }

//   Widget _case5ofTrungTang() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 0.5,
//           margin: const EdgeInsets.only(top: 8, bottom: 8),
//           width: getResponsiveWidth(context) - 72,
//           decoration: BoxDecoration(color: AppColor.textBrownColor),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12)
//               .copyWith(bottom: 2, top: 1),
//           decoration: BoxDecoration(
//               color: widget.dataResult['data']['case5']['isPham'] == true
//                   ? AppColor.colorRedBold
//                   : AppColor.textBrownColor,
//               borderRadius: BorderRadius.circular(4)),
//           child: Text(
//             'Ngày Trùng Phục',
//             style: TextAppStyle().semiBoldTextStyleSmallLight(),
//           ),
//         ),
//         const SizedBox( height: 8),
//         Container(
//           padding: const EdgeInsets.only(left: 6, top: 4, bottom: 4),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: RichText(
//             text: TextSpan(
//               text: '• Tuổi '.tr,
//               style: TextAppStyle().normalTextStyleSmall(),
//               children: [
//                 TextSpan(
//                     text:
//                         '${widget.dataResult['data']['ngayTrungPhuc']['tuoi']}'
//                             .tr,
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text: ', ngày ',
//                     style: TextAppStyle().normalTextStyleSmall()),
//                 TextSpan(
//                     text: '${widget.dataResult['data']['ngayTrungPhuc']['canNgayMat']}'
//                             .tr +
//                         ' ' +
//                         '${widget.dataResult['data']['ngayTrungPhuc']['chiNgayMat']}'
//                             .tr,
//                     style: TextAppStyle().normalTextStyleSmall()),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox( height: 4),
//         widget.dataResult['data']['case5']['isPham'] == true
//             ? Text(
//                 '➤ Phạm trùng tang',
//                 style: TextAppStyle()
//                     .titleStyleSmall()
//                     .copyWith(color: AppColor.colorRedBold),
//               )
//             : Text(
//                 '➤ Không phạm ngày Trùng phục',
//                 style: TextAppStyle()
//                     .titleStyleSmall()
//                     .copyWith(color: AppColor.textBrownColor),
//               ),
//       ],
//     );
//   }

//   Widget _weeding() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               width: 48,
//               height: 0.5,
//               decoration: BoxDecoration(
//                   gradient:
//                       LinearGradient(colors: CommonConstants.gradientBrownBtn)),
//             ),
//             const SizedBox(width: 4),
//             ColorFiltered(
//                 colorFilter:
//                     ColorFilter.mode(AppColor.primaryColor, BlendMode.srcATop),
//                 child: Image.asset(
//                   IconConstants.ic_male_avatar,
//                   width: 16,
//                 )),
//             const SizedBox(width: 4),
//             Text(
//               'male'.tr,
//               style: TextAppStyle()
//                   .semiBoldTextStyleSmall()
//                   .copyWith(fontSize: 14, color: AppColor.primaryColor),
//             ),
//           ],
//         ),
//         const SizedBox( height: 4),
//         Row(
//           children: [
//             Text('${'full_name'.tr}: ', style: TextAppStyle().titleStyle()),
//             Expanded(
//               child: Text(widget.name == '' ? 'user_unknown'.tr : widget.name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextAppStyle().normalTextStyle()),
//             ),
//           ],
//         ),
//         const SizedBox( height: 8),
//         Row(
//           children: [
//             Text('${'dob_year'.tr}: ', style: TextAppStyle().titleStyle()),
//             Expanded(
//               child: Text(
//                  '${widget.dataResult['data']['infoGiaChu']['tuoiGiaChu']}'
//                           ' (${(widget.dataResult['data']['tuoiCanGiaChuNam']?.toString().tr ?? '') + ' ' + (widget.dataResult['data']['tuoiChiGiaChuNam']?.toString().tr ?? '')})',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextAppStyle().normalTextStyle()),
//             ),
//           ],
//         ),
//         const SizedBox( height: 16),

//         Row(
//           children: [
//             Container(
//               width: 48,
//               height: 0.5,
//               decoration: BoxDecoration(
//                   gradient:
//                       LinearGradient(colors: CommonConstants.gradientBrownBtn)),
//             ),
//             const SizedBox(width: 4),
//             ColorFiltered(
//                 colorFilter:
//                     ColorFilter.mode(AppColor.primaryColor, BlendMode.srcATop),
//                 child: Image.asset(
//                   IconConstants.ic_female_avatar,
//                   width: 16,
//                 )),
//             const SizedBox(width: 4),
//             Text(
//               'female'.tr,
//               style: TextAppStyle()
//                   .semiBoldTextStyleSmall()
//                   .copyWith(fontSize: 14, color: AppColor.primaryColor),
//             ),
//           ],
//         ),
//         // Row(
//         //   children: [
//         //     Container(
//         //       height: 0.5,
//         //       margin: const EdgeInsets.only(top: 12, bottom: 12),
//         //       width: 48,
//         //       decoration:
//         //           BoxDecoration(color: AppColor.pinkColor.withAlpha((0.25 * 255).toInt())),
//         //     ),
//         //     Icon(
//         //       Icons.female_rounded,
//         //       color: AppColor.pinkColor,
//         //     ),
//         //     Text(
//         //       'female'.tr,
//         //       style: TextAppStyle()
//         //           .titleStyleLight()
//         //           .copyWith(fontSize: 16, color: AppColor.pinkColor),
//         //     ),
//         //   ],
//         // ),
//         const SizedBox( height: 4),
//         Row(
//           children: [
//             Text('${'full_name'.tr}: ', style: TextAppStyle().titleStyle()),
//             Expanded(
//               child: Text(
//                   widget.wfName == '' ? 'user_unknown'.tr : widget.wfName,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextAppStyle().normalTextStyle()),
//             ),
//           ],
//         ),
//         const SizedBox( height: 8),
//         Row(
//           children: [
//             Text('${'dob_year'.tr}: ', style: TextAppStyle().titleStyle()),
//             Expanded(
//               child: Text(widget.wfDob,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextAppStyle().normalTextStyle()),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Future<void> _getHonoScopes({required String data}) async {
//     final url = '$mainUrl/horoscopes?selectedData=$data';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'accept': 'application/json',
//         },
//       );
//       printConsole(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         EasyLoading.dismiss();
//         Get.to(() => HonoScopeScreen(
//               data: data,
//               name: widget.name,
//               title: widget.title,
//               dob: '${widget.dataResult['data']['infoGiaChu']['tuoiGiaChu']}'
//                       ' (${(widget.dataResult['data']['tuoiCanGiaChu']?.toString().tr ?? '') + ' ' + (widget.dataResult['data']['tuoiChiGiaChu']?.toString().tr ?? '')})',
//               borrow: widget.borrowDate,
//               homeCoor: isIncludingDIAInside(widget.type)
//                   ? '${widget.dataResult['data']['dia']['toaNha']['key']}'
//                   : '',
//               selectDate: isIncludingDIAInside(widget.type)
//                   ? widget.dataResult['data']['dia']['hanhNgayChon']
//                   : [],
//               nguHanh: isIncludingDIAInside(widget.type)
//                   ? '${widget.dataResult['data']['dia']['toaNha']['nguHanh']}'
//                   : '',
//             ));
//       } else {
//         EasyLoading.dismiss();

//         // Handle the error
//         printConsole('Failed to load horoscopes: ${response.statusCode}');
//       }
//     } catch (e) {
//       EasyLoading.dismiss();

//       // Handle any exceptions
//       printConsole('Error fetching horoscopes: $e');
//     }
//   }

//   Future<void> _shareResult() async {
//     setState(() {
//       isCapturing = true;
//     });
//     await EasyLoading.show(maskType: EasyLoadingMaskType.black);

//     final directory = await getApplicationDocumentsDirectory();
//     final imagePath = await screenshotController.captureAndSave(
//       directory.path,
//       fileName: 'screenshot.png',
//     );

//     if (imagePath != null) {
//       // Nén ảnh
//       final compressedImagePath = await compressImageString(imagePath);
//       setState(() {
//         isCapturing = false;
//       });
//       await EasyLoading.dismiss();
//       Share.shareXFiles([XFile(compressedImagePath)]);
//     } else {
//       setState(() {
//         isCapturing = false;
//       });
//       // Trường hợp không lấy được ảnh
//       await EasyLoading.dismiss();
//       // Xử lý lỗi ở đây (nếu cần)
//     }
//   }

//   Widget _infoTHIENArea() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Center(
//           child: Image.asset(
//             '' == 'vi'
//                 ? FrameConstants.fr_thien_label
//                 : '' == 'en'
//                     ? FrameConstants.fr_thien_label_en
//                     : FrameConstants.fr_thien_label_zh,
//             width: optimizedSize(
//                 phone: 100, zfold: 148, tablet: 180, context: context),
//             fit: BoxFit.fitHeight,
//           ),
//         ),
//         const SizedBox( height: 8),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('${'time'.tr}: ', style: TextAppStyle().titleStyle()),
//             widget.dataResult['data']['dateStart'] ==
//                     widget.dataResult['data']['dateEnd']
//                 ? Text(
//                     'day'.tr +
//                         ' ' +
//                         widget.dataResult['data']['dateStart'] +
//                         ' (${'duong_lich_short'.tr})',
//                     style: TextAppStyle().normalTextStyle())
//                 : Column(
//                     children: [
//                       Text(
//                           'from'.tr +
//                               ' ' +
//                               'day'.tr.toLowerCase() +
//                               ' ' +
//                               widget.dataResult['data']['dateStart'] +
//                               '(${'duong_lich_short'.tr})',
//                           style: TextAppStyle().normalTextStyle()),
//                       Text(
//                           'to'.tr +
//                               ' ' +
//                               'day'.tr.toLowerCase() +
//                               ' ' +
//                               widget.dataResult['data']['dateEnd'] +
//                               '(${'duong_lich_short'.tr})',
//                           style: TextAppStyle().normalTextStyle())
//                     ],
//                   ),
//           ],
//         ),
//         Container(
//           height: 0.5,
//           margin: const EdgeInsets.only(top: 12, bottom: 12),
//           width: getResponsiveWidth(context) - 48,
//           decoration: BoxDecoration(
//               color: AppColor.textBrownColor.withAlpha((0.5 * 255).toInt())),
//         ),
//       ],
//     );
//   }

//   Widget resultWithTheOnlyDay() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'result'.tr + ':',
//           style: TextAppStyle().titleStyle(),
//         ),
//         const SizedBox( height: 8),
//         Container(
//           decoration: BoxDecoration(
//               border: GradientBoxBorder(
//                   gradient: LinearGradient(
//                       colors: checkDayMonthHours(widget.dataResult['data']
//                                   ['errShowDayMonthShowOneDate']) ==
//                               'phu_hop'
//                           ? [
//                               AppColor.colorGreen,
//                               AppColor.colorGreenDark,
//                             ]
//                           : CommonConstants.gradientRedText),
//                   width: 1),
//               image: DecorationImage(
//                   image: AssetImage(ImageConstants.img_bg_manage_book_expert),
//                   fit: BoxFit.cover),
//               borderRadius: BorderRadius.circular(8),
//               color: AppColor.whiteColor),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       'month'.tr + ' ➤',
//                       style: TextAppStyle().normalTextStyle(),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${widget.dataResult['data']['errShowDayMonthShowOneDate']['month']}'
//                           .tr,
//                       style: TextAppStyle().semiBoldTextStyle().copyWith(
//                           color: widget.dataResult['data']
//                                               ['errShowDayMonthShowOneDate']
//                                           ['month'] ==
//                                       'phu_hop' ||
//                                   widget.dataResult['data']
//                                               ['errShowDayMonthShowOneDate']
//                                           ['month'] ==
//                                       'phu_hop'.tr
//                               ? AppColor.colorGreen
//                               : AppColor.colorRed),
//                     ),
//                   ],
//                 ),
//                 const SizedBox( height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       'day'.tr + ' ➤',
//                       style: TextAppStyle().normalTextStyle(),
//                     ),
//                     const SizedBox(width: 8),
//                     Flexible(
//                       child: Text(
//                         '${widget.dataResult['data']['errShowDayMonthShowOneDate']['day']}'
//                             .tr,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextAppStyle().semiBoldTextStyle().copyWith(
//                             color: widget.dataResult['data']
//                                                 ['errShowDayMonthShowOneDate']
//                                             ['day'] ==
//                                         'phu_hop' ||
//                                     widget.dataResult['data']
//                                                 ['errShowDayMonthShowOneDate']
//                                             ['day'] ==
//                                         'phu_hop'.tr
//                                 ? AppColor.colorGreen
//                                 : AppColor.colorRed),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox( height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       'hour'.tr + ' ➤',
//                       style: TextAppStyle().normalTextStyle(),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${widget.dataResult['data']['errShowDayMonthShowOneDate']['hours']}'
//                           .tr,
//                       style: TextAppStyle().semiBoldTextStyle().copyWith(
//                           color: widget.dataResult['data']
//                                               ['errShowDayMonthShowOneDate']
//                                           ['hours'] ==
//                                       'phu_hop' ||
//                                   widget.dataResult['data']
//                                               ['errShowDayMonthShowOneDate']
//                                           ['hours'] ==
//                                       'phu_hop'.tr
//                               ? AppColor.colorGreen
//                               : AppColor.colorRed),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget resultWithRangeDay() {
//     double maxWidth = MediaQuery.of(context).size.width;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         widget.dataResult['data']['arrDate'].length > 0
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox( height: 12),
//                   Text(
//                     'result'.tr + ':',
//                     style: TextAppStyle().titleStyle(),
//                   ),
//                   const SizedBox( height: 8),
//                   RichText(
//                     text: TextSpan(
//                       text: 'have'.tr,
//                       style: TextAppStyle().normalTextStyle(),
//                       children: [
//                         TextSpan(
//                             text:
//                                 '${widget.dataResult['data']['arrDate'].length}' +
//                                     'have_day'.tr.toLowerCase(),
//                             style: TextAppStyle().semiBoldTextStyle().copyWith(
//                                 color: AppColor.colorGreen,
//                                 decoration: TextDecoration.underline)),
//                         TextSpan(
//                             text: 'to_do_thing'.tr,
//                             style: TextAppStyle().normalTextStyle()),
//                         TextSpan(
//                             text: '''"${widget.title}".''',
//                             style: TextAppStyle()
//                                 .normalTextStyle()
//                                 .copyWith(color: AppColor.primaryColor)),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 12, bottom: 12),
//                     decoration: BoxDecoration(
//                         border: const GradientBoxBorder(
//                             width: 0.5,
//                             gradient: LinearGradient(
//                               colors: CommonConstants.name,
//                             )),
//                         image: const DecorationImage(
//                             image: AssetImage(
//                                 ImageConstants.img_bg_manage_book_expert),
//                             fit: BoxFit.fill),
//                         borderRadius: BorderRadius.circular(8),
//                         color: AppColor.whiteColor),
//                     child: Stack(
//                       children: [
//                         Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                             child: Text('have_date_note'.tr,
//                                 style: TextAppStyle()
//                                     .thinTextStyleSmall()
//                                     .copyWith(color: AppColor.primaryColor))),
//                       ],
//                     ),
//                   ),
//                   if (itemsToShow.isNotEmpty)
//                     Column(
//                       children: List.generate(itemsToShow.length, (index) {
//                         return Column(
//                           children: [
//                             Theme(
//                               data: Theme.of(context)
//                                   .copyWith(dividerColor: Colors.transparent),
//                               child: ExpansionTile(
//                                 tilePadding: const EdgeInsets.only(left: 4),
//                                 // trailing: Icon(
//                                 //   Icons.arrow_right_alt_rounded,
//                                 //   color:
//                                 //       AppColor.newPrimaryColor1,
//                                 //   size: 24,
//                                 // ),
//                                 title: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           width: 4,
//                                           height: 36,
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   const BorderRadius.only(
//                                                       bottomLeft:
//                                                           Radius.circular(32),
//                                                       topLeft:
//                                                           Radius.circular(32)),
//                                               color: getColorByStatus(
//                                                   widget.dataResult['data']
//                                                               ['arrDate'][index]
//                                                           ['textStatusDate'] ??
//                                                       'tho')),
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Image.asset(
//                                           IconConstants.ic_bmb_center_active,
//                                           width: 10,
//                                           height: 10,
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Text(
//                                           widget.dataResult['data']['arrDate']
//                                               [index]['dateSolar'],
//                                           style:
//                                               TextAppStyle().normalTextStyle(),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: List.generate(4, (i) {
//                                         if (i <
//                                             getStarCount(
//                                                 widget.dataResult['data']
//                                                         ['arrDate'][index]
//                                                     ['textStatusDate'])) {
//                                           return const GradientIcon(
//                                             icon: Icons.star,
//                                             size: 28,
//                                             gradient: LinearGradient(
//                                                 colors: CommonConstants.button),
//                                           );
//                                         } else {
//                                           return const GradientIcon(
//                                             icon: Icons.star_border,
//                                             size: 28,
//                                             gradient: LinearGradient(
//                                                 colors: CommonConstants.button),
//                                           );
//                                         }
//                                       }),
//                                     )
//                                   ],
//                                 ),
//                                 collapsedIconColor: AppColor.newPrimaryColor1,
//                                 iconColor: AppColor.grayTextwhiteColor,
//                                 children: [
//                                   Stack(
//                                     children: [
//                                       Positioned.fill(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               width:
//                                                   getResponsiveWidth(context) /
//                                                       1.6,
//                                               height:
//                                                   getResponsiveWidth(context) /
//                                                       1.6,
//                                               // height: getResponsiveWidth(context) / 2,
//                                               padding: const EdgeInsets.all(12),
//                                               decoration: const BoxDecoration(
//                                                   image: DecorationImage(
//                                                       image: AssetImage(
//                                                           'assets/images/img_bg_dainam_trans.png'),
//                                                       fit: BoxFit.fill)),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.all(12),
//                                         width: getResponsiveWidth(context) - 48,
//                                         // height: Get.width - 72,
//                                         decoration: BoxDecoration(
//                                           border: const GradientBoxBorder(
//                                               width: 2,
//                                               gradient: LinearGradient(
//                                                   colors: CommonConstants
//                                                       .gradientsLight)),
//                                           image: DecorationImage(
//                                               image: AssetImage(FrameConstants
//                                                   .fr_background_stable),
//                                               fit: BoxFit.fill),
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                         ),
//                                         child: Stack(
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 const SizedBox( height: 12),
//                                                 Text(
//                                                   'solar'.tr.toUpperCase(),
//                                                   style: TextAppStyle()
//                                                       .semiBoldTextStyle(),
//                                                 ),
//                                                 Text(
//                                                   widget.dataResult['data']
//                                                           ['arrDate'][index]
//                                                       ['dateSolar'],
//                                                   style: TextAppStyle()
//                                                       .thinTextStyleSmall(),
//                                                 ),
//                                                 const SizedBox( height: 12),
//                                                 Text(
//                                                   'lunar'
//                                                       .tr
//                                                       .replaceAll('\n', ' ')
//                                                       .toUpperCase(),
//                                                   style: TextAppStyle()
//                                                       .semiBoldTextStyle(),
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       widget.dataResult['data'][
//                                                                       'arrDate']
//                                                                   [index]
//                                                               ['dateLunar'] +
//                                                           ' - ',
//                                                       style: TextAppStyle()
//                                                           .thinTextStyleSmall(),
//                                                     ),
//                                                     const SizedBox(width: 4),
//                                                     Text(
//                                                       'ngu_hanh_ngay'.tr + ': ',
//                                                       style: TextAppStyle()
//                                                           .thinTextStyleSmall(),
//                                                     ),
//                                                     Text(
//                                                       '${widget.dataResult['data']['arrDate'][index]['nguHanhNgay']}'
//                                                           .tr
//                                                           .toUpperCase(),
//                                                       style: TextAppStyle()
//                                                           .titleStyleSmall()
//                                                           .copyWith(
//                                                               color: getColorByElement(
//                                                                   widget.dataResult['data']
//                                                                               ['arrDate']
//                                                                           [
//                                                                           index]
//                                                                       [
//                                                                       'nguHanhNgay'])),
//                                                     )
//                                                   ],
//                                                 ),
//                                                 const SizedBox( height: 12),
//                                                 Text(
//                                                   '${widget.dataResult['data']['arrDate'][index]['canChiNgay']}'.tr +
//                                                       ' / ' +
//                                                       '${widget.dataResult['data']['arrDate'][index]['canChiThang']}'
//                                                           .tr +
//                                                       ' / ' +
//                                                       '${widget.dataResult['data']['arrDate'][index]['canChiNam']}'
//                                                           .tr,
//                                                   style: TextAppStyle()
//                                                       .normalTextStyle(),
//                                                 ),
//                                                 const SizedBox( height: 12),
//                                                 Text(
//                                                   'hour'.tr.toUpperCase(),
//                                                   style: TextAppStyle()
//                                                       .semiBoldTextStyle(),
//                                                 ),
//                                                 const SizedBox( height: 12),
//                                                 Wrap(
//                                                     alignment:
//                                                         WrapAlignment.center,
//                                                     spacing:
//                                                         0, // Khoảng cách giữa các icon
//                                                     runSpacing:
//                                                         16, // Khoảng cách giữa các dòng
//                                                     children: List.generate(
//                                                         widget
//                                                                 .dataResult[
//                                                                     'data']
//                                                                     ['arrDate']
//                                                                     [index]
//                                                                     ['gio']
//                                                                 .length ??
//                                                             0, (idx) {
//                                                       return SizedBox(
//                                                         width:
//                                                             (getResponsiveWidth(
//                                                                         context) -
//                                                                     48 -
//                                                                     24 -
//                                                                     12 -
//                                                                     12 -
//                                                                     4) /
//                                                                 2,
//                                                         // height: (Get.width - 8 - 8 - 8) / 3,
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             ClipOval(
//                                                               child: SizedBox(
//                                                                 width:
//                                                                     maxWidth >
//                                                                             500
//                                                                         ? 66
//                                                                         : 54,
//                                                                 height:
//                                                                     maxWidth >
//                                                                             500
//                                                                         ? 66
//                                                                         : 54,
//                                                                 child:
//                                                                     Image.asset(
//                                                                   getZodiacImage(
//                                                                       (widget.dataResult['data']['arrDate'][index]['gio'][idx]
//                                                                               [
//                                                                               'order'] ??
//                                                                           0)),
//                                                                   fit: BoxFit
//                                                                       .contain,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             // ),
//                                                             const SizedBox(
//                                                               width: 4,
//                                                             ),
//                                                             Expanded(
//                                                               child: Column(
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   Text(
//                                                                     '${widget.dataResult['data']['arrDate'][index]['gio'][idx]['name']}'
//                                                                         .tr,
//                                                                     maxLines: 1,
//                                                                     overflow:
//                                                                         TextOverflow
//                                                                             .ellipsis,
//                                                                     style: TextAppStyle()
//                                                                         .titleStyle()
//                                                                         .copyWith(
//                                                                             fontSize: maxWidth > 500
//                                                                                 ? 18
//                                                                                 : 14),
//                                                                   ),
//                                                                   Text(
//                                                                     '${formatHour(widget.dataResult['data']['arrDate'][index]['gio'][idx]['start'])}-${formatHour(widget.dataResult['data']['arrDate'][index]['gio'][idx]['end'])}'
//                                                                         .tr,
//                                                                     maxLines: 1,
//                                                                     overflow:
//                                                                         TextOverflow
//                                                                             .ellipsis,
//                                                                     style: TextAppStyle()
//                                                                         .thinTextStyle()
//                                                                         .copyWith(
//                                                                             fontSize: maxWidth > 500
//                                                                                 ? 16
//                                                                                 : 12),
//                                                                   ),
//                                                                   Text(
//                                                                     '${widget.dataResult['data']?['arrDate']?[index]?['gio']?[idx]?['nguHanh'] ?? ''}'
//                                                                         .tr,
//                                                                     style: TextAppStyle()
//                                                                         .semiBoldTextStyle()
//                                                                         .copyWith(
//                                                                           fontSize: maxWidth > 500
//                                                                               ? 16
//                                                                               : 12,
//                                                                           color:
//                                                                               getColorByElement(widget.dataResult['data']?['arrDate']?[index]?['gio']?[idx]?['nguHanh'] ?? ''),
//                                                                         ),
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       );
//                                                     })),
//                                                 const SizedBox( height: 12),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       'TRỰC: ',
//                                                       style: TextAppStyle()
//                                                           .semiBoldTextStyle(),
//                                                     ),
//                                                     Text(
//                                                       '${widget.dataResult['data']['arrDate'][index]['truc']}'
//                                                           .tr
//                                                           .toUpperCase(),
//                                                       style: TextAppStyle()
//                                                           .titleStyle()
//                                                           .copyWith(
//                                                               color: AppColor
//                                                                   .colorGreenDark),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 const SizedBox( height: 4),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       'TÚ: ',
//                                                       style: TextAppStyle()
//                                                           .semiBoldTextStyle(),
//                                                     ),
//                                                     Text(
//                                                       '${widget.dataResult['data']['arrDate'][index]['tu']}'
//                                                           .tr
//                                                           .toUpperCase(),
//                                                       style: TextAppStyle()
//                                                           .titleStyle()
//                                                           .copyWith(
//                                                               color: AppColor
//                                                                   .colorGreenDark),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 const SizedBox( height: 8),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Positioned(
//                                         left: 1,
//                                         top: 1,
//                                         child: Container(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 12, 2, 12, 3),
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     const BorderRadius.only(
//                                                         topLeft:
//                                                             Radius.circular(8),
//                                                         bottomRight:
//                                                             Radius.circular(8)),
//                                                 color: getColorByStatus(
//                                                     widget.dataResult['data']
//                                                                     ['arrDate']
//                                                                 [index][
//                                                             'textStatusDate'] ??
//                                                         'tho')),
//                                             child: Center(
//                                               child: Text(
//                                                   '${widget.dataResult['data']['arrDate'][index]['textStatusDate']}'
//                                                       .tr,
//                                                   style: TextAppStyle()
//                                                       .superStyleExtraSmall()
//                                                       .copyWith(
//                                                           fontFamily:
//                                                               CommonConstants
//                                                                   .bold,
//                                                           color: AppColor
//                                                               .secondaryColor)),
//                                             )),
//                                       ),
//                                       Positioned(
//                                         right: 8,
//                                         bottom: 8,
//                                         child: onTapWidget(
//                                           onTap: () async {
//                                             await EasyLoading.show(
//                                                 maskType:
//                                                     EasyLoadingMaskType.black);
//                                             final query =
//                                                 Map<String, dynamic>.from(
//                                                     widget.dataResult['data']
//                                                         ['arrDate'][index]);
//                                             query['tuoiGiaChu'] =
//                                                 widget.dataResult['data']
//                                                     ['tuoiGiaChu'];
//                                             query['type'] = widget.type;
//                                             if (widget.dataResult['data']
//                                                         ?['dia']?['toaNha']
//                                                     ?['key'] !=
//                                                 null) {
//                                               query['toa'] =
//                                                   widget.dataResult['data']![
//                                                       'dia']!['toaNha']!['key'];
//                                             }
//                                             _getHonoScopes(
//                                                 data: jsonEncode(query));
//                                           },
//                                           child: Row(
//                                             children: [
//                                               Image.asset(
//                                                 IconConstants.ic_btn_dainam,
//                                                 width: 40,
//                                                 height: 40,
//                                               ),
//                                               const SizedBox(width: 4),
//                                               Image.asset(
//                                                 ImageConstants
//                                                     .img_next_tab_feng_shui,
//                                                 width: 20,
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Divider(
//                               thickness: 0.25,
//                               color: AppColor.borderYellow,
//                               height: 0.25,
//                             )
//                           ],
//                         );
//                       }),
//                     ),
//                   if (itemCount > 5)
//                     onTapWidget(
//                         onTap: () {
//                           setState(() {
//                             showAll = !showAll;
//                           });
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.only(top: 8),
//                           height: 40,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: AssetImage(showAll
//                                       ? ButtonConstants
//                                           .btn_small_primary_inactive
//                                       : ButtonConstants
//                                           .btn_small_primary_active))),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 0),
//                           child: Center(
//                             child: Text(
//                               showAll ? 'view_less'.tr : 'view_more'.tr,
//                               style: showAll
//                                   ? TextAppStyle()
//                                       .normalTextStyleSmall()
//                                       .copyWith(
//                                           color: AppColor.secondaryColor
//                                               .withAlpha((0.5 * 255).toInt()))
//                                   : custom3DTextStyle(context),
//                             ),
//                           ),
//                         )),
//                 ],
//               )
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'result'.tr + ':',
//                     style: TextAppStyle().titleStyle(),
//                   ),
//                   const SizedBox( height: 8),
//                   RichText(
//                     text: TextSpan(
//                       text: 'from_date'.tr +
//                           ' ${widget.dataResult['data']['dateStart']} ' +
//                           'to_date'.tr.toLowerCase() +
//                           ' ${widget.dataResult['data']['dateEnd']} ',
//                       style: TextAppStyle().normalTextStyle(),
//                       children: [
//                         TextSpan(
//                             text: 'have_no_day'.tr.toLowerCase(),
//                             style: TextAppStyle().semiBoldTextStyle().copyWith(
//                                 color: checkDayMonthHours(widget
//                                                 .dataResult['data']
//                                             ['errShowDayMonthShowOneDate']) ==
//                                         'phu_hop'
//                                     ? AppColor.colorGreen
//                                     : AppColor.colorRed,
//                                 decoration: TextDecoration.underline)),
//                         TextSpan(
//                             text: ' ${'to_do_thing'.tr}',
//                             style: TextAppStyle().normalTextStyle()),
//                         TextSpan(
//                             text: '''"${widget.title}".''',
//                             style: TextAppStyle()
//                                 .normalTextStyle()
//                                 .copyWith(color: AppColor.primaryColor)),
//                       ],
//                     ),
//                   ),
//                   if (widget.dataResult['data']['warningContentData'] != null &&
//                       widget
//                           .dataResult['data']['warningContentData'].isNotEmpty)
//                     WarningContentList(
//                         warningContentData: widget.dataResult['data']
//                             ['warningContentData']),
//                   Text('select_another_day_note'.tr,
//                       style: TextAppStyle()
//                           .semiBoldTextStyleSmall()
//                           .copyWith(color: AppColor.colorRed)),
//                   const SizedBox( height: 24),
//                   onTapWidget(
//                     onTap: () {
//                     },
//                     child: Container(
//                       width: getResponsiveWidth(context) - 48 - 24,
//                       margin: EdgeInsets.symmetric(
//                           horizontal: maxWidth > 500 ? 24 : 12),
//                       height: MediaQuery.of(context).size.width > 500 ? 74 : 54,
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                               image: AssetImage(
//                                   ButtonConstants.btn_large_primary_active),
//                               fit: BoxFit.fill)),
//                       child: Center(
//                         child: Text(
//                           'book_expert'.tr.replaceAll('\n', ' '),
//                           style: custom3DTextStyle(context),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ],
//     );
//   }

//   String checkDayMonthHours(Map<String, dynamic> errData) {
//     List<String> validKeys = [
//       'day',
//       'month',
//       'hours',
//       'errShowDayMonthShowOneDate'
//     ];
//     List<String> validValues = ['phu_hop', 'Phù hợp'];

//     for (var key in validKeys) {
//       if (errData.containsKey(key)) {
//         var value = errData[key];

//         // Trường hợp là object (errShowDayMonthShowOneDate chứa nhiều giá trị bên trong)
//         if (value is Map<String, dynamic>) {
//           for (var subKey in value.keys) {
//             if (!validValues.contains(value[subKey])) {
//               return 'khong_phu_hop';
//             }
//           }
//         }
//         // Trường hợp là giá trị trực tiếp
//         else if (!validValues.contains(value)) {
//           return 'khong_phu_hop';
//         }
//       }
//     }

//     return 'phu_hop';
//   }

// }

// class WarningContentList extends StatelessWidget {
//   final List<dynamic>? warningContentData;

//   const WarningContentList({super.key, this.warningContentData});

//   @override
//   Widget build(BuildContext context) {
//     if (warningContentData == null || warningContentData!.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 12),
//         child: Center(
//           child: Text(
//             "Không có dữ liệu cảnh báo!",
//             style: TextAppStyle()
//                 .normalTextStyle()
//                 .copyWith(color: Colors.grey, fontSize: 16),
//           ),
//         ),
//       );
//     }

//     final List<Map<String, dynamic>> dataList = warningContentData!
//         .where((item) => item is Map<String, dynamic>)
//         .cast<Map<String, dynamic>>()
//         .toList();

//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: dataList.length,
//       padding: const EdgeInsets.only(top: 12),
//       itemBuilder: (context, index) {
//         final item = dataList[index];
//         final isPham = item['isPham'] ?? false;
//         final details = item['details'] ?? {};
//         final kimLauDetail = details['kimLau'] ?? "";
//         final hoangOcDetail = details['hoangOc'] ?? "";

//         return Container(
//           decoration: BoxDecoration(
//             color: AppColor.whiteColor,
//             border: Border.all(
//                 width: 0.25,
//                 color:
//                     isPham ? AppColor.colorRedBold : AppColor.colorGreenDark),
//             borderRadius: BorderRadius.circular(12),
//             image: DecorationImage(
//                 image: AssetImage(ImageConstants.img_bg_manage_book_expert),
//                 fit: BoxFit.cover),
//           ),
//           child: Theme(
//             data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//             child: ExpansionTile(
//               title: Text(
//                 "Năm ${item['year']}",
//                 style: TextAppStyle().semiBoldTextStyleSmall().copyWith(
//                       color: isPham
//                           ? AppColor.colorRedBold
//                           : AppColor.colorGreenDark,
//                     ),
//               ),
//               childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               tilePadding: const EdgeInsets.symmetric(horizontal: 16),
//               minTileHeight: 40,
//               iconColor: AppColor.grayTextwhiteColor,
//               collapsedIconColor:
//                   isPham ? AppColor.colorRedBold : AppColor.colorGreenDark,
//               children: [
//                 Divider(
//                   height: 0.25,
//                   color:
//                       isPham ? AppColor.colorRedBold : AppColor.colorGreenDark,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox( height: 16),
//                     Row(
//                       children: [
//                         Text(
//                           isPham ? "Phạm" : "Không phạm",
//                           textAlign: TextAlign.left,
//                           style: TextAppStyle().normalTextStyle().copyWith(
//                               color: AppColor.primaryColor, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                     const SizedBox( height: 4),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (item['kimlau'] == true)
//                           _buildDetailRow(
//                             "Kim lâu",
//                             kimLauDetail.isNotEmpty
//                                 ? ': ' + "$kimLauDetail".tr
//                                 : "",
//                           ),
//                         if (item['hoangOc'] == true)
//                           _buildDetailRow(
//                             "Hoang ốc",
//                             hoangOcDetail.isNotEmpty
//                                 ? ': ' + "$hoangOcDetail".tr
//                                 : "",
//                           ),
//                         if (item['tamTai'] == true)
//                           _buildDetailRow("Tam tai", ""),
//                         if (item['thaiTue'] == true)
//                           _buildDetailRow("Thái tuế", ""),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       separatorBuilder: (BuildContext context, int index) {
//         return Divider(
//           height: 8,
//           thickness: 8,
//           color: AppColor.transparentColor,
//         );
//       },
//     );
//   }

//   Widget _buildDetailRow(String title, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '• ' + title,
//           style: TextAppStyle()
//               .normalTextStyleSmall()
//               .copyWith(fontWeight: FontWeight.w600),
//         ),
//         Text(
//           value,
//           style: TextAppStyle().normalTextStyleSmall(),
//           textAlign: TextAlign.left,
//         ),
//       ],
//     );
//   }
// }
