import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'dart:math' as math;

import 'package:xhero_windows_app/constants/colors.dart';

class ExtremeByImage extends StatefulWidget {
  final String filePath;
  const ExtremeByImage({super.key, required this.filePath});

  @override
  State<ExtremeByImage> createState() => _ExtremeByImageState();
}

class _ExtremeByImageState extends State<ExtremeByImage> {
  double _rotationForImage = 0; // Bạn có thể chỉnh số độ xoay tại đây
  String? codeOfDegree;
  double _rotationForCompass = 0;
  Color _imageColor = Colors.white;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _captureKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isWide = width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 238, 209, 82),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(
              'Ảnh đã chọn để lập cực',
              colors: const [
                Color.fromARGB(255, 206, 169, 3),
                Color.fromARGB(255, 238, 209, 82),
                Color.fromARGB(255, 224, 160, 22),
                Color.fromARGB(255, 238, 209, 82),
              ],
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
            spaceVertical(8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ).copyWith(bottom: 6, left: 5),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  width: 1,
                  color: const Color.fromARGB(255, 239, 193, 25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      CupertinoIcons.info_circle_fill,
                      color: Color.fromARGB(255, 238, 209, 82),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: GradientText(
                      'Chọn chuột để phóng to/thu nhỏ bản vẽ',
                      colors: const [
                        Color.fromARGB(255, 206, 169, 3),
                        Color.fromARGB(255, 238, 209, 82),
                        Color.fromARGB(255, 224, 160, 22),
                        Color.fromARGB(255, 238, 209, 82),
                      ],
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RepaintBoundary(
        key: _captureKey,
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Transform.rotate(
                  angle:
                      _rotationForImage *
                      3.14159 /
                      180, // Convert degrees to radians
                  child: Image.file(
                    File(widget.filePath),
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Transform.rotate(
                    angle: _rotationForCompass * math.pi / 180,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        _imageColor,
                        BlendMode.srcATop,
                      ),
                      child: Image.asset(
                        'assets/compass_satellite.png',
                        width: isWide ? width * 0.45 : width * 0.6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 0),
                    width: 80,
                    height: 24,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.colorRed,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 1,
                        color: AppColor.textLightColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${_rotationForCompass.toStringAsFixed(1)}\u00B0',
                        style: TextStyle(
                          color: AppColor.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 0.75),
                    child: Image.asset(
                      'assets/fr_line_x_y.png',
                      width: isWide ? width * 0.45 : width * 0.6,
                    ),
                  ),
                  spaceVertical(24.5),
                ],
              ),
            ),

            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: 54,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: isWide ? width * 0.275 : width * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black26,
                        border: Border.all(
                          width: 1,
                          color: Color.fromARGB(255, 238, 209, 82),
                        ),
                      ),
                      child: Row(
                        children: [
                          spaceHorizontal(8),

                          Expanded(
                            child: Slider(
                              value: _rotationForCompass,
                              min: 0,
                              max: 360,
                              divisions: 360,
                              inactiveColor: AppColor.whiteColor.withAlpha(
                                (0.2 * 255).toInt(),
                              ),
                              thumbColor: AppColor.secondaryColor,
                              activeColor: AppColor.borderYellow,
                              label: _rotationForCompass.round().toString(),
                              secondaryTrackValue: 8,
                              secondaryActiveColor: AppColor.primaryColor,
                              onChanged: (double value) {
                                setState(() {
                                  codeOfDegree = value.toString();
                                  _rotationForCompass = value;
                                  _controller.text = _rotationForCompass
                                      .toStringAsFixed(0);
                                });
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // _pickDegree(context);
                            },
                            child: Container(
                              width: 88,
                              height: 40,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),

                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${double.tryParse(codeOfDegree ?? '')?.toStringAsFixed(1) ?? '0.0'}\u00B0',

                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColor.secondaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                                  Icon(
                                    CupertinoIcons.timelapse,
                                    size: 20,
                                    color: AppColor.sandColor,
                                  ),
                                ],
                              ),
                              //     ),
                              //     suffixIconConstraints:
                              //         const BoxConstraints(
                              //             maxWidth: 24),
                              //     border: const OutlineInputBorder(
                              //         borderSide: BorderSide.none),
                              //     contentPadding:
                              //         const EdgeInsets.symmetric(
                              //             horizontal: 8),
                              //   ),
                              //   onSubmitted: (String value) {
                              //     _updateRotationFromTextField(value);
                              //   },
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  spaceVertical(8),
                  Container(
                    height: 54,

                    width: isWide ? width * 0.275 : width * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black26,
                      border: Border.all(
                        width: 1,
                        color: Color.fromARGB(255, 238, 209, 82),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        spaceHorizontal(8),
                        // FCoreImage(
                        //   IconConstants
                        //       .ic_image_refresh_gradient,
                        //   width: 24,
                        //   height: 24,
                        // ),
                        Expanded(
                          child: Slider(
                            value: _rotationForImage,
                            min: 0,
                            max: 360,
                            divisions: 360,
                            inactiveColor: AppColor.whiteColor.withAlpha(
                              (0.2 * 255).toInt(),
                            ),
                            thumbColor: AppColor.secondaryColor,
                            activeColor: AppColor.borderYellow,
                            label: _rotationForImage.round().toString(),
                            secondaryTrackValue: 8,
                            secondaryActiveColor: AppColor.primaryColor,
                            onChanged: (double value) {
                              setState(() {
                                _rotationForImage = value;
                              });
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // setState(() {
                            //   isZoomImage =
                            //       !isZoomImage;
                            // });
                          },
                          child: Container(
                            width: 88,
                            height: 40,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_rotationForImage.toStringAsFixed(1)}\u00B0',
                                  style: TextStyle(
                                    color: AppColor.secondaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                                spaceHorizontal(4),
                                Transform.rotate(
                                  angle:
                                      _rotationForImage *
                                      3.14159 /
                                      180, // Convert degrees to radians
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: AppColor.textLightColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ), // Khoảng cách giữa Container và các nút
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 109, 47, 7),
                        ),
                        color: const Color.fromARGB(255, 247, 230, 196),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [0, 90, 180, 270, 360].map((angle) {
                            final bool isSelected =
                                (_rotationForImage.toInt() == angle);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _rotationForImage = angle.toDouble();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromARGB(
                                    255,
                                    199,
                                    151,
                                    20,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                width:
                                    (MediaQuery.of(context).size.width - 56) /
                                    5,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$angle\u00B0',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  spaceVertical(Platform.isIOS ? 32 : 24),
                  // RangeSlider for rotation
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.symmetric(
                  //           vertical: 0.0),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         'Rotation: ${_getRotationAngle(_sliderValue).toInt()}°',
                  //         style:
                  //             TextStyle(fontSize: 16),
                  //       ),

                  // ),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ).copyWith(bottom: 88),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black26,
                    border: Border.all(
                      width: 1,
                      color: Color.fromARGB(255, 238, 209, 82),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          List<Color> colorsPicker = [
                            Colors.white,
                            Colors.red,
                            Colors.green,
                            Colors.yellowAccent,
                            Colors.blue,
                            Colors.grey,
                            Colors.indigo,
                            Colors.deepOrangeAccent,
                            Colors.tealAccent,
                            Colors.pink,
                            Colors.amber,
                            Colors.deepPurple,
                            Colors.brown,
                            Colors.cyan,
                            Colors.lime,
                            Colors.orange,
                            Colors.purple,
                            Colors.blueGrey,
                            Colors.lightBlue,
                            Colors.lightGreen,
                            Colors.limeAccent,
                            Colors.orangeAccent,
                            Colors.purpleAccent,
                            Colors.redAccent,
                            Colors.teal,
                            Colors.yellow,
                            Colors.black,
                            Colors.blueAccent,
                            Colors.cyanAccent,
                            Colors.deepOrange,
                            Colors.deepPurpleAccent,
                            Colors.greenAccent,
                            Colors.indigoAccent,
                            Colors.lightBlueAccent,
                            Colors.lightGreenAccent,
                            Colors.orangeAccent,
                            Colors.pinkAccent,
                            Colors.purpleAccent,
                            Colors.redAccent,
                            Colors.tealAccent,
                            const Color.fromARGB(255, 172, 100, 41),
                            Colors.amberAccent,
                            const Color.fromARGB(255, 1, 115, 39),
                            Colors.grey.shade800,
                            Colors.grey.shade600,
                            Colors.grey.shade400,
                            Colors.brown.shade900,
                            Colors.brown.shade700,
                            Colors.brown.shade500,
                          ];
                          Color pickerColor = _imageColor;

                          showModalBottomSheet(
                            constraints: BoxConstraints.expand(
                              width: width * 0.8,
                              height: height * 0.5,
                            ),
                            backgroundColor: AppColor.whiteColor,
                            isScrollControlled: true,
                            context: context,
                            builder: (ctx) {
                              return StatefulBuilder(
                                builder: (BuildContext ctx, StateSetter setStateColor) {
                                  return Container(
                                    height: height * 0.4,
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
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                      0,
                                      16,
                                      0,
                                      24,
                                    ),
                                    width: width * 0.8,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(width: 40),
                                            Text(
                                              'Chọn màu la kinh',
                                              style: TextStyle().copyWith(
                                                color: AppColor.primaryColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 24,
                                                ),
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
                                          width: width * 0.8,
                                          margin: const EdgeInsets.only(
                                            top: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.primaryColor
                                                .withAlpha(
                                                  (0.25 * 255).toInt(),
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GridView.builder(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 24,
                                            ),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 12,
                                                  crossAxisSpacing: 8.0,
                                                  mainAxisSpacing: 8.0,
                                                  childAspectRatio: 1.0,
                                                ),
                                            itemCount: colorsPicker.length,
                                            itemBuilder: (context, index) {
                                              final color = colorsPicker[index];
                                              final isSelected =
                                                  pickerColor == color;
                                              return GestureDetector(
                                                onTap: () {
                                                  setStateColor(() {
                                                    pickerColor = color;
                                                    _imageColor = pickerColor;
                                                  });

                                                  setState(() {
                                                    // Cập nhật lại màu chính
                                                    // Lưu ý: `_imageColor` đã được cập nhật từ `StatefulBuilder`
                                                  });
                                                },
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
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
                                                        width: width * 0.8,

                                                        height: height * 0.4,
                                                        decoration:
                                                            BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: color,
                                                            ),
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: AppColor
                                                            .colorGreenDark,
                                                        size: 40,
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
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColor.newPrimaryColor1,
                                AppColor.newPrimaryColor2,
                                AppColor.textYellow,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.color_lens,
                            color: AppColor.primaryColor,
                            size: 28,
                          ),
                        ),
                      ),
                      spaceHorizontal(6),
                      InkWell(
                        onTap: () async {
                          try {
                            RenderRepaintBoundary boundary =
                                _captureKey.currentContext!.findRenderObject()
                                    as RenderRepaintBoundary;
                            var image = await boundary.toImage(pixelRatio: 3.0);
                            ByteData? byteData = await image.toByteData(
                              format: ImageByteFormat.png,
                            );
                            Uint8List pngBytes = byteData!.buffer.asUint8List();

                            final directory =
                                await getApplicationDocumentsDirectory();
                            final filePath =
                                '${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
                            final imageFile = File(filePath);
                            await imageFile.writeAsBytes(pngBytes);

                            /// Bây giờ bạn có thể chia sẻ ảnh:
                            await Share.shareXFiles([
                              XFile(imageFile.path),
                            ], text: 'Lập cực từ Xhero');
                          } catch (e) {
                            print('Chụp ảnh lỗi: $e');
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColor.newPrimaryColor1,
                                AppColor.newPrimaryColor2,
                                AppColor.textYellow,
                              ],
                            ),
                          ),
                          child: Transform.rotate(
  angle: 1 * 3.14159 / 180, // Hoặc: math.pi
  child: Icon(
    CupertinoIcons.share,
    color: AppColor.primaryColor,
    size: 28,
  ),
),

                        ),
                      ),
                         spaceHorizontal(6),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _rotationForImage = 0;
                            _rotationForCompass = 0;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColor.newPrimaryColor1,
                                AppColor.newPrimaryColor2,
                                AppColor.textYellow,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.cached_rounded,
                            color: AppColor.primaryColor,
                            size: 28,
                          ),
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
    );
  }

  Widget spaceVertical(double value) {
    return SizedBox(height: value);
  }

  Widget spaceHorizontal(double value) {
    return SizedBox(width: value);
  }
}
