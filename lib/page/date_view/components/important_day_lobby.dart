// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../datasource/fetch_api_repository.dart';
import '../../../reponse/calendar/important_date_response.dart';
import '../../../resource/assets_constant/icon_constants.dart';
import '../../../resource/assets_constant/images_constants.dart';
import '../../../shared/text_style.dart';
import '../../../utils/logic/common_widget.dart';
import '../../../utils/logic/xhero_common_logics.dart';
import 'form_important_day.dart';

class CheckingTheDayScreen extends StatefulWidget {
  final String id;
  final bool isFromDeeplink;
  const CheckingTheDayScreen({
    super.key,
    required this.id,
    this.isFromDeeplink = false,
  });

  @override
  State<CheckingTheDayScreen> createState() => _CheckingTheDayScreenState();
}

class _CheckingTheDayScreenState extends State<CheckingTheDayScreen> {
  RxList<ImportantData?> lstImpDates = RxList<ImportantData?>([]);
  bool isLoaded = false;
  List<String> lstBackground = [
    ImageConstants.img_bg_worship_procedures,
    ImageConstants.img_bg_events_year,
    ImageConstants.img_bg_life_cycle,
    ImageConstants.img_bg_worship_ancestors,
    ImageConstants.img_bg_home_pray,
  ];
  List<String> assignSequentialBackgrounds(int count) {
    List<String> result = [];
    int backgroundIndex = 0;

    for (int i = 0; i < count; i++) {
      String nextBackground = lstBackground[backgroundIndex];

      // Thêm background vào danh sách kết quả
      result.add(nextBackground);

      // Tăng chỉ số để lấy background tiếp theo
      backgroundIndex = (backgroundIndex + 1) % lstBackground.length;

      // Đảm bảo rằng hai phần tử liền kề không trùng nhau
      if (i > 0 && result[i] == result[i - 1]) {
        backgroundIndex = (backgroundIndex + 1) % lstBackground.length;
        result[i] = lstBackground[backgroundIndex];
      }
    }

    return result;
  }

  Future<void> getImportantDate() async {
    await EasyLoading.show(maskType: EasyLoadingMaskType.black);
    final url = Uri.parse(
      'https://apis-dev.xheroapp.com/categories/${widget.id}?skip=0&limit=9',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Dùng fromJson từ model
        final dateImportantResponse = ImportantDateResponse.fromJson(
          jsonResponse,
        );
        printConsole('Parsed JSON: $jsonResponse');
        EasyLoading.dismiss();
        lstImpDates.value = dateImportantResponse.data ?? [];
        setState(() {
          isLoaded = true;
        });
      } catch (e) {
        printConsole('JSON decode error: $e');
        EasyLoading.dismiss();
      }
    } else {
      printConsole('Lỗi API: ${response.statusCode}');
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    getImportantDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: !widget.isFromDeeplink,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          printConsole("⚠️ Back gesture or pop action blocked");
        } else {
          printConsole("✅ Back allowed with result: $result");
        }
      },
      child: frameCommonWidget(
        background: "background.png",
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 112 + 20),
              Column(
                children: List.generate(lstImpDates.length, (index) {
                  List<String> assignedBackgrounds =
                      assignSequentialBackgrounds(lstImpDates.length);
                  return onTapWidget(
                    onTap: () {
                      Get.to(
                        () => FormImportantDayScreen(
                          importantData: lstImpDates[index]!,
                        ),
                      );
                    },
                    child: Container(
                      width: getResponsiveWidth(context) - 48,
                      height: maxWidth > 500 ? 92 : 88,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(assignedBackgrounds[index]),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                capitalForText(
                                  lstImpDates[index]?.name ?? '',
                                ).toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextAppStyle().superStyle(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              lstImpDates[index]?.descriptions
                                      ?.map((desc) {
                                        // Safely handle null `name` for each description
                                        return capitalForText(desc.name ?? '');
                                      })
                                      .join(', ') ??
                                  '', // Default to empty string if descriptions is null
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextAppStyle().thinTextStyleExtraSmall(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
        titleAppbar: capitalForText('check_date_title'.tr),
      ),
    );
  }
}
