// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:simple_gradient_text/simple_gradient_text.dart';

// import '../../../constants/colors.dart';
// import '../../../constants/common.dart';
// import '../../../datasource/fetch_api_repository.dart';
// import '../../../reponse/category/categories_data_response.dart';
// import '../../../resource/assets_constant/frames_constant.dart';
// import '../../../resource/assets_constant/icon_constants.dart';
// import '../../../resource/assets_constant/images_constants.dart';
// import '../../../shared/multi_appear_widgets/gradient_border_container.dart';
// import '../../../shared/text_style.dart';
// import '../../../utils/logic/common_widget.dart';
// import '../../../utils/logic/xhero_common_logics.dart';

// class IncenseAndLampsInside extends StatefulWidget {
//   final String id;
//   final String title;
//   final XheroFetchApiRespository uiRepository;
//   final String background;
//   final String icon;

//   const IncenseAndLampsInside({
//     super.key,
//     required this.id,
//     required this.title,
//     required this.uiRepository,
//     required this.background,
//     required this.icon,
//   });

//   @override
//   State<IncenseAndLampsInside> createState() => _IncenseAndLampsInsideState();
// }

// class _IncenseAndLampsInsideState extends State<IncenseAndLampsInside> {
//   List<Categories> lstChildIAL = [];
//   bool isLoading = true;
//   List<Descriptions> descriptions = [];
//   int numberOfTouch = 0;

//   @override
//   void initState() {
//     super.initState();
//     getCategoriesData(iIaL: widget.id);
//   }

//   Future<void> getCategoriesData({required String iIaL}) async {
//     await EasyLoading.show(maskType: EasyLoadingMaskType.black);
//     try {
//       final response = await widget.uiRepository.getCateById(iIaL);
//       if (response.status ?? false) {
//         setState(() {
//           lstChildIAL = response.data ?? [];
//           descriptions = response.data
//                   ?.expand((category) => category.descriptions ?? [])
//                   .toList()
//                   .cast<Descriptions>() ??
//               [];
//           isLoading = false;
//         });
//         // printConsole(descriptions.length.toString() + 'is have desc');
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (onError) {
//       printConsole('Error fetching categories: $onError');
//       setState(() {
//         isLoading = false;
//       });
//     } finally {
//       EasyLoading.dismiss();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // AppDataGlobal.isJustBackAtIAL = true;
//           // Get.toNamed(Routes.INCENSEANDLAMPS, arguments: {
//           //   'id': AppDataGlobal.idIAL,
//           //   'isShowBtn': AppDataGlobal.isShowBtnIAL
//           // });
//         },
//         backgroundColor:
//             Colors.transparent, // Đặt nền trong suốt để chỉ thấy hình tròn
//         elevation: 0,
//         child: Image.asset(
//             IconConstants.ic_menu_incense_n_lamps), // Không cần đổ bóng
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
//       // Các phần còn lại của Scaffold
//       body: isLoading
//           ? Stack(children: [
//               Container(
//                 width: Get.width,
//                 height: Get.height,
//                 decoration: const BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage(
//                           ImageConstants.img_bg_i_a_l,
//                         ),
//                         fit: BoxFit.fill)),
//               ),
//             ])
//           : descriptions.isNotEmpty
//               ? buildDescriptionss(descriptions)
//               : buildCategories(),
//       // a: capitalForText(widget.title),
//     );
//   }

//   Widget buildCategories() {
//     printConsole(numberOfTouch.toString());
//     return frameCommonWidget(
//         background: ImageConstants.img_bg_i_a_l,
//         isShowAction: true,
//         action: onTapWidget(
//             child: Image.asset(
//               IconConstants.ic_search_incense_lamps_pray_gradient,
//               width: 50,
//               height: 40,
//             ),
//             onTap: () {
//               // Get.to(() => SeachIncenseLampsPrayScreen(
//               //       uiRepository: widget.uiRepository,
//               //       textSearch: '',
//               //     ));
//             }),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox( height: 124),
//             _searchBar(context),
//             // const SizedBox( height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox( height: 16),
//                     Column(
//                       children: List.generate(lstChildIAL.length, (index) {
//                         return onTapWidget(
//                           onTap: () {
//                             setState(() {
//                               numberOfTouch += 1;
//                             });
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => IncenseAndLampsInside(
//                                   id: lstChildIAL[index].id!,
//                                   title: lstChildIAL[index].name!,
//                                   uiRepository: widget.uiRepository,
//                                   background: widget.background,
//                                   icon: widget.icon,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             // width: getResponsiveWidth(context) - 48,
//                             height: optimizedSize(
//                                 phone: 80,
//                                 zfold: 100,
//                                 tablet: 140,
//                                 context: context),
//                             margin: const EdgeInsets.fromLTRB(0, 0, 16, 8),
//                             padding: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 16)
//                                 .copyWith(
//                                     left: optimizedSize(
//                                         phone: 68,
//                                         zfold: 108,
//                                         tablet: 148,
//                                         context: context),
//                                     right: 24),
//                             decoration: const BoxDecoration(
//                               image: DecorationImage(
//                                 image: AssetImage(
//                                     FrameConstants.fr_bg_i_a_l_category),
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: optimizedSize(
//                                                 phone: 32,
//                                                 zfold: 44,
//                                                 tablet: 52,
//                                                 context: context),
//                                             height: optimizedSize(
//                                                 phone: 32,
//                                                 zfold: 44,
//                                                 tablet: 52,
//                                                 context: context),
//                                             decoration: BoxDecoration(
//                                                 color:
//                                                     AppColor.transparentColor,
//                                                 border: const GradientBoxBorder(
//                                                     gradient:
//                                                         LinearGradient(colors: [
//                                                   Color(0xffC5923D),
//                                                   Color(0xffC5923D),
//                                                 ])),
//                                                 shape: BoxShape.circle),
//                                             child: Center(
//                                               child: SizedBox(
//                                                 width: optimizedSize(
//                                                     phone: 28,
//                                                     zfold: 34,
//                                                     tablet: 44,
//                                                     context: context),
//                                                 height: optimizedSize(
//                                                     phone: 28,
//                                                     zfold: 34,
//                                                     tablet: 44,
//                                                     context: context),
//                                                 child: Center(
//                                                   child: GradientText(
//                                                     '${index + 1}',
//                                                     maxLines: 2,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: TextAppStyle()
//                                                         .titleStyleLight()
//                                                         .copyWith(
//                                                             fontFamily:
//                                                                 'FairPlay',
//                                                             fontSize:
//                                                                 optimizedSize(
//                                                                     phone: 18,
//                                                                     zfold: 22,
//                                                                     tablet: 24,
//                                                                     context:
//                                                                         context),
//                                                             fontWeight:
//                                                                 FontWeight.w700,
//                                                             color: const Color(
//                                                                 0xfffaf8f0)),
//                                                     colors: const [
//                                                       Color(0xffC5923D),
//                                                       Color(0xffF6D544),
//                                                       Color(0xffC5923D),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 8),
//                                           Flexible(
//                                             child: GradientText(
//                                               lstChildIAL[index].name ?? '',
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextAppStyle()
//                                                   .normalTextStyleSmall()
//                                                   .copyWith(
//                                                     fontFamily:
//                                                         'FairPlayItalic',
//                                                   ),
//                                               colors: [
//                                                 const Color(0xff331F15)
//                                                     .withAlpha(
//                                                         (0.75 * 255).toInt()),
//                                                 const Color(0xffC5923D),
//                                                 const Color(0xffC5923D),
//                                                 const Color(0xffC5923D),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                     const SizedBox( height: 100),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         titleAppbar: capitalForText(widget.title));
//   }

//   Widget buildDescriptionss(List<Descriptions> descriptions) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             Container(
//               width: Get.width,
//               height: Get.height,
//               decoration: BoxDecoration(
//                   color: AppColor.lightBackgroundColor,
//                   image: DecorationImage(
//                       image: AssetImage(ImageConstants.img_bg_i_a_l),
//                       fit: BoxFit.fill)),
//             ),
//             Container(
//               width: Get.width,
//               height: Get.height,
//               color:
//                   AppColor.lightBackgroundColor.withAlpha((0.3 * 255).toInt()),
//             ),
//             Positioned.fill(
//               child: ListView.separated(
//                 padding: const EdgeInsets.only(top: 124, bottom: 100),
//                 itemCount: descriptions.length,
//                 itemBuilder: (context, index) {
//                   final isWritePray =
//                       containsVanKhan(descriptions[index].title.trim());
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     decoration: BoxDecoration(
//                       color: AppColor.sandColor,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColor.shadowColor,
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                       border: Border.all(
//                         color: AppColor.actionTextYellow,
//                         width: 1,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 8),
//                           child: onTapWidget(
//                             onTap: isWritePray
//                                 ? () {
//                                     // Get.to(() => IncenseLampsOnePray(title: descriptions[index].title, contents: descriptions[index].content));
//                                   }
//                                 : null,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         '${toRomanNumeral(index + 1)}.',
//                                         style: TextAppStyle()
//                                             .titleStyleLarge()
//                                             .copyWith(
//                                                 fontSize: 17,
//                                                 color: AppColor.textBrownDark),
//                                       ),
//                                       const SizedBox( width: 8),
//                                       Flexible(
//                                         child: Text(
//                                           descriptions[index].title.trim(),
//                                           textAlign: TextAlign.left,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextAppStyle()
//                                               .normalTextStyle()
//                                               .copyWith(
//                                                   fontFamily:
//                                                       CommonConstants.bold,
//                                                   fontSize: 16,
//                                                   color: AppColor.brownColor,
//                                                   fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox( width: 24),
//                                 // if (isWritePray)
//                                 //   ColorFiltered(
//                                 //       colorFilter: ColorFilter.mode(
//                                 //         AppColor.brownColor,
//                                 //         BlendMode
//                                 //             .srcIn, // Phương thức pha trộn màu
//                                 //       ),
//                                 //       child: Image.asset(
//                                 //         IconConstants.ic_arrow_right_dark,
//                                 //         width: 20,
//                                 //         height: 20,
//                                 //         fit: BoxFit.contain,
//                                 //       ))
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: Get.width,
//                           height: 0.5,
//                           color: AppColor.actionTextYellow,
//                         ),
//                         Stack(
//                           children: [
//                             Positioned.fill(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       margin: const EdgeInsets.all(24),
//                                       width: getResponsiveWidth(context) / 1.5,
//                                       height: getResponsiveWidth(context) / 1.5,
//                                       // height: getResponsiveWidth(context) / 2,
//                                       padding: const EdgeInsets.all(12),
//                                       decoration: const BoxDecoration(
//                                           image: DecorationImage(
//                                               image: AssetImage(
//                                                   'assets/images/img_bg_dainam_trans.png'),
//                                               fit: BoxFit.contain)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // Padding(
//                             //   padding:
//                             //       const EdgeInsets.only(left: 10, right: 8),
//                             //   child: Html(
//                             //     data: descriptions[index].content,
//                             //     style: {
//                             //       "img": Style(
//                             //         width: Width(Get.width - 40),
//                             //       ),
//                             //       "body": Style(
//                             //           fontSize: FontSize(15.0),
//                             //           textAlign: TextAlign.left,
//                             //           color: AppColor.brownColor,
//                             //           fontFamily: CommonConstants.light),
//                             //     },
//                             //   ),
//                             //   // Text(
//                             //   //   descriptions[index].content,
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 separatorBuilder: (context, index) => const SizedBox( height: 16),
//               ),
//             ),
//             Positioned(
//               child: Container(
//                 width: Get.width,
//                 height: 108,
//                 decoration: const BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage(ImageConstants.img_bg_appbar),
//                         fit: BoxFit.fill)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16, bottom: 8),
//                       child: onTapWidget(
//                         onTap: Get.back,
//                         child: Image.asset(
//                           IconConstants.ic_arrow_back_auth,
//                           width: 54,
//                           height: 40,
//                         ),
//                       ),
//                     ),
//                     Flexible(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             bottom: 12, right: 12, left: 12),
//                         child: GradientText(
//                           capitalForText(widget.title),
//                           colors: CommonConstants.gradientsText,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextAppStyle().appBarTitleLight().copyWith(
//                                 fontSize: 18,
//                                 letterSpacing: 0.25,
//                               ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 16, bottom: 8),
//                       child: onTapWidget(
//                           onTap: () {
//                             // String url = AppDataGlobal.supportInfo
//                             //     .urlIaLBook; // This will hold the URL with the token
//                             // if (AppDataGlobal.IS_SIGNED_IN ?? false) {
//                             //   url = AppDataGlobal.supportInfo.urlIaLBook;
//                             //   if (AppDataGlobal.ACCESS_TOKEN != null) {
//                             //     url +=
//                             //         '?accessToken=${AppDataGlobal.ACCESS_TOKEN}';
//                             //   }
//                             //   printConsole(
//                             //       url); // Print the URL to check if it's correct
//                             //   Get.to(() => WebViewScreen(
//                             //       url: url, title: 'Phong Thuỷ Đại Nam'.tr));
//                             //   return;
//                             // } else {
//                             //   AppDataGlobal.authForPTDNViaDeeplink = true;
//                             //   AppDataGlobal.valuePTDNDeeplink = AppDataGlobal
//                             //       .supportInfo
//                             //       .urlIaLBook; // Always use the original URL here
//                             //   ToastUtil.showSignInRequiredToast();
//                             //   Get.toNamed(Routes.SIGNIN);
//                             //   return;
//                             // }
//                           },
//                           child: Image.asset(
//                             IconConstants.ic_btn_dainam,
//                             width: 40,
//                           )),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   bool containsVanKhan(String input) {
//     return input.toLowerCase().contains('văn khấn') ||
//         input.toLowerCase().contains('văn lễ');
//   }

//   Widget _searchBar(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //         builder: (context) => SeachIncenseLampsScreen(
//               //             uiRepository: widget.uiRepository, textSearch: '')));
//             },
//             child: Container(
//                 width: getResponsiveWidth(context),
//                 padding: const EdgeInsets.only(left: 24, right: 12),
//                 child: GradientBorderContainer(
//                   padding: const EdgeInsets.all(1),
//                   radius: 9,
//                   margin: EdgeInsets.zero,
//                   child: Container(
//                     width: (getResponsiveWidth(context) - 80 - 25 - 41),
//                     height: 40,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withAlpha((0.9 * 255).toInt()),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Center(
//                         child: Row(
//                       children: [
//                         ColorFiltered(
//                           colorFilter: ColorFilter.mode(
//                               AppColor.borderYellow, BlendMode.srcATop),
//                           child: Image.asset(
//                             IconConstants.ic_search_light,
//                             width: 24,
//                             height: 24,
//                           ),
//                         ),
//                         const SizedBox( width: 4),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 1.5),
//                           child: GradientText(
//                             'search_i_a_l'.tr,
//                             colors: CommonConstants.name,
//                             style: TextAppStyle().thinTextStyle().copyWith(
//                                 color: AppColor.secondaryColor, fontSize: 14),
//                           ),
//                         )
//                       ],
//                     )),
//                   ),
//                 )),
//           ),
//         ),
//         // Container(
//         //   decoration: BoxDecoration(
//         //       borderRadius: BorderRadius.circular(8),
//         //       border: const GradientBoxBorder(
//         //           gradient:
//         //               LinearGradient(colors: CommonConstants.gradientsLight)),
//         //       gradient:
//         //           LinearGradient(colors: CommonConstants.gradientBrownBtn)),
//         //   padding: const EdgeInsets.all(4),
//         //   child: const GradientIcon(
//         //     icon: Icons.keyboard_voice_rounded,
//         //     gradient: LinearGradient(colors: CommonConstants.gradientsLight),
//         //     size: 26,
//         //   ),
//         // ),
//         const SizedBox( width: 16),
//       ],
//     );
//   }
// }
