// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:http/http.dart' as http;
import '../../../resource/assets_constant/icon_constants.dart';
import '../../../resource/assets_constant/images_constants.dart';
import '../../constants/colors.dart';
import '../../constants/common.dart';
import '../../setup_url/url.dart';
import '../../shared/multi_appear_widgets/body_with_bg_light.dart';
import '../../shared/multi_appear_widgets/gradient_border_container.dart';
import '../../shared/text_style.dart';
import '../../utils/logic/common_widget.dart';
import '../../utils/logic/xhero_common_logics.dart';
import 'model/location_model.dart';

class SeachLocationScreen extends StatefulWidget {
  const SeachLocationScreen({super.key});

  @override
  State<SeachLocationScreen> createState() => _SeachLocationScreenState();
}

class _SeachLocationScreenState extends State<SeachLocationScreen> {
  TextEditingController searchTEC = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  String _lastText = '';
  @override
  void initState() {
    super.initState();
    _fetchLocationAPI(
      query: '60 Đ. Trường Sơn, Phường 2, Tân Bình, Hồ Chí Minh, Vietnam',
    );
    searchTEC.addListener(() {
      _onTextChanged(searchTEC.text);
      setState(() {
        hasText = searchTEC.text.isNotEmpty;
      });
    });
  }

  Future<void> _fetchLocationAPI({required String query}) async {
    String encodedString = Uri.encodeComponent(query);
    await EasyLoading.show(maskType: EasyLoadingMaskType.black);

    final String url = '$mainUrl/services/locations?text=$encodedString';
    final response = await http.get(
      Uri.parse(url),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final Map<String, dynamic> responseData = json.decode(response.body);
      printConsole('ascsacsac: $responseData');
      final bool status = responseData['status'];
      final Map<String, dynamic> data = responseData['data'];
      printConsole(url);
      if (status) {
        EasyLoading.dismiss();
        final double lat = data['lat'];
        final double lng = data['lng'];
        printConsole('$lat, $lng');
        Navigator.pop(context, LocationModel(query, lat, lng));
      } else {
        EasyLoading.dismiss();
        printConsole('Error: Status is false');
      }
    } else {
      EasyLoading.dismiss();

      printConsole('Failed to load data');
    }
  }

  bool isFirstLoad = true;
  bool hasText = true;
  bool isPlusCode(String input) {
    // Regex pattern to match Plus Code format more precisely
    final RegExp plusCodePattern = RegExp(r'^[A-Z0-9]+\+[A-Z0-9]+$');
    printConsole(plusCodePattern.hasMatch(input.trim()).toString());

    return plusCodePattern.hasMatch(input.trim());
  }

  List<String> suggestions = [];
  bool isLoading = false;
  Future<void> getSuggestions(String input) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<String> result = await fetchAddressSuggestions(input);
      setState(() {
        suggestions = result;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      printConsole("Error: $error");
    }
  }

  @override
  void dispose() {
    searchTEC.removeListener(() {
      _onTextChanged(searchTEC.text);
    });
    searchTEC.dispose();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    super.dispose();
  }

  void _onTextChanged(String value) {
    // Hủy timer trước đó nếu có
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (isFirstLoad) {
      isFirstLoad = false;
      return;
    }

    // Cập nhật trạng thái là đang tải
    setState(() {
      isLoading = true;
    });

    // So sánh văn bản hiện tại với văn bản trước đó để xác định việc dán
    if (value.length > _lastText.length) {
      // Giả định rằng việc dán sẽ làm cho văn bản dài hơn
      // Bạn có thể muốn thêm logic kiểm tra khác nếu cần
      printConsole('Text pasted: $value');
      // Đặt _lastText thành giá trị hiện tại nếu dán
      _lastText = value;
      setState(() {
        isLoading = false;
      });
      return; // Không gọi API getSuggestions nếu là dán văn bản
    }

    _debounce = Timer(const Duration(seconds: 1), () async {
      if (value.isNotEmpty) {
        printConsole('Call API now');
        await getSuggestions(value);
      } else {
        setState(() {
          suggestions = [];
          isLoading = false;
        });
      }
      _lastText = value; // Cập nhật văn bản trước đó sau khi xử lý
    });
  }

  Future<void> handleSearch(BuildContext context, String input) async {
    FocusScope.of(context).unfocus();
    try {
      if (_isCoordinates(input)) {
        // Xử lý nếu là tọa độ
        List<String> coords = input.split(',');
        double latitude = double.parse(coords[0].trim());
        double longitude = double.parse(coords[1].trim());
        Navigator.pop(
          context,
          LocationModel(
            "${'search_with_coor'.tr} ($latitude,$longitude)",
            latitude,
            longitude,
          ),
        );
      } else {
        try {
          _fetchLocationAPI(query: input);
        } catch (e) {
          printConsole('enter_the_right_place'.tr);
        }
        // Xử lý nếu là địa chỉ
      }
    } catch (ignore) {
      try {} catch (error) {
        printConsole(error.toString());
      }
    }
  }

  bool _isCoordinates(String input) {
    final regex = RegExp(
      r'^\s*[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)\s*,\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)\s*$',
    );
    return regex.hasMatch(input);
  }

  Future<List<String>> fetchAddressSuggestions(String input) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:vn&key=',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      printConsole('Dia chi: $data');
      List<String> suggestions = [];
      for (var prediction in data['predictions']) {
        suggestions.add(prediction['description']);
      }
      return suggestions;
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BodyWithBackgroundLight(
        background: 'assets/background.png',
        child: Container(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 4),

              Row(
                children: [
                  onTapWidget(
                    onTap: () {
                      Get.back();
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 0,
                        right: 8,
                        bottom: 0,
                        top: 0,
                      ),
                      child: SvgPicture.asset(
                        IconConstants.ic_arrow_back_auth,
                        width: 54,
                        height: 40,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GradientBorderContainer(
                      lstColor: CommonConstants.button,
                      padding: const EdgeInsets.all(1),
                      radius: 9,
                      margin: EdgeInsets.zero,
                      child: Container(
                        width: Get.width - 48,
                        height: 39,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha((0.9 * 255).toInt()),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          controller: searchTEC,
                          cursorColor: AppColor.secondaryColor,
                          cursorHeight: 16,
                          keyboardType: TextInputType.text,
                          style: TextAppStyle().normalTextStyleLight().copyWith(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            suffixIconConstraints: const BoxConstraints(
                              maxWidth: 80,
                              maxHeight: 40,
                            ),
                            suffixIcon: onTapWidget(
                              onTap: () async {
                                handleSearch(context, searchTEC.text);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  hasText
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear_rounded,
                                            size: 20,
                                            color: AppColor.grayTextwhiteColor,
                                          ),
                                          onPressed: () {
                                            searchTEC.clear();
                                            setState(() {
                                              hasText = false;
                                            });
                                          },
                                        )
                                      : const SizedBox(),
                                  if (hasText)
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: const GradientBoxBorder(
                                          gradient: LinearGradient(
                                            colors:
                                                CommonConstants.gradientsLight,
                                          ),
                                          width: 0.5,
                                        ),
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors:
                                              CommonConstants.gradientBrownBtn,
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
                              vertical: 10,
                              horizontal: 0,
                            ),
                            isDense: true,
                            hintText:
                                '${'type_to_search'.tr} ${'location'.tr.toLowerCase()}',
                            hintStyle: TextAppStyle().thinTextStyle().copyWith(
                              fontSize: 14,
                              color: AppColor.grayTextwhiteColor,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (String v) {
                            if (v.isNotEmpty) {
                              printConsole("input: $v");
                              _onTextChanged(v);
                            } else {
                              setState(() {
                                suggestions = [];
                                printConsole("input s: $suggestions");
                              });
                            }
                          },
                          onSubmitted: (value) async {
                            handleSearch(context, searchTEC.text);
                            // handleSearch(context, searchTEC.text);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (isLoading && suggestions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: loadingLogoState(),
                        ),
                      suggestions.isEmpty
                          ? const SizedBox()
                          : GradientBorderContainer(
                              margin: const EdgeInsets.only(left: 0, top: 8),
                              padding: const EdgeInsets.all(1),
                              radius: 9,
                              child: Container(
                                padding: EdgeInsets.zero,
                                height: Get.width / 1.25,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      ImageConstants.img_bg_calendar,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: isLoading
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'icons/ic_direction_map.png',
                                              width: 60,
                                              height: 60,
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              width:
                                                  100, // Thay đổi chiều rộng theo nhu cầu của bạn
                                              height:
                                                  4, // Đặt chiều cao của thanh tiến trình
                                              child: SizedBox(
                                                width:
                                                    100, // Thay đổi chiều rộng theo nhu cầu của bạn
                                                height:
                                                    8, // Đặt chiều cao của thanh tiến trình
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                          colors: [
                                                            Color(
                                                              0xFF4285F4,
                                                            ), // Xanh dương
                                                            Color(
                                                              0xFFEA4335,
                                                            ), // Đỏ
                                                            Color(
                                                              0xFFF7A800,
                                                            ), // Vàng
                                                            Color(
                                                              0xFF34A853,
                                                            ), // Xanh lá cây
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                          stops: [
                                                            0.0,
                                                            0.33,
                                                            0.66,
                                                            1.0,
                                                          ],
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                  ),
                                                  child: LinearProgressIndicator(
                                                    color:
                                                        AppColor.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                    value:
                                                        null, // Hoặc giá trị tiến trình của bạn nếu cần
                                                    backgroundColor: Colors
                                                        .transparent, // Màu nền trong suốt
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'loading'.tr,
                                              style: TextAppStyle()
                                                  .thinTextStyleExtraSmall(),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 12),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: Text(
                                              'suggestion_location'.tr,
                                              style: TextAppStyle()
                                                  .semiBoldTextStyle(),
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            margin: const EdgeInsets.only(
                                              top: 12,
                                              bottom: 0,
                                            ),
                                            width: getResponsiveWidth(context),
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: CommonConstants.name,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: RawScrollbar(
                                              thumbColor: AppColor.borderYellow,
                                              radius: const Radius.circular(
                                                100,
                                              ),
                                              controller: _scrollController,
                                              thickness: 4,
                                              child: SingleChildScrollView(
                                                controller:
                                                    _scrollController, // Điều khiển cuộn nội dung
                                                child: Column(
                                                  children: List.generate(
                                                    suggestions.length,
                                                    (index) => Column(
                                                      children: [
                                                        onTapWidget(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  12.0,
                                                                ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  IconConstants
                                                                      .ic_place_gradient,
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    suggestions[index],
                                                                    style: TextAppStyle()
                                                                        .normalTextStyle(),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Icon(
                                                                  CupertinoIcons
                                                                      .arrow_up_right_diamond_fill,
                                                                  color: AppColor
                                                                      .textHyperLink,
                                                                  size: 24,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () async {
                                                            try {
                                                              _fetchLocationAPI(
                                                                query:
                                                                    suggestions[index],
                                                              );
                                                            } catch (error) {
                                                              printConsole(
                                                                "$error",
                                                              );
                                                            }
                                                          },
                                                        ),
                                                        index + 1 >=
                                                                suggestions
                                                                    .length
                                                            ? const SizedBox()
                                                            : Divider(
                                                                height: 0.25,
                                                                thickness: 0.25,
                                                                color: AppColor
                                                                    .borderYellow,
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                      const SizedBox(height: 12),
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 0, top: 0),
                              height: 80,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: const GradientBoxBorder(
                                  gradient: LinearGradient(
                                    colors: CommonConstants.name,
                                  ),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                    ImageConstants.img_bg_calendar,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        IconConstants.ic_place_gradient,
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'enter_specific_address_to_search'.tr,
                                        style: TextAppStyle()
                                            .normalTextStyleSmall()
                                            .copyWith(
                                              fontStyle: FontStyle.normal,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'example_address_format'.tr,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextAppStyle()
                                        .thinTextStyleExtraSmall()
                                        .copyWith(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                  ),
                                  width: 8,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: CommonConstants.name,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({super.key});

  @override
  _SearchHistoryScreenState createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  List<LocationModel> searchHistory = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search History')),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: searchHistory.length,
        itemBuilder: (context, index) {
          final location = searchHistory[index];
          return ListTile(
            title: Text(location.name),
            subtitle: Text('Lat: ${location.lat}, Lng: ${location.long}'),
          );
        },
      ),
    );
  }
}
