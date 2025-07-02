import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:screenshot/screenshot.dart';
import 'package:showcaseview/showcaseview.dart';
import 'dart:math' as math;
import '../../../resource/assets_constant/images_constants.dart';
import '../../constants/colors.dart';
import '../../constants/common.dart';
import '../../resource/assets_constant/frames_constant.dart';
import '../../resource/assets_constant/icon_constants.dart';
import '../../shared/multi_appear_widgets/custom_showcase_widget.dart';
import '../../shared/multi_appear_widgets/gradient_border_container.dart';
import '../../shared/text_style.dart';
import '../../utils/logic/common_widget.dart';
import '../../utils/logic/xhero_common_logics.dart';
import 'widget/zoom_image.dart';

class ExtremeRulerScreen extends StatefulWidget {
  final String imageUrl;
  final String? file;
  final bool? isPDFFile;
  const ExtremeRulerScreen({
    super.key,
    required this.imageUrl,
    this.isPDFFile = false,
    this.file,
  });

  @override
  State<ExtremeRulerScreen> createState() => _ExtremeRulerScreenState();
}

class _ExtremeRulerScreenState extends State<ExtremeRulerScreen> {
  double _rotationForCompass = 0;
  double _rotationForImage = 0;
  double rotationForImageValue = 0;
  DireCoor? selectedDireCoor;
  bool isCapturingScreen = false;
  Color _imageColor = Colors.white;
  ScreenshotController screenshotController = ScreenshotController();
  String? codeOfDegree;
  bool hasText = false;
  bool ignoringSatellite = false;
  bool isZoomImage = false;

  final GlobalKey one = GlobalKey();
  final GlobalKey two = GlobalKey();
  final GlobalKey three = GlobalKey();
  final GlobalKey four = GlobalKey();
  final GlobalKey five = GlobalKey();
  final GlobalKey six = GlobalKey();
  final GlobalKey seven = GlobalKey();
  final GlobalKey eight = GlobalKey();
  final GlobalKey nine = GlobalKey();
  final GlobalKey ten = GlobalKey();
  final GlobalKey eleven = GlobalKey();
  final GlobalKey twelve = GlobalKey();
  final GlobalKey thirteen = GlobalKey();
  var isShowCaseCompleted = false;
  bool isHideAllControl = false;
  void startShowcase(BuildContext context) {
    ShowCaseWidget.of(context).startShowCase([
      one,
      two,
      three,
      four,
      five,
      six,
      seven,
      eight,
      nine,
      ten,
      eleven,
      twelve,
    ]);
  }

  final TextEditingController _controller = TextEditingController();
  void _updateRotationFromTextField(String value) {
    setState(() {
      // Thay thế dấu phẩy bằng dấu chấm để phù hợp với định dạng số của Dart
      String normalizedValue = value.replaceAll(',', '.');

      // Phân tích chuỗi thành số
      double? rotation = double.tryParse(normalizedValue);

      if (rotation != null && rotation >= 0 && rotation <= 360) {
        _rotationForCompass = rotation;
      } else {
        _controller.text = _rotationForCompass.toStringAsFixed(1);
        // Optionally show an error message or some feedback
      }
    });
  }

  @override
  void initState() {
    setState(() {
      hasText = _controller.text.isNotEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controller.removeListener(() {});
  }

  // Biến điều khiển zoom/kéo của thanh chỉ đỏ
  double overlayScale = 1.0;
  Offset overlayOffset = Offset.zero;

  // Biến điều khiển zoom/kéo của ảnh
  double _imageScale = 1.0;
  Offset _imageOffset = Offset.zero;
  // Thiết lập giới hạn zoom cho ảnh và overlay
  final double minScale = 0.5; // Minimum scale factor
  final double maxScale = 3.0; // Maximum scale factor
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onStart: (index, key) {},
      onComplete: (index, key) {},
      blurValue: 2,
      autoPlayDelay: const Duration(seconds: 3),
      builder: (ctx) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Screenshot(
            controller: screenshotController,
            child: frameCommonWidget(
              background: 'background.png',
              onTap: () {
                Get.back(result: '');
              },
              isShowAction: !isCapturingScreen,
              isHiddenBack: isCapturingScreen,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        image: const DecorationImage(
                          image: AssetImage(ImageConstants.img_bg_mbs_flower),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: Get.width,
                      height: Get.height,
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ZoomableImage(
                              child: Center(
                                child: Transform.translate(
                                  offset: _imageOffset,
                                  child: Transform.scale(
                                    scale: _imageScale,
                                    child: Transform.rotate(
                                      angle:
                                          _rotationForImage *
                                          3.14159 /
                                          180, // Convert degrees to radians
                                      child: Image.network(
                                        widget.imageUrl,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ZoomableImage(
                              child: Stack(
                                children: [
                                  Center(
                                    child: Transform.rotate(
                                      angle:
                                          -_rotationForCompass *
                                          (math.pi / 180),
                                      child: _imageColor == Colors.white
                                          ? Image.asset(
                                              FrameConstants
                                                  .fr_compass_satellite,
                                              width: optimizedSize(
                                                phone: Get.width - 16,
                                                zfold: Get.width / 1.75,
                                                tablet: Get.width / 1.25,
                                                context: context,
                                              ),
                                              height: optimizedSize(
                                                phone: Get.width - 16,
                                                zfold: Get.width / 1.75,
                                                tablet: Get.width / 1.25,
                                                context: context,
                                              ),
                                            )
                                          : ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                _imageColor,
                                                BlendMode.srcATop,
                                              ),
                                              child: Image.asset(
                                                FrameConstants
                                                    .fr_compass_satellite,
                                                width: optimizedSize(
                                                  phone: Get.width - 16,
                                                  zfold: Get.width / 1.75,
                                                  tablet: Get.width / 1.25,
                                                  context: context,
                                                ),
                                                height: optimizedSize(
                                                  phone: Get.width - 16,
                                                  zfold: Get.width / 1.75,
                                                  tablet: Get.width / 1.25,
                                                  context: context,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomShowCaseWidget(
                                          index: 2,
                                          keySC: two,
                                          title: 'Xhero',
                                          description:
                                              'extreme_ruler_tutorial_step_2',
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 0,
                                            ),
                                            width: 80,
                                            height: 24,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical: 0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColor.colorRed,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                width: 1,
                                                color: AppColor.textLightColor,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${_rotationForCompass.toStringAsFixed(1)}\u00B0',
                                                textScaler:
                                                    const TextScaler.linear(1),
                                                style: TextAppStyle()
                                                    .titleStyleSmallLight(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 0.75,
                                          ),
                                          child: Image.asset(
                                            FrameConstants.fr_line_x_y,
                                            width: optimizedSize(
                                              phone: Get.width - 60,
                                              zfold: Get.width / 1.9,
                                              tablet: Get.width / 1.45,
                                              context: context,
                                            ),
                                            height: optimizedSize(
                                              phone: Get.width - 60,
                                              zfold: Get.width / 1.9,
                                              tablet: Get.width / 1.45,
                                              context: context,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24.5),
                                      ],
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          IconConstants.ic_logo_dn_35,
                                          width: optimizedSize(
                                            phone: 100,
                                            zfold: 108,
                                            tablet: 132,
                                            context: context,
                                          ),
                                          height: optimizedSize(
                                            phone: 100,
                                            zfold: 108,
                                            tablet: 132,
                                            context: context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            isCapturingScreen
                                ? Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8,
                                        left: 4,
                                        right: 0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Image.asset(
                                            'logo_with_slogan.png',
                                            height: 54,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            isCapturingScreen
                                ? Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8,
                                        left: 0,
                                        right: 8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const SizedBox(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 4,
                                              right: 4,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'img_qr_code.png',
                                                width: 80,
                                                height: 80,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : isHideAllControl
                                ? const SizedBox()
                                : Positioned(
                                    bottom: 50,
                                    right: 16,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: const GradientBoxBorder(
                                          gradient: LinearGradient(
                                            colors:
                                                CommonConstants.gradientsLight,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          onTapWidget(
                                            onTap: () {
                                              setState(() {
                                                overlayOffset = Offset.zero;
                                                overlayScale = 1;
                                                _imageOffset = Offset.zero;
                                                _imageScale = 1;
                                                _rotationForImage = 0;
                                                _rotationForCompass = 0;
                                              });
                                            },
                                            child: CustomShowCaseWidget(
                                              index: 4,
                                              keySC: four,
                                              title: 'Xhero',
                                              description:
                                                  'extreme_ruler_tutorial_step_8',
                                              child: Image.asset(
                                                IconConstants
                                                    .ic_refresh_gradient,
                                                width: 32,
                                                height: 32,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          onTapWidget(
                                            onTap: () {
                                              Color pickerColor = _imageColor;
                                              showModalBottomSheet(
                                                backgroundColor:
                                                    AppColor.whiteColor,
                                                isScrollControlled: true,
                                                context: ctx,
                                                builder: (ctx) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (
                                                          BuildContext ctx,
                                                          StateSetter
                                                          setStateColor,
                                                        ) {
                                                          return Container(
                                                            height:
                                                                Get.height *
                                                                0.35,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius.only(
                                                                    topLeft:
                                                                        Radius.circular(
                                                                          26,
                                                                        ),
                                                                    topRight:
                                                                        Radius.circular(
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
                                                                fit: BoxFit
                                                                    .cover,
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
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: 40,
                                                                    ),
                                                                    Text(
                                                                      'pick_color_compass'
                                                                          .tr,
                                                                      style: TextAppStyle()
                                                                          .titleStyle()
                                                                          .copyWith(
                                                                            color:
                                                                                AppColor.primaryColor,
                                                                          ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(
                                                                          right:
                                                                              24,
                                                                        ),
                                                                        child: Icon(
                                                                          CupertinoIcons
                                                                              .clear,
                                                                          color:
                                                                              AppColor.primaryColor,
                                                                          size:
                                                                              28,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  height: 0.5,
                                                                  width:
                                                                      Get.width -
                                                                      48,
                                                                  margin:
                                                                      const EdgeInsets.only(
                                                                        top: 16,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColor
                                                                        .primaryColor
                                                                        .withAlpha(
                                                                          (0.25 *
                                                                                  255)
                                                                              .toInt(),
                                                                        ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: GridView.builder(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          24,
                                                                      vertical:
                                                                          24,
                                                                    ),
                                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount:
                                                                          isSamsungZFold(
                                                                            context,
                                                                          )
                                                                          ? 8
                                                                          : 5,
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
                                                                    itemBuilder:
                                                                        (
                                                                          context,
                                                                          index,
                                                                        ) {
                                                                          final color =
                                                                              CommonConstants.colorsPicker[index];
                                                                          final isSelected =
                                                                              pickerColor ==
                                                                              color;
                                                                          return GestureDetector(
                                                                            onTap: () {
                                                                              setStateColor(
                                                                                () {
                                                                                  pickerColor = color;
                                                                                  _imageColor = pickerColor;
                                                                                },
                                                                              );

                                                                              setState(
                                                                                () {
                                                                                  // Cập nhật lại màu chính
                                                                                  // Lưu ý: `_imageColor` đã được cập nhật từ `StatefulBuilder`
                                                                                },
                                                                              );
                                                                            },
                                                                            child: Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.all(
                                                                                    2,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      width: 1,
                                                                                      color: color,
                                                                                    ),
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                  child: Container(
                                                                                    width: optimizedSize(
                                                                                      phone:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          5,
                                                                                      zfold:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          9,
                                                                                      tablet:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          7,
                                                                                      context: context,
                                                                                    ),
                                                                                    height: optimizedSize(
                                                                                      phone:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          5,
                                                                                      zfold:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          9,
                                                                                      tablet:
                                                                                          (Get.width -
                                                                                              48) /
                                                                                          7,
                                                                                      context: context,
                                                                                    ),
                                                                                    decoration: BoxDecoration(
                                                                                      shape: BoxShape.circle,
                                                                                      color: color,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                if (isSelected)
                                                                                  SvgPicture.asset(
                                                                                    IconConstants.ic_checked_gradient,
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
                                            child: CustomShowCaseWidget(
                                              index: 3,
                                              keySC: three,
                                              title: 'Xhero',
                                              description:
                                                  'extreme_ruler_tutorial_step_3',
                                              child: Image.asset(
                                                IconConstants.ic_color_picker,
                                                width: 32,
                                                height: 32,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          onTapWidget(
                                            onTap: () {
                                              setState(() {
                                                isHideAllControl =
                                                    !isHideAllControl;
                                              });
                                            },
                                            child: CustomShowCaseWidget(
                                              index: 9,
                                              keySC: nine,
                                              isFinished: true,
                                              title: 'Xhero',
                                              description:
                                                  'extreme_ruler_tutorial_step_9',
                                              child: Image.asset(
                                                IconConstants
                                                    .ic_show_compass_map_locked,
                                                width: 32,
                                                height: 32,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            isCapturingScreen
                                ? const SizedBox()
                                : isHideAllControl
                                ? Positioned(
                                    bottom: 48,
                                    right: 12,
                                    child: onTapWidget(
                                      onTap: () {
                                        setState(() {
                                          isHideAllControl = !isHideAllControl;
                                        });
                                      },
                                      child: Image.asset(
                                        IconConstants.ic_show_compass_map,
                                        width: 32,
                                        height: 32,
                                      ),
                                    ),
                                  )
                                : Positioned.fill(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.zero,
                                          child: Container(
                                            height: optimizedSize(
                                              phone: 40,
                                              zfold: 40,
                                              tablet: 60,
                                              context: context,
                                            ),
                                            width: optimizedSize(
                                              phone: Get.width,
                                              zfold: Get.width / 1.5,
                                              tablet: Get.width / 1.5,
                                              context: context,
                                            ),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  ImageConstants
                                                      .img_bg_mbs_flower,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              border: GradientBoxBorder(
                                                gradient: LinearGradient(
                                                  colors: CommonConstants
                                                      .gradientsBorderSearchVoucher,
                                                ),
                                                width: 0.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: CustomShowCaseWidget(
                                              index: 5,
                                              keySC: five,
                                              title: 'Xhero',
                                              description:
                                                  'extreme_ruler_tutorial_step_5',
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 8),
                                                  SvgPicture.asset(
                                                    IconConstants
                                                        .ic_turn_gradient,
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                  Expanded(
                                                    child: Slider(
                                                      value:
                                                          _rotationForCompass,
                                                      min: 0,
                                                      max: 360,
                                                      divisions: 360,
                                                      inactiveColor: AppColor
                                                          .grayTextBoldColor
                                                          .withAlpha(
                                                            (0.2 * 255).toInt(),
                                                          ),
                                                      thumbColor: AppColor
                                                          .textBrownColor,
                                                      activeColor:
                                                          AppColor.borderYellow,
                                                      label: _rotationForCompass
                                                          .round()
                                                          .toString(),
                                                      secondaryTrackValue: 8,
                                                      secondaryActiveColor:
                                                          AppColor.primaryColor,
                                                      onChanged: (double value) {
                                                        setState(() {
                                                          codeOfDegree = value
                                                              .round()
                                                              .toString();
                                                          _rotationForCompass =
                                                              value;
                                                          _controller.text =
                                                              _rotationForCompass
                                                                  .toStringAsFixed(
                                                                    0,
                                                                  );
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  onTapWidget(
                                                    onTap: () {
                                                      _pickDegree(context);
                                                    },
                                                    child: CustomShowCaseWidget(
                                                      index: 6,
                                                      keySC: six,
                                                      title: 'Xhero',
                                                      description:
                                                          'extreme_ruler_tutorial_step_4',
                                                      child: Container(
                                                        width: 72,
                                                        height: 40,
                                                        margin: EdgeInsets.only(
                                                          right:
                                                              MediaQuery.of(
                                                                    context,
                                                                  ).size.width >
                                                                  500
                                                              ? 8
                                                              : 2,
                                                          top: 2,
                                                          bottom: 2,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: CommonConstants
                                                                .gradientAccountIcons,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),

                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                codeOfDegree ??
                                                                    '0\u00B0',
                                                                maxLines: 1,
                                                                textScaler:
                                                                    const TextScaler.linear(
                                                                      1,
                                                                    ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextAppStyle()
                                                                    .normalTextStyleExtraSmallLight(),
                                                              ),
                                                            ),
                                                            SvgPicture.asset(
                                                              IconConstants
                                                                  .ic_edit_light,
                                                              width: 14,
                                                              height: 14,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          height: optimizedSize(
                                            phone: 40,
                                            zfold: 40,
                                            tablet: 60,
                                            context: context,
                                          ),
                                          padding: EdgeInsets.only(
                                            right: isSamsungZFold(context)
                                                ? 6
                                                : 0,
                                          ),
                                          width: optimizedSize(
                                            phone: Get.width,
                                            zfold: Get.width / 1.5,
                                            tablet: Get.width / 1.5,
                                            context: context,
                                          ),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                ImageConstants
                                                    .img_bg_mbs_flower,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            border: GradientBoxBorder(
                                              gradient: LinearGradient(
                                                colors: CommonConstants
                                                    .gradientsBorderSearchVoucher,
                                              ),
                                              width: 0.5,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: CustomShowCaseWidget(
                                            index: 7,
                                            keySC: seven,
                                            title: 'Xhero',
                                            description:
                                                'extreme_ruler_tutorial_step_6',
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 8),
                                                SvgPicture.asset(
                                                  IconConstants
                                                      .ic_image_refresh_gradient,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                Expanded(
                                                  child: Slider(
                                                    value: _rotationForImage,
                                                    min: 0,
                                                    max: 360,
                                                    divisions: 360,
                                                    inactiveColor: AppColor
                                                        .grayTextBoldColor
                                                        .withAlpha(
                                                          (0.2 * 255).toInt(),
                                                        ),
                                                    thumbColor:
                                                        AppColor.textBrownColor,
                                                    activeColor:
                                                        AppColor.borderYellow,
                                                    label: _rotationForImage
                                                        .round()
                                                        .toString(),
                                                    secondaryTrackValue: 8,
                                                    secondaryActiveColor:
                                                        AppColor.primaryColor,
                                                    onChanged: (double value) {
                                                      printConsole(
                                                        value.toString(),
                                                      );
                                                      setState(() {
                                                        _rotationForImage =
                                                            value;
                                                        rotationForImageValue =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                onTapWidget(
                                                  onTap: () {},
                                                  child: CustomShowCaseWidget(
                                                    index: 8,
                                                    keySC: eight,
                                                    title: 'Xhero',
                                                    description:
                                                        'extreme_ruler_tutorial_step_7',
                                                    child: Container(
                                                      width: 72,
                                                      height: 40,
                                                      margin:
                                                          const EdgeInsets.only(
                                                            right: 2,
                                                            top: 2,
                                                            bottom: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: CommonConstants
                                                              .gradientAccountIcons,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${_rotationForImage.toInt()}\u00B0',
                                                            textScaler:
                                                                const TextScaler.linear(
                                                                  1,
                                                                ),
                                                            style: TextAppStyle()
                                                                .normalTextStyleExtraSmallLight(),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          Transform.rotate(
                                                            angle:
                                                                _rotationForImage *
                                                                3.14159 /
                                                                180, // Convert degrees to radians
                                                            child: Icon(
                                                              isZoomImage
                                                                  ? Icons
                                                                        .hide_image_outlined
                                                                  : Icons
                                                                        .image_outlined,
                                                              color: AppColor
                                                                  .textLightColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ), // Khoảng cách giữa Container và các nút
                                        Container(
                                          width: optimizedSize(
                                            phone: Get.width - 24,
                                            zfold: Get.width / 1.5,
                                            tablet: Get.width / 1.5,
                                            context: context,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 0.5,
                                              color: AppColor.actionTextYellow,
                                            ),
                                            color: AppColor.sandColor,
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [0, 90, 180, 270, 360].map((
                                              angle,
                                            ) {
                                              final bool isSelected =
                                                  (_rotationForImage.toInt() ==
                                                  angle);
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _rotationForImage = angle
                                                        .toDouble();
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                    color: isSelected
                                                        ? AppColor.brownLight
                                                        : AppColor
                                                              .transparentColor,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 4,
                                                      ),
                                                  width:
                                                      ((optimizedSize(
                                                            phone: Get.width,
                                                            zfold:
                                                                Get.width / 1.5,
                                                            tablet:
                                                                Get.width / 1.5,
                                                            context: context,
                                                          )) -
                                                          54) /
                                                      5,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                      ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '$angle\u00B0',
                                                    maxLines: 1,
                                                    textScaler:
                                                        const TextScaler.linear(
                                                          1,
                                                        ),
                                                    style: TextAppStyle()
                                                        .normalTextStyleExtraSmall()
                                                        .copyWith(
                                                          color: isSelected
                                                              ? AppColor
                                                                    .secondaryColor
                                                              : AppColor
                                                                    .primaryColor,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              titleAppbar: capitalForText('extreme_ruler'.tr),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDegree(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      barrierColor: AppColor.blackColor.withAlpha((0.75 * 255).toInt()),
      backgroundColor: AppColor.whiteColor,
      useSafeArea: true,
      builder: (context) {
        var size = MediaQuery.of(context).size;
        return CupertinoTheme(
          data: const CupertinoThemeData(
            primaryColor: Color.fromARGB(97, 241, 240, 240),
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(
                color: Color.fromARGB(255, 241, 240, 240),
                fontSize: 16,
              ),
              pickerTextStyle: TextStyle(
                color: Color.fromARGB(97, 241, 240, 240),
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: size.height * 0.6,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
                border: Border(
                  top: BorderSide(color: AppColor.newPrimaryColor2, width: 6),
                ),
                image: const DecorationImage(
                  image: AssetImage(ImageConstants.img_bg_mbs_flower),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Flexible(
                          child: Text(
                            'pick_dire_coor'.tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextAppStyle().titleStyle().copyWith(
                              color: AppColor.primaryColor,
                            ),
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GradientBorderContainer(
                          padding: const EdgeInsets.all(1),
                          radius: 9,
                          margin: const EdgeInsets.only(left: 24),
                          child: Container(
                            width: getResponsiveWidth(context) - 48,
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(
                                (0.9 * 255).toInt(),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: TextField(
                                controller: _controller,
                                cursorColor: AppColor.secondaryColor,
                                cursorHeight: 16,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                // inputFormatters: [
                                //   DecimalTextInputFormatter(
                                //       decimalDigits: 1),
                                // ],
                                style: TextAppStyle()
                                    .normalTextStyle()
                                    .copyWith(
                                      fontSize: 16,
                                      color: AppColor.secondaryColor,
                                    ),
                                decoration: InputDecoration(
                                  prefixIconConstraints: const BoxConstraints(
                                    maxWidth: 120,
                                    maxHeight: 40,
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8,
                                    ), // Thêm padding bên trái của prefix icon
                                    child: SvgPicture.asset(
                                      IconConstants.ic_satellite_gradient,
                                      width: 28,
                                      height: 28,
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                    maxWidth: 80,
                                    maxHeight: 40,
                                  ),
                                  suffixIcon: onTapWidget(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        var degree = extractNumber(
                                          _controller.text,
                                        );
                                        _updateRotationFromTextField(degree);
                                        codeOfDegree =
                                            '${_controller.text}\u00B0';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.clear_rounded,
                                            size: 20,
                                            color: AppColor.grayTextwhiteColor,
                                          ),
                                          onPressed: () {
                                            _controller.clear();
                                            setState(() {
                                              hasText = false;
                                            });
                                          },
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            border: const GradientBoxBorder(
                                              gradient: LinearGradient(
                                                colors: CommonConstants
                                                    .gradientsLight,
                                              ),
                                              width: 0.5,
                                            ),
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: CommonConstants
                                                  .gradientBrownBtn,
                                            ),
                                          ),
                                          child: ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                              AppColor.borderYellow,
                                              BlendMode.srcATop,
                                            ),
                                            child: SvgPicture.asset(
                                              IconConstants.ic_search_light,
                                              width: 18,
                                              height: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 12,
                                  ),
                                  isDense: true,
                                  hintText: 'enter_your_degree'.tr,
                                  hintStyle: TextAppStyle()
                                      .thinTextStyle()
                                      .copyWith(
                                        fontSize: 16,
                                        color: AppColor.grayTextwhiteColor,
                                      ),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (value) async {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    var degree = extractNumber(
                                      _controller.text,
                                    );
                                    _updateRotationFromTextField(degree);
                                    codeOfDegree = '${_controller.text}\u00B0';
                                  });
                                  Navigator.pop(context);
                                },
                                onChanged: (String v) {
                                  setState(() {
                                    hasText = v
                                        .isNotEmpty; // ✅ nếu bạn cần check trạng thái nhập
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 12),
                      child: Text(
                        'or_pick'.tr,
                        style: TextAppStyle().normalTextStyle(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 32,
                        right: 24,
                        top: 4,
                      ),
                      child: RawScrollbar(
                        thumbColor: AppColor.borderYellow,
                        radius: const Radius.circular(100),
                        thickness: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: GridView.builder(
                            padding: const EdgeInsets.only(bottom: 24),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width > 500
                                      ? 1.65
                                      : 1.25,
                                ),
                            itemCount: CommonConstants.lstDireCoor.length,
                            itemBuilder: (context, index) {
                              final item = CommonConstants.lstDireCoor[index];
                              return GestureDetector(
                                onTap: () {
                                  onItemSelected(item, false);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selectedDireCoor == item
                                        ? AppColor.actionTextYellow
                                        : const Color.fromARGB(
                                            255,
                                            251,
                                            250,
                                            239,
                                          ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: selectedDireCoor == item
                                        ? GradientBoxBorder(
                                            gradient: LinearGradient(
                                              colors: CommonConstants
                                                  .gradientBrownBtn,
                                            ),
                                          )
                                        : const GradientBoxBorder(
                                            gradient: LinearGradient(
                                              colors: CommonConstants.name,
                                            ),
                                          ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.title,
                                        textAlign: TextAlign.center,
                                        style: TextAppStyle().titleStyleLarge(),
                                      ),
                                      Text(
                                        item.titleDirection,
                                        textAlign: TextAlign.center,
                                        style: TextAppStyle()
                                            .normalTextStyleSmall(),
                                      ),
                                      Text(
                                        item.degree,
                                        style: TextAppStyle()
                                            .normalTextStyleExtraLarge(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onItemSelected(DireCoor selectedItem, bool isType) {
    setState(() {
      selectedDireCoor = selectedItem;
      codeOfDegree = selectedItem.degree;
      _controller.text = codeOfDegree ?? '0';
      var degree = extractNumber(_controller.text);
      _updateRotationFromTextField(degree);
    });
    Navigator.pop(context);
  }

  String extractNumber(String text) {
    final regex = RegExp(r'\d+([.,]\d+)?');
    final match = regex.firstMatch(text);
    return match != null ? match.group(0) ?? '' : '';
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalDigits;

  DecimalTextInputFormatter({this.decimalDigits = 1});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Tạo một biểu thức chính quy để kiểm tra định dạng
    final regExp = RegExp(r'^(\d+)?(\.\d{0,$decimalDigits})?$');
    if (regExp.hasMatch(newValue.text)) {
      // Nếu giá trị mới hợp lệ, trả lại giá trị mới
      final newValueString = newValue.text;
      final value = double.tryParse(newValueString);
      if (value != null && value >= 0 && value <= 360) {
        return newValue;
      }
    }
    // Nếu giá trị không hợp lệ, trả lại giá trị cũ
    return oldValue;
  }
}
