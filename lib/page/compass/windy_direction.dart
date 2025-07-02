// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;
import 'package:xhero_windows_app/resource/assets_constant/frames_constant.dart';

import '../../../resource/assets_constant/images_constants.dart';
import '../../constants/colors.dart';
import '../../constants/common.dart';
import '../../resource/assets_constant/icon_constants.dart';
import '../../shared/text_style.dart';
import '../../utils/logic/common_widget.dart';
import '../../utils/logic/xhero_common_logics.dart';
import 'model/location_model.dart';
import 'search_location.dart';

class WindDirectionScreen extends StatefulWidget {
  final String location;
  final LatLng latLng;
  const WindDirectionScreen({
    super.key,
    required this.location,
    required this.latLng,
  });

  @override
  State<WindDirectionScreen> createState() => _WindDirectionScreenState();
}

class _WindDirectionScreenState extends State<WindDirectionScreen> {
  InAppWebViewController? webViewController;
  bool _isShowCompass = false;
  ScreenshotController screenshotController = ScreenshotController();
  String currentSearch = '';
  List<String> icMapTypes = [
    IconConstants.ic_windy_map_2,
    IconConstants.ic_windy_map,
    IconConstants.ic_rainy_map,
    IconConstants.ic_satellite_map,
  ];
  int _indexMapType = 0;
  List<String> titleMapTypes = [
    'windy_map_type_2',
    'windy_map',
    'rainy_map',
    'satellite_map',
  ];
  Future<String> getAddressFromLatLngFinal(double lat, double lng) async {
    String apiKey =
        "AIzaSyAtU1dcmkxSmt4yUDlR7A3liYHr4skxcFc"; // Thay bằng API key của bạn
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse kết quả JSON
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          // Lấy địa chỉ đầy đủ từ kết quả đầu tiên
          String address = data['results'][0]['formatted_address'];

          EasyLoading.dismiss();
          return address;
        } else {
          EasyLoading.dismiss();
          return "No Address Found";
        }
      } else {
        EasyLoading.dismiss();
        return "Failed to get address";
      }
    } catch (e) {
      EasyLoading.dismiss();
      printConsole("Error occurred while getting address: $e");
      return "No Address";
    }
  }

  Color _imageColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  void updateWebViewUrl(double newLat, double newLong) {
    if (webViewController != null) {
      webViewController!.loadUrl(
        urlRequest: URLRequest(
          url: WebUri('https://huonggio.xheroapp.com?lat=$newLat&lon=$newLong'),
        ),
      );
    }
  }

  void updateMapType(int idx) async {
    if (webViewController != null) {
      if (idx == 0) {
        webViewController!.loadUrl(
          urlRequest: URLRequest(
            url: WebUri(
              'https://www.msn.com/vi-vn/weather/maps/wind/in-${widget.location}',
            ),
          ),
        );
        webViewController!.loadUrl(
          urlRequest: URLRequest(
            url: WebUri('https://huonggio.xheroapp.com/?weather=windy'),
          ),
        );
        webViewController!.loadUrl(
          urlRequest: URLRequest(
            url: WebUri('https://huonggio.xheroapp.com/?weather=rain'),
          ),
        );
        webViewController!.loadUrl(
          urlRequest: URLRequest(
            url: WebUri('https://huonggio.xheroapp.com/?weather=satellite'),
          ),
        );
      } else {
        webViewController?.loadUrl(
          urlRequest: URLRequest(
            url: WebUri('https://huonggio.xheroapp.com/?weather=satellite'),
          ),
        );
      }
    }
    setState(() {
      currentSearch = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        frameCommonWidget(
          background: 'background.png',
          isShowAction: true,
          onTap: () async {
            Get.back();
            // // Kiểm tra nếu có thể quay lại trang trước đó trong WebView
            // if (await webViewController!.canGoBack()) {
            //   // Quay lại trang trước đó
            //   webViewController!.goBack();
            // } else {
            //   // Nếu không thể quay lại, xử lý thoát khỏi trang (ví dụ đóng WebView hoặc thoát về trang chính)
            //   Get.back();
            // }
          },
          action: onTapWidget(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: AppColor.whiteColor,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: AppColor.newPrimaryColor2,
                          width: 6,
                        ),
                      ),
                      image: const DecorationImage(
                        image: AssetImage(ImageConstants.img_bg_mbs_flower),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
                    width: Get.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Text(
                              'select_map_type'.tr,
                              style: TextAppStyle().titleStyle().copyWith(
                                color: AppColor.primaryColor,
                              ),
                            ),
                            onTapWidget(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Icon(
                                  CupertinoIcons.clear,
                                  color: AppColor.primaryColor,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 0.5,
                          width: Get.width - 48,
                          margin: const EdgeInsets.only(top: 16, bottom: 0),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withAlpha(
                              (0.25 * 255).toInt(),
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            icMapTypes.length,
                            (index) => onTapWidget(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  _indexMapType = index;
                                });
                                updateMapType(_indexMapType);
                                Toastification().show(
                                  autoCloseDuration: const Duration(seconds: 2),
                                  borderSide: BorderSide.none,
                                  dragToClose: true,
                                  borderRadius: BorderRadius.circular(16),
                                  style: ToastificationStyle.flat,
                                  margin: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    40,
                                  ),
                                  backgroundColor: AppColor.actionTextYellow,
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    0,
                                    16,
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  showProgressBar: false,
                                  closeButtonShowType: CloseButtonShowType.none,
                                  icon: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      AppColor.textBrownDark,
                                      BlendMode.srcATop,
                                    ),
                                    child: SvgPicture.asset(
                                      _indexMapType == 0
                                          ? icMapTypes[0]
                                          : _indexMapType == 1
                                          ? icMapTypes[1]
                                          : _indexMapType == 2
                                          ? icMapTypes[2]
                                          : icMapTypes[3],
                                      width: 44,
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'change_map_successfully'.tr,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextAppStyle()
                                            .normalTextStyleSmallLight()
                                            .copyWith(
                                              color: AppColor.textBrownDark,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${'switch_to'.tr} ${titleMapTypes[index].tr}',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextAppStyle()
                                            .thinTextStyleExtraSmallLight()
                                            .copyWith(
                                              color: AppColor.textBrownDark,
                                              fontSize: 12.5,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          icMapTypes[index],
                                          width: widthFlexible(28),
                                          height: widthFlexible(28),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          titleMapTypes[index].tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextAppStyle()
                                              .semiBoldTextStyleLarge()
                                              .copyWith(
                                                color: index == 4
                                                    ? AppColor.colorRedBold
                                                    : AppColor.grayLightColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                    _indexMapType == index
                                        ? SvgPicture.asset(
                                            IconConstants.ic_checked_gradient,
                                            width: 28,
                                            height: 28,
                                          )
                                        : SizedBox(width: widthFlexible(28)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: SvgPicture.asset(
                IconConstants.ic_layer_maps,
                width: 40,
                height: 40,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      child: InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: WebUri(
                            'https://www.msn.com/vi-vn/weather/maps/wind/in-${widget.location}',
                          ),
                        ),
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            javaScriptEnabled: true,
                            useShouldOverrideUrlLoading: true,
                            mediaPlaybackRequiresUserGesture: false,
                          ),
                        ),
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        },
                        onLoadStop: (controller, url) async {
                          EasyLoading.dismiss();
                        },
                        onLoadError: (controller, url, code, message) {
                          EasyLoading.dismiss();
                        },
                      ),
                    ),
                    _isShowCompass
                        ? Positioned.fill(
                            child: IgnorePointer(
                              ignoring: true,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Transform.rotate(
                                        angle: 0,
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            _imageColor,
                                            BlendMode.srcATop,
                                          ),
                                          child: Image.asset(
                                            FrameConstants.fr_compass_satellite,
                                            width:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width >
                                                    500
                                                ? (isSamsungZFold(context)
                                                      ? 400
                                                      : Get.width / 1.5)
                                                : 360,
                                            height:
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width >
                                                    500
                                                ? (isSamsungZFold(context)
                                                      ? 400
                                                      : Get.width / 1.5)
                                                : 360,
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: Transform.rotate(
                                            angle: 0,
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 4,
                                                        ),
                                                    child: Image.asset(
                                                      IconConstants
                                                          .ic_marker_map,
                                                      width: 24,
                                                      height: 24,
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
                                  const SizedBox(height: 0),
                                ],
                              ),
                            ),
                          )
                        : Positioned.fill(
                            child: IgnorePointer(
                              ignoring: true,
                              child: SizedBox(
                                width: Get.width,
                                height: Get.width,
                              ),
                            ),
                          ),
                    if (_indexMapType != 0)
                      Positioned(
                        top: 116,
                        left: 16,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 42,
                              width: Get.width - 24 - 50,
                              child: onTapWidget(
                                onTap: () {
                                  Get.to(
                                    () => const SeachLocationScreen(),
                                  )?.then((value) {
                                    if (value != null) {
                                      LocationModel locationModel = value;
                                      updateWebViewUrl(
                                        locationModel.lat,
                                        locationModel.long,
                                      );
                                      setState(() {
                                        currentSearch = locationModel.name;
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    8,
                                    0,
                                    4,
                                    0,
                                  ),
                                  height: 42,
                                  decoration: BoxDecoration(
                                    border: const GradientBoxBorder(
                                      gradient: LinearGradient(
                                        colors: CommonConstants.name,
                                      ),
                                    ),
                                    color: AppColor.primaryColor.withAlpha(
                                      (0.75 * 255).toInt(),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        IconConstants.ic_place_gradient,
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 4),
                                      currentSearch.isNotEmpty
                                          ? Flexible(
                                              child: GradientText(
                                                currentSearch,
                                                colors: CommonConstants.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextAppStyle()
                                                    .thinTextStyle()
                                                    .copyWith(
                                                      fontSize: 16,
                                                      color: AppColor
                                                          .secondaryColor,
                                                    ),
                                              ),
                                            )
                                          : GradientText(
                                              'type_to_search'.tr,
                                              colors: CommonConstants.name,
                                              style: TextAppStyle()
                                                  .thinTextStyle()
                                                  .copyWith(
                                                    fontSize: 16,
                                                    color:
                                                        AppColor.secondaryColor,
                                                  ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            onTapWidget(
                              onTap: () {
                                webViewController?.loadUrl(
                                  urlRequest: URLRequest(
                                    url: WebUri(
                                      'https://huonggio.xheroapp.com?lat=${widget.latLng.latitude}&lon=${widget.latLng.longitude}',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColor.blackColor,
                                  shape: BoxShape.circle,
                                  border: const GradientBoxBorder(
                                    gradient: LinearGradient(
                                      colors: CommonConstants.gradientsLight,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.my_location_rounded,
                                  color: AppColor.borderYellow,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_indexMapType == 0)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: Get.width,
                          height: 32,
                          color: const Color(0xff242424),
                        ),
                      ),
                    Positioned(
                      bottom: 100,
                      left: 16,
                      child: Column(
                        children: [
                          onTapWidget(
                            onTap: () {
                              webViewController?.reload();
                              setState(() {
                                _isShowCompass = !_isShowCompass;

                                if (!_isShowCompass) {
                                  Toastification().show(
                                    autoCloseDuration: const Duration(
                                      seconds: 2,
                                    ),
                                    borderSide: BorderSide.none,
                                    dragToClose: true,
                                    borderRadius: BorderRadius.circular(16),
                                    style: ToastificationStyle.flat,
                                    margin: const EdgeInsets.fromLTRB(
                                      8,
                                      0,
                                      8,
                                      16,
                                    ),
                                    backgroundColor: AppColor.colorRedBold,
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      16,
                                      0,
                                      16,
                                    ),
                                    alignment: Alignment.bottomCenter,
                                    showProgressBar: false,
                                    closeButtonShowType:
                                        CloseButtonShowType.none,
                                    icon: Stack(
                                      children: [
                                        ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            AppColor.secondaryColor,
                                            BlendMode.srcATop,
                                          ),
                                          child: Image.asset(
                                            FrameConstants.fr_compass_satellite,
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColor.blackColor
                                                  .withAlpha(
                                                    (0.5 * 255).toInt(),
                                                  ),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                IconConstants.ic_lock_dark,
                                                width: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'compass_is_hiding'.tr,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextAppStyle()
                                              .normalTextStyleSmallLight(),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  Toastification().show(
                                    autoCloseDuration: const Duration(
                                      seconds: 2,
                                    ),
                                    borderSide: BorderSide.none,
                                    dragToClose: true,
                                    borderRadius: BorderRadius.circular(16),
                                    style: ToastificationStyle.flat,
                                    margin: const EdgeInsets.fromLTRB(
                                      8,
                                      0,
                                      8,
                                      16,
                                    ),
                                    backgroundColor: AppColor.colorGreenDark,
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      16,
                                      0,
                                      16,
                                    ),
                                    alignment: Alignment.bottomCenter,
                                    showProgressBar: false,
                                    closeButtonShowType:
                                        CloseButtonShowType.none,
                                    icon: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        AppColor.secondaryColor,
                                        BlendMode.srcATop,
                                      ),
                                      child: Image.asset(
                                        FrameConstants.fr_compass_satellite,
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'compass_is_showing'.tr,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextAppStyle()
                                              .normalTextStyleSmallLight(),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                _isShowCompass
                                    ? IconConstants.ic_show_compass_map
                                    : IconConstants.ic_show_compass_map_locked,
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                          if (_isShowCompass) const SizedBox(height: 8),
                          if (_isShowCompass)
                            onTapWidget(
                              child: Image.asset(
                                IconConstants.ic_color_picker,
                                width: 40,
                              ),
                              onTap: () {
                                Color pickerColor = _imageColor;

                                showModalBottomSheet(
                                  backgroundColor: AppColor.whiteColor,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder:
                                          (
                                            BuildContext context,
                                            StateSetter setStateColor,
                                          ) {
                                            return Container(
                                              height: Get.height * 0.35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                        26,
                                                      ),
                                                      topRight: Radius.circular(
                                                        26,
                                                      ),
                                                    ),
                                                border: Border(
                                                  top: BorderSide(
                                                    color: AppColor
                                                        .newPrimaryColor2,
                                                    width: 6,
                                                  ),
                                                ),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                    ImageConstants
                                                        .img_bg_mbs_flower,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    0,
                                                    16,
                                                    0,
                                                    24,
                                                  ),
                                              width: Get.width,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const SizedBox(width: 40),
                                                      Text(
                                                        'pick_color_compass'.tr,
                                                        style: TextAppStyle()
                                                            .titleStyle()
                                                            .copyWith(
                                                              color: AppColor
                                                                  .grayLightColor,
                                                            ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                right: 24,
                                                              ),
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .clear,
                                                            color: AppColor
                                                                .grayLightColor,
                                                            size: 28,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 0.5,
                                                    width: Get.width - 48,
                                                    margin:
                                                        const EdgeInsets.only(
                                                          top: 16,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColor
                                                          .primaryColor
                                                          .withAlpha(
                                                            (0.25 * 255)
                                                                .toInt(),
                                                          ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: GridView.builder(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 24,
                                                            vertical: 24,
                                                          ),
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 5,
                                                            crossAxisSpacing:
                                                                8.0,
                                                            mainAxisSpacing:
                                                                8.0,
                                                            childAspectRatio:
                                                                1.0,
                                                          ),
                                                      itemCount: CommonConstants
                                                          .colorsPicker
                                                          .length,
                                                      itemBuilder: (context, index) {
                                                        final color =
                                                            CommonConstants
                                                                .colorsPicker[index];
                                                        final isSelected =
                                                            pickerColor ==
                                                            color;
                                                        return GestureDetector(
                                                          onTap: () {
                                                            setStateColor(() {
                                                              pickerColor =
                                                                  color;
                                                              _imageColor =
                                                                  pickerColor;
                                                            });

                                                            setState(() {
                                                              // Cập nhật lại màu chính
                                                              // Lưu ý: `_imageColor` đã được cập nhật từ `StatefulBuilder`
                                                            });
                                                          },
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      2,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  border:
                                                                      Border.all(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            color,
                                                                      ),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Container(
                                                                  width:
                                                                      (Get.width -
                                                                          48) /
                                                                      5,
                                                                  height:
                                                                      (Get.width -
                                                                          48) /
                                                                      5,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color:
                                                                        color,
                                                                  ),
                                                                ),
                                                              ),
                                                              if (isSelected)
                                                                SvgPicture.asset(
                                                                  IconConstants
                                                                      .ic_checked_gradient,
                                                                  width: 36,
                                                                ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                    );
                                  },
                                );
                              },
                            ),
                          // const SizedBox(width: 8),
                          // onTapWidget(
                          //   onTap: () async {
                          //     await EasyLoading.show(
                          //         maskType: EasyLoadingMaskType.black);
                          //     _capturePng();

                          // final directory =
                          //     await getApplicationDocumentsDirectory();
                          // final imagePath =
                          //     await screenshotController.captureAndSave(
                          //   directory.path,
                          //   fileName: 'screenshot.png',
                          // );

                          // if (imagePath != null) {
                          //   final compressedImagePath =
                          //       await compressImage(imagePath);

                          //   await EasyLoading.dismiss();

                          //   Share.shareXFiles([XFile(compressedImagePath)]);
                          // } else {
                          //   await EasyLoading.dismiss();
                          // }
                          // },
                          // child: Container(
                          //   decoration: BoxDecoration(
                          //     color: AppColor.primaryColor,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Image.asset(
                          //     IconConstants.ic_share_compass,
                          //     width: widthFlexible(32),
                          //     height: widthFlexible(32),
                          //   ),
                          // ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          titleAppbar: capitalForText(titleMapTypes[_indexMapType].tr),
        ),
      ],
    );
  }

  Future<String> compressImage(String imagePath) async {
    try {
      final compressedImageBytes = await FlutterImageCompress.compressWithFile(
        imagePath,
        minHeight: 1080,
        minWidth: 1080,
        quality: 10,
      );

      final directory = await getApplicationDocumentsDirectory();
      final compressedImagePath = '${directory.path}/compressed_screenshot.png';
      final compressedImageFile = File(compressedImagePath);

      await compressedImageFile.writeAsBytes(compressedImageBytes!);

      return compressedImagePath;
    } catch (e) {
      printConsole('Error compressing image: $e');
      return imagePath;
    }
  }
}
