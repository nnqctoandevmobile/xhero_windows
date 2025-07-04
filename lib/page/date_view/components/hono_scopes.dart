// // ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_null_comparison

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:gradient_borders/gradient_borders.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import '../../../constants/colors.dart';
// import '../../../constants/common.dart';
// import '../../../resource/assets_constant/frames_constant.dart';
// import '../../../resource/assets_constant/icon_constants.dart';
// import '../../../resource/assets_constant/images_constants.dart';
// import '../../../shared/multi_appear_widgets/gradient_text_stroke.dart';
// import '../../../shared/text_style.dart';
// import '../../../utils/logic/common_widget.dart';
// import '../../../utils/logic/xhero_common_logics.dart';

// class HonoScopeScreen extends StatefulWidget {
//   final Map<String, dynamic> data;
//   final String name;
//   final String title;
//   final String dob;
//   final String homeCoor;
//   final List<dynamic> selectDate;
//   final String nguHanh;
//   final String borrow;
//   const HonoScopeScreen({
//     required this.data,
//     required this.name,
//     required this.title,
//     required this.dob,
//     required this.homeCoor,
//     required this.selectDate,
//     required this.nguHanh,
//     required this.borrow,
//     super.key,
//   });

//   @override
//   State<HonoScopeScreen> createState() => _HonoScopeScreenState();
// }

// class _HonoScopeScreenState extends State<HonoScopeScreen> {
//   bool showAll = false;
//   int itemCount = 0;
//   bool isCapturing = false;
//   ScreenshotController screenshotController = ScreenshotController();
//   int getStarCount(String status) {
//     return CommonConstants.starsOfStatus[status] ?? 0;
//   }

//   List<String> lstAvoidTitle = [
//     'Ngày Đại Hao',
//     'Ngày Tuế Phá',
//     'Ngày Nguyệt Phá',
//     'Ngày Nguyệt Kỵ',
//     'Ngày Thọ Tử',
//     'Ngày Tam Nương',
//     'Vãng Vong',
//   ];
//   List<dynamic> itemsToShow = [];
//   @override
//   Widget build(BuildContext context) {
//     return frameCommonWidget(
//         background: ImageConstants.img_bg_hono_scopes,
//         isShowAction: true,
//         action: Row(
//           children: [
//             onTapWidget(
//               onTap: () async {
//                 _shareHonoScopes();
//               },
//               child: Image.asset(
//                 IconConstants.ic_btn_share,
//                 width: 40,
//                 height: 40,
//               ),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox( height: 88),
//               SizedBox(
//                 width: getResponsiveWidth(context),
//                 child: Screenshot(
//                   controller: screenshotController,
//                   child: Container(
//                     padding: const EdgeInsets.all(24),
//                     width: getResponsiveWidth(context),
//                     decoration: BoxDecoration(
//                       color: isCapturing
//                           ? AppColor.whiteColor
//                           : AppColor.transparentColor,
//                       borderRadius: BorderRadius.circular(0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Center(
//                           child: Column(
//                             children: [
//                               const SizedBox( height: 16),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset(
//                                     IconConstants.ic_dai_nam_gradient,
//                                     width: 24,
//                                   ),
//                                   const SizedBox( width: 8),
//                                   GradientTextWithStroke(
//                                     text:
//                                         'view_lucky_date_time'.tr.toUpperCase(),
//                                     colors: CommonConstants.button,
//                                     style: TextAppStyle().superStyle().copyWith(
//                                       color: AppColor.textYellow,
//                                       shadows: [
//                                         Shadow(
//                                           blurRadius: 0.25,
//                                           color: AppColor.brownLight,
//                                           offset: const Offset(0, 0),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox( width: 8),
//                                   Image.asset(
//                                     IconConstants.ic_dai_nam_gradient,
//                                     width: 24,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Stack(
//                           children: [
//                             Positioned.fill(
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       margin: const EdgeInsets.only(top: 0),
//                                       width: Get.width / 1.25,
//                                       height: Get.width / 1.25,
//                                       decoration: const BoxDecoration(
//                                         image: DecorationImage(
//                                           image: AssetImage(ImageConstants
//                                               .img_bg_ial_content),
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned.fill(
//                                         child: Container(
//                                       decoration: BoxDecoration(
//                                           color: AppColor.whiteColor
//                                               .withAlpha((0.25 * 255).toInt()),
//                                           shape: BoxShape.circle),
//                                     ))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Column(
//                               children: [
//                                 const SizedBox( height: 24),
//                                 _infoTHIENArea(context),
//                                 _infoNHANArea(context),
//                                 _infoDIAArea(context),
//                               ],
//                             ),
//                           ],
//                         ),
//                         _avoidDatesArea(context),
//                         const SizedBox( height: 24),
//                         _conslutionArea(context)
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         titleAppbar: 'hono_scopes'.tr);
//   }

//   Widget _infoNHANArea(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Center(
//           child: Image.asset(
//             "" == 'vi'
//                 ? FrameConstants.fr_nhan_label
//                 : "" == 'en'
//                     ? FrameConstants.fr_nhan_label_en
//                     : FrameConstants.fr_nhan_label_zh,
//             width: optimizedSize(
//                 phone: 100, zfold: 148, tablet: 180, context: context),
//             fit: BoxFit.fitHeight,
//           ),
//         ),
//         const SizedBox( height: 8),
//         Column(
//           children: [
//             Row(
//               children: [
//                 Text('${'full_name'.tr}: ', style: TextAppStyle().titleStyle()),
//                 Expanded(
//                   child: Text(
//                       widget.name == '' ? 'user_unknown'.tr : widget.name,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextAppStyle().normalTextStyle()),
//                 ),
//               ],
//             ),
//             const SizedBox( height: 8),
//             Row(
//               children: [
//                 Text('${'dob_year'.tr}: ', style: TextAppStyle().titleStyle()),
//                 Expanded(
//                   child: Text(widget.dob == '' ? 'no'.tr : widget.dob,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextAppStyle().normalTextStyle()),
//                 ),
//               ],
//             ),
//             const SizedBox( height: 8),
//             Row(
//               children: [
//                 Text('${'thing_to_check'.tr}: ',
//                     style: TextAppStyle().titleStyle()),
//                 Expanded(
//                   child: Text('"' + widget.title + '"',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextAppStyle().semiBoldTextStyle().copyWith(
//                           color: AppColor.textBrownColor,
//                           decoration: TextDecoration.underline,
//                           decorationColor: AppColor.textBrownColor)),
//                 ),
//               ],
//             ),
//             widget.borrow == ''
//                 ? const SizedBox()
//                 : Column(
//                     children: [
//                       const SizedBox( height: 8),
//                       Row(
//                         children: [
//                           Text('${'borrow_age'.tr}: ',
//                               style: TextAppStyle().titleStyle()),
//                           Expanded(
//                             child: Text(widget.borrow,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextAppStyle().normalTextStyle()),
//                           ),
//                         ],
//                       ),
//                     ],
//                   )
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _infoDIAArea(BuildContext context) {
//     return Visibility(
//         visible: widget.homeCoor != '',
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 0.5,
//               margin: const EdgeInsets.only(top: 12, bottom: 12),
//               width: getResponsiveWidth(context) - 48,
//               decoration: BoxDecoration(
//                   color:
//                       AppColor.textBrownColor.withAlpha((0.5 * 255).toInt())),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Center(
//                   child: Image.asset(
//                     "" == 'vi'
//                         ? FrameConstants.fr_dia_label
//                         : "" == 'en'
//                             ? FrameConstants.fr_dia_label_en
//                             : FrameConstants.fr_dia_label_zh,
//                     width: optimizedSize(
//                         phone: 100, zfold: 148, tablet: 180, context: context),
//                     fit: BoxFit.fitHeight,
//                   ),
//                 ),
//                 const SizedBox( height: 8),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text('${'home_coor'.tr}: ',
//                             style: TextAppStyle().titleStyle()),
//                         Text(widget.homeCoor.tr,
//                             style: TextAppStyle().normalTextStyle()),
//                         Text(' - ', style: TextAppStyle().normalTextStyle()),
//                         Text('(' + widget.nguHanh.tr + ')',
//                             style: TextAppStyle().normalTextStyle().copyWith(
//                                 color: getColorByElement(widget.nguHanh))),
//                       ],
//                     ),
//                     if (getDirectionInfo(widget.data) != null &&
//                         getDirectionInfo(widget.data).isNotEmpty)
//                       Text(
//                         getDirectionInfo(widget.data),
//                         style: TextAppStyle().normalTextStyleSmall(),
//                       ),
//                     const SizedBox( height: 8),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Text('${'select_date'.tr}: ',
//                         style: TextAppStyle().titleStyle()),
//                     Expanded(
//                       child: Row(
//                         children:
//                             List.generate(widget.selectDate.length, (index) {
//                           return Text(
//                               (index + 1 == widget.selectDate.length)
//                                   ? '${widget.selectDate[index]}'
//                                           .tr
//                                           .toUpperCase() +
//                                       ''
//                                   : '${widget.selectDate[index]}'
//                                           .tr
//                                           .toUpperCase() +
//                                       ' ➤ ',
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                               style: TextAppStyle().superStyle().copyWith(
//                                   fontSize: 16,
//                                   color: getColorByElement(
//                                       widget.selectDate[index] ?? 'tho')));
//                         }),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ));
//   }

//   Future<void> _shareHonoScopes() async {
//     setState(() {
//       isCapturing = true;
//     });
//     await EasyLoading.show(maskType: EasyLoadingMaskType.black);
//     final directory = await getApplicationDocumentsDirectory();
//     final imagePath = await screenshotController.captureAndSave(
//       directory.path,
//       fileName: 'Lá_Số_Xem_Ngày.png',
//     );
//     if (imagePath != null) {
//       await EasyLoading.dismiss();
//       final compressedImagePath = await compressImageString(imagePath);
//       Share.shareXFiles([XFile(compressedImagePath)]);
//     } else {
//       await EasyLoading.dismiss();
//     }
//     setState(() {
//       isCapturing = false;
//     });
//   }

//   Widget _infoTHIENArea(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Center(
//               child: Image.asset(
//                 "" == 'vi'
//                     ? FrameConstants.fr_thien_label
//                     : "" == 'en'
//                         ? FrameConstants.fr_thien_label_en
//                         : FrameConstants.fr_thien_label_zh,
//                 width: optimizedSize(
//                     phone: 100, zfold: 148, tablet: 180, context: context),
//                 fit: BoxFit.fitHeight,
//               ),
//             ),
//             const SizedBox( height: 8),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('${'time'.tr}: ', style: TextAppStyle().titleStyle()),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                         widget.data['data']['dateSolar'] +
//                             ' (${'solar'.tr.replaceAll('\n', ' ')})',
//                         style: TextAppStyle().normalTextStyle()),
//                     Text(
//                         widget.data['data']['dateLunar'] +
//                             ' (${'lunar'.tr.replaceAll('\n', ' ')})',
//                         style: TextAppStyle().normalTextStyle())
//                   ],
//                 ),
//               ],
//             ),
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

//   Widget _avoidDatesArea(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 0.5,
//           margin: const EdgeInsets.only(top: 12, bottom: 12),
//           width: getResponsiveWidth(context) - 48,
//           decoration: BoxDecoration(
//               color: AppColor.textBrownColor.withAlpha((0.5 * 255).toInt())),
//         ),
//         Center(
//           child: RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               style:
//                   TextAppStyle().semiBoldTextStyle().copyWith(fontSize: 16.0),
//               children: [
//                 // TextSpan(
//                 //     text: '${widget.data['data']['nguHanhNgay']}'.tr + ' ',
//                 //     style: TextAppStyle().semiBoldTextStyle().copyWith(
//                 //         color: getColorByElement(
//                 //             widget.data['data']['nguHanhNgay'] ?? 'tho'))),
//                 // TextSpan(
//                 //     text: '${widget.data['data']['nguHanhThang']}'.tr + ' ',
//                 //     style: TextAppStyle().semiBoldTextStyle().copyWith(
//                 //         color: getColorByElement(
//                 //             widget.data['data']['nguHanhThang'] ?? 'tho'))),

//                 TextSpan(
//                     text: 'Ngày Bách Kỵ'.tr,
//                     style: TextAppStyle()
//                         .titleStyle()
//                         .copyWith(color: AppColor.colorRed)),
//                 TextSpan(
//                     text:
//                         ' ${'in_the_month'.tr.toLowerCase()} ${widget.data['data']['monthLunar'] ?? ''} (${'lunar'.tr.replaceAll('\n', ' ')})'
//                             .tr,
//                     style: TextAppStyle().semiBoldTextStyle()),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox( height: 16),
//         Container(
//           padding:
//               const EdgeInsets.only(left: 4, right: 8, top: 12, bottom: 12),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color:
//                   AppColor.lightBackgroundColor.withAlpha((0.5 * 255).toInt()),
//               border: const GradientBoxBorder(
//                   gradient:
//                       LinearGradient(colors: CommonConstants.gradientsLight)),
//               image: DecorationImage(
//                   image: AssetImage(FrameConstants.fr_background_stable),
//                   fit: BoxFit.fill)),
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: getResponsiveWidth(context) / 1.5,
//                       height: getResponsiveWidth(context) / 1.5,
//                       // height: getResponsiveWidth(context) / 2,
//                       padding: const EdgeInsets.all(12),
//                       decoration: const BoxDecoration(
//                           image: DecorationImage(
//                               image: AssetImage(
//                                   'assets/images/img_bg_dainam_trans.png'),
//                               fit: BoxFit.fill)),
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 children: List.generate(
//                     lstAvoidTitle.length,
//                     (index) => Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     // _buildDynamicWidgetStart(
//                                     //     index, widget.data['data']),
//                                     const SizedBox( width: 2),
//                                     Image.asset(
//                                       IconConstants.ic_bmb_center_active,
//                                       width: 8,
//                                       height: 8,
//                                     ),
//                                     const SizedBox( width: 4),
//                                     Text(
//                                       lstAvoidTitle[index],
//                                       style: TextAppStyle().semiBoldTextStyle(),
//                                     ),
//                                   ],
//                                 ),
//                                 _buildDynamicWidget(index, widget.data['data']),
//                               ],
//                             ),
//                             index + 1 >= lstAvoidTitle.length
//                                 ? const SizedBox()
//                                 : Divider(
//                                     height: 16,
//                                     thickness: 0.5,
//                                     color: AppColor.borderYellow
//                                         .withAlpha((0.75 * 255).toInt()),
//                                   )
//                           ],
//                         )),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   String getDirectionInfo(Map<String, dynamic>? data) {
//     if (data == null || data['data'] == null) {
//       return "";
//     }

//     final nguHoangThaiTueDaoHuong = data['data']['nguHoangThaiTueDaoHuong'];
//     if (nguHoangThaiTueDaoHuong == null ||
//         nguHoangThaiTueDaoHuong['isShow'] != true) {
//       return "";
//     }

//     // Tạo danh sách để chứa các thông báo
//     List<String> messages = [];

//     // Kiểm tra isShowNguHoangDaoHuong
//     if (nguHoangThaiTueDaoHuong['isShowNguHoangDaoHuong'] == true) {
//       final nguHoangDetail =
//           nguHoangThaiTueDaoHuong['detail']?['nguHoangDaoHuong'];
//       final sonToa = nguHoangDetail?['data']?['sonToa'] ?? "Không xác định";
//       final year = nguHoangDetail?['yearLunar'] ?? "Không xác định";
//       final daoHuong = nguHoangDetail?['data']?['daoHuong'] ?? [];
//       if (daoHuong.isNotEmpty) {
//         final firstHuong = daoHuong[0];
//         final secondHuong = daoHuong.length > 1 ? daoHuong[1] : null;
//         messages.add(
//           "- Năm $year (${'${data['data']['canChiNam'] ?? ''}'.tr}) Ngũ hoàng đáo hướng ${translateDirection(firstHuong)} ${secondHuong != null ? 'hoặc ${translateDirection(secondHuong)}' : ''} => Nhà toạ ${widget.homeCoor.tr} hướng ${translateDirection(sonToa)} phạm Ngũ hoàng đáo hướng",
//         );
//       } else {
//         messages.add(
//           "- Năm $year (${'${data['data']['canChiNam'] ?? ''}'.tr}) không có hướng phạm Ngũ hoàng đáo hướng.",
//         );
//       }
//     }

//     // Kiểm tra isShowThaiTueDaoHuong
//     if (nguHoangThaiTueDaoHuong['isShowThaiTueDaoHuong'] == true) {
//       final thaiTueDetail =
//           nguHoangThaiTueDaoHuong['detail']?['thaiTueDaoHuong'];
//       final year = thaiTueDetail?['yearLunar'] ?? "Không xác định";
//       final sonChiNam =
//           thaiTueDetail?['data']?['sonChiNam'] ?? "Không xác định";
//       messages.add(
//         "- Năm $year (${'${data['data']['canChiNam'] ?? ''}'.tr}) Thái tuế đáo hướng ${translateDirection(sonChiNam)} => Nhà toạ ${widget.homeCoor.tr} hướng ${translateDirection(sonChiNam)} phạm Thái tuế đáo hướng",
//       );
//     }

//     // Kết hợp các thông báo thành một chuỗi
//     return messages.join("\n");
//   }

//   String translateDirection(String key) {
//     const translations = {
//       "bac": "Bắc",
//       "nam": "Nam",
//       "dong": "Đông",
//       "tay": "Tây",
//       "dong_bac": "Đông Bắc",
//       "dong_nam": "Đông Nam",
//       "tay_bac": "Tây Bắc",
//       "tay_nam": "Tây Nam",
//     };
//     return translations[key] ?? key; // Nếu không tìm thấy, trả về chính `key`.
//   }

//   Widget _buildDynamicWidget(int index, Map<String, dynamic> data) {
//     if ([0, 1, 2, 4, 6].contains(index)) {
//       String name = '';
//       String nguHanh = '';
//       int order = 1;
//       // Cập nhật name và order dựa vào index và dữ liệu từ API
//       if (index == 0 && data['daiHao'] != null) {
//         name = data['daiHao']['name'] ?? '';
//         order = data['daiHao']['order'] ?? '';
//         nguHanh = data['daiHao']['nguHanh'] ?? '';
//       } else if (index == 1 && data['tuePha'] != null) {
//         name = data['tuePha']['name'] ?? '';
//         order = data['tuePha']['order'] ?? '';
//         nguHanh = data['tuePha']['nguHanh'] ?? '';
//       } else if (index == 2 && data['nguyetPha'] != null) {
//         name = data['nguyetPha']['name'] ?? '';
//         order = data['nguyetPha']['order'] ?? '';
//         nguHanh = data['nguyetPha']['nguHanh'] ?? '';
//       } else if (index == 4 && data['thoTu'] != null) {
//         name = data['thoTu']['name'] ?? '';
//         order = data['thoTu']['order'] ?? '';
//         nguHanh = data['thoTu']['nguHanh'] ?? '';
//       } else if (index == 6 && data['vangVong'] != null) {
//         name = data['vangVong']['name'] ?? '';
//         order = data['vangVong']['order'] ?? '';
//         nguHanh = data['vangVong']['nguHanh'] ?? '';
//       }
//       return Row(
//         children: [
//           Text(
//             name.tr,
//             style: TextAppStyle()
//                 .semiBoldTextStyle()
//                 .copyWith(color: getColorByElement(nguHanh)),
//           ),
//           const SizedBox( width: 8),
//           ClipOval(
//             child: SizedBox(
//               width: 44,
//               height: 44,
//               child: Image.asset(
//                 getZodiacImage(order),
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ],
//       );
//     } else if ([3, 5].contains(index)) {
//       List<dynamic> numbers = [];
//       if (index == 3 && data['nguyetKy'] != null) {
//         numbers = data['nguyetKy'];
//       } else if (index == 5 && data['tamNuong'] != null) {
//         numbers = data['tamNuong'];
//       }
//       return SizedBox(
//         height: 44,
//         child: Row(
//           children: List.generate(
//               numbers.length,
//               (idx) => Row(
//                     children: [
//                       Text(
//                         '${numbers[idx]}',
//                         style: TextAppStyle().semiBoldTextStyle(),
//                       ),
//                       idx + 1 >= numbers.length
//                           ? const SizedBox()
//                           : Text(
//                               ', ',
//                               style: TextAppStyle().semiBoldTextStyle(),
//                             ),
//                     ],
//                   )),
//         ),
//       );
//     } else {
//       return const SizedBox();
//     }
//   }

//   Widget _conslutionArea(BuildContext context) {
//     double maxWidth = MediaQuery.of(context).size.width;
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text(
//         'Sau khi loại bỏ những ngày bách kỵ, ta chọn được ngày, giờ cát lợi như sau:',
//         textAlign: TextAlign.center,
//         style: TextAppStyle().normalTextStyle(),
//       ),
//       const SizedBox( height: 16),
//       Center(
//         child: Stack(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   IconConstants.ic_dai_nam_gradient,
//                   width: 24,
//                 ),
//                 const SizedBox( width: 8),
//                 GradientTextWithStroke(
//                   text: 'NGÀY GIỜ ƯU TIÊN',
//                   colors: CommonConstants.button,
//                   style: TextAppStyle().superStyle().copyWith(
//                     color: AppColor.textYellow,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 0.25,
//                         color: AppColor.brownLight,
//                         offset: const Offset(0, 0),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox( width: 8),
//                 Image.asset(
//                   IconConstants.ic_dai_nam_gradient,
//                   width: 24,
//                 ),
//               ],
//             ),
//             // Stroke (black outline)
//           ],
//         ),
//       ),
//       const SizedBox( height: 16),
//       Container(
//         width: getResponsiveWidth(context),
//         // height: getResponsiveWidth(context) / 2,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//             color: AppColor.lightBackgroundColor.withAlpha((0.5 * 255).toInt()),
//             borderRadius: BorderRadius.circular(12),
//             border: const GradientBoxBorder(
//                 gradient:
//                     LinearGradient(colors: CommonConstants.gradientsLight)),
//             image: DecorationImage(
//                 image: AssetImage(FrameConstants.fr_background_stable),
//                 fit: BoxFit.fill)),
//         child: Stack(
//           children: [
//             // Positioned.fill(
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: [
//             //       Container(
//             //         width: getResponsiveWidth(context) / 1.5,
//             //         height: getResponsiveWidth(context) / 1.5,
//             //         // height: getResponsiveWidth(context) / 2,
//             //         padding: const EdgeInsets.all(12),
//             //         decoration: const BoxDecoration(
//             //             image: DecorationImage(
//             //                 image: AssetImage(
//             //                     'assets/images/img_bg_dainam_trans.png'),
//             //                 fit: BoxFit.fill)),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'solar'.tr.toUpperCase(),
//                   style: TextAppStyle().semiBoldTextStyle(),
//                 ),
//                 const SizedBox( height: 4),
//                 Text(
//                   widget.data['data']['dateSolar'],
//                   style: TextAppStyle().thinTextStyleSmall(),
//                 ),
//                 const SizedBox( height: 8),
//                 Text(
//                   'lunar'.tr.replaceAll('\n', ' ').toUpperCase(),
//                   style: TextAppStyle().semiBoldTextStyle(),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.data['data']['dateLunar'] + ' - ',
//                       style: TextAppStyle().thinTextStyleSmall(),
//                     ),
//                     const SizedBox( width: 4),
//                     Text(
//                       'ngu_hanh_ngay'.tr + ': ',
//                       style: TextAppStyle().thinTextStyleSmall(),
//                     ),
//                     Text(
//                       '${widget.data['data']['nguHanhNgay']}'.tr.toUpperCase(),
//                       style: TextAppStyle().titleStyleSmall().copyWith(
//                           color: getColorByElement(
//                               widget.data['data']['nguHanhNgay'])),
//                     )
//                   ],
//                 ),
//                 const SizedBox( height: 8),
//                 Text(
//                   '${widget.data['data']['canChiNgay']}'.tr +
//                       ' / ' +
//                       '${widget.data['data']['canChiThang']}'.tr +
//                       ' / ' +
//                       '${widget.data['data']['canChiNam']}'.tr,
//                   style: TextAppStyle().normalTextStyle(),
//                 ),
//                 const SizedBox( height: 12),
//                 Text(
//                   'hour'.tr.toUpperCase(),
//                   style: TextAppStyle().semiBoldTextStyle(),
//                 ),
//                 const SizedBox( height: 12),
//                 Wrap(
//                     alignment: WrapAlignment.center,
//                     spacing: 0, // Khoảng cách giữa các icon
//                     runSpacing: 16, // Khoảng cách giữa các dòng
//                     children: List.generate(
//                         widget.data['data']['gio'].length ?? 0, (idxH) {
//                       var itemHours = widget.data['data']['gio'][idxH];
//                       return SizedBox(
//                         width: (getResponsiveWidth(context) -
//                                 48 -
//                                 24 -
//                                 12 -
//                                 12 -
//                                 4) /
//                             2,
//                         // height: (Get.width - 8 - 8 - 8) / 3,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ClipOval(
//                               child: SizedBox(
//                                 width: maxWidth > 500 ? 66 : 54,
//                                 height: maxWidth > 500 ? 66 : 54,
//                                 child: Image.asset(
//                                   getZodiacImage((itemHours['order'] ?? 0)),
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                             ),
//                             // ),
//                             const SizedBox(
//                               width: 6,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     '${itemHours['name']}'.tr.tr,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextAppStyle().titleStyle().copyWith(
//                                         fontSize: maxWidth > 500 ? 18 : 14),
//                                   ),
//                                   Text(
//                                     '${formatHour(itemHours['start'])}-${formatHour(itemHours['end'])}'
//                                         .tr,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextAppStyle()
//                                         .thinTextStyle()
//                                         .copyWith(
//                                             fontSize: maxWidth > 500 ? 16 : 12),
//                                   ),
//                                   Text(
//                                     '${itemHours['nguHanh']}'.tr,
//                                     style: TextAppStyle()
//                                         .semiBoldTextStyle()
//                                         .copyWith(
//                                             fontSize: maxWidth > 500 ? 16 : 12,
//                                             color: getColorByElement(
//                                                 itemHours['nguHanh'])),
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       );
//                     })),
//                 const SizedBox( height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'TRỰC: ',
//                       style: TextAppStyle().semiBoldTextStyle(),
//                     ),
//                     Text(
//                       '${widget.data['data']['truc']}'.tr.toUpperCase(),
//                       style: TextAppStyle()
//                           .titleStyle()
//                           .copyWith(color: AppColor.colorGreenDark),
//                     ),
//                   ],
//                 ),
//                 const SizedBox( height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'TÚ: ',
//                       style: TextAppStyle().semiBoldTextStyle(),
//                     ),
//                     Text(
//                       '${widget.data['data']['tu']}'.tr.toUpperCase(),
//                       style: TextAppStyle()
//                           .titleStyle()
//                           .copyWith(color: AppColor.colorGreenDark),
//                     ),
//                   ],
//                 ),
//                 const SizedBox( height: 8),
//               ],
//             ),
//           ],
//         ),
//       ),
//       const SizedBox( height: 12),
//       Text(
//         'Lưu ý:',
//         style: TextAppStyle().titleStyle(),
//       ),
//       const SizedBox( height: 4),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Text(
//           '''• Đối với ngày khai trương, nhập trạch,... gia chủ nên dọn dẹp cửa hàng, nhà mới,...xông nhà, tẩy uế trước khi làm lễ. Đối với những ngày động thổ, cất nóc, nhập trạch, bốc bát hương giữ thân thanh tịch trước khi làm lễ (ít nhất 1 ngày)\n• Trên đây là kết quả việc lựa chọn ngày, giờ cát lợi dựa vào yếu tố Tam tài Thiên, Nhân, Địa của Trung Tâm Phong Thủy Đại Nam. Chúng tôi hi vọng khi sử dụng ngày giờ tốt, Quý khách hàng sẽ lên kế hoạch và khởi sự mọi việc được suôn sẻ, hanh thông.\n• Trung Tâm Phong Thủy Đại Nam xin trân trọng cảm ơn quý khách hàng đã luôn tin tưởng sử dụng sản phẩm và dịch vụ của chúng tôi. Hi vọng thời gian tới chúng tôi sẽ vẫn tiếp tục được đồng hành cùng Quý khách hàng!
//                             ''',
//           textAlign: TextAlign.justify,
//           style: TextAppStyle().thinTextStyleSmall(),
//         ),
//       ),
//       Center(
//         child: GradientTextWithStroke(
//           text:
//               'Chúc Quý Khách Hàng Luôn Bình An\nHạnh Phúc, Vạn Sự Cát Tường!',
//           colors: CommonConstants.button,
//           style: TextAppStyle().superStyle().copyWith(
//             color: AppColor.textYellow,
//             shadows: [
//               Shadow(
//                 blurRadius: 0.25,
//                 color: AppColor.brownLight,
//                 offset: const Offset(0, 0),
//               ),
//             ],
//           ),
//         ),
//       ),
//       const SizedBox( height: 40),
//     ]);
//   }
// }
