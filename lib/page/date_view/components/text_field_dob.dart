// ignore_for_file: prefer_is_empty

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../datasource/fetch_api_repository.dart';
import '../../../reponse/calendar/lunar_datetime_response.dart';
import '../../../resource/assets_constant/icon_constants.dart';
import '../../../resource/assets_constant/images_constants.dart';
import '../../../shared/text_style.dart';
import '../../../utils/logic/common_widget.dart';
import '../../../utils/logic/xhero_common_logics.dart';

// ignore: must_be_immutable
class TextFieldDOBTest extends StatefulWidget {
  final TextEditingController yearDobTEC;
  final String type;
  final TextEditingController? monthDobTEC;
  final TextEditingController? dayDobTEC;
  final bool? isGetLunarDate;
  final Function(int) onMonthSelected;
  final FocusNode focusnodeDay;
  final FocusNode focusnodeYear;
  final String selectedMonth;
  bool isClearMonth;
  final VoidCallback onResetComplete;

  TextFieldDOBTest({
    super.key,
    this.dayDobTEC,
    this.monthDobTEC,
    required this.yearDobTEC,
    required this.type,
    this.isGetLunarDate,
    required this.onMonthSelected,
    required this.focusnodeDay,
    required this.focusnodeYear,
    required this.isClearMonth,
    required this.onResetComplete,
    required this.selectedMonth, // Thêm callback vào constructor
  });

  @override
  State<TextFieldDOBTest> createState() => _TextFieldDOBTestState();
}

class _TextFieldDOBTestState extends State<TextFieldDOBTest> {
  bool isShowDobNote = false;
  bool isShowDobNoteSecond = false;
  LunarDatetimeData? lunarDatetimeData;
  LunarDatetimeData? lunarDatetimeDataSecond;
  bool isClearMonth = false;

  bool invalidDayDobTEC = false;
  bool invalidMonthDobTEC = false;
  bool invalidYearDobTEC = false;
  bool getAPIDOB = false;
  final FixedExtentScrollController _controller = FixedExtentScrollController();

  final int minYear = 1900;
  final int maxYear = DateTime.now().year;
  String? errorMessage;
  void _validateYear(
    TextEditingController controller,
    Function(bool) callback,
  ) {
    String value = controller.text;
    bool isValid = true;
    if (value.length == 4) {
      int? year = int.tryParse(value);
      if (year == null || year < minYear || year > maxYear) {
        isValid = false;
      }
    } else {
      isValid = false;
    }
    callback(isValid);
    validateDay();
  }

  void _validateDay(TextEditingController controller, Function(bool) callback) {
    String value = controller.text;
    bool isValid = true;
    if (value.isNotEmpty) {
      if (value.length <= 2) {
        int? day = int.tryParse(value);
        if (day == null || day < 1 || day > 31) {
          isValid = false;
        }
      } else {
        isValid = false;
      }
      callback(isValid);
    }
  }

  void _validateMonth(
    TextEditingController controller,
    Function(bool) callback,
  ) {
    String value = controller.text;
    bool isValid = _isValidMonth(value);
    callback(isValid);
  }

  bool _isValidMonth(String value) {
    if (value.isNotEmpty) {
      int? month = int.tryParse(value);
      return month != null && month > 0 && month <= 12;
    }
    return false;
  }

  String formatWithLeadingZero(String value) {
    int number = int.tryParse(value) ?? 0;
    return number < 10 ? '0$number' : value;
  }

  bool isLeapYear(int year) {
    if (year % 4 != 0) {
      return false;
    } else if (year % 100 != 0) {
      return true;
    } else if (year % 400 != 0) {
      return false;
    } else {
      return true;
    }
  }

  void validateDay() {
    int day = int.tryParse(widget.dayDobTEC?.text ?? '') ?? 0;
    int month = int.tryParse(widget.monthDobTEC?.text ?? '') ?? 0;
    int year = int.tryParse(widget.yearDobTEC.text) ?? 0;

    if (month == 0 || day == 0) return;

    if (month > 12) {
      widget.monthDobTEC?.text = '12';
      month = 12;
    }

    List<int> monthsWith30Days = [4, 6, 9, 11];
    List<int> monthsWith31Days = [1, 3, 5, 7, 8, 10, 12];

    if (monthsWith30Days.contains(month) && day > 30) {
      widget.dayDobTEC?.text = '30';
    } else if (monthsWith31Days.contains(month) && day > 31) {
      widget.dayDobTEC?.text = '31';
    } else if (month == 2 && (widget.yearDobTEC.text.length == 4)) {
      if (isLeapYear(year) && day > 29) {
        widget.dayDobTEC?.text = '29';
      } else if (!isLeapYear(year) && day > 28) {
        widget.dayDobTEC?.text = '28';
      }
    } else if (month == 2 && day > 29) {
      if (isLeapYear(year) && day > 29) {
        widget.dayDobTEC?.text = '29';
      } else if (!isLeapYear(year) && day > 28) {
        widget.dayDobTEC?.text = '28';
      }
    }
    if (widget.yearDobTEC.text.length == 4) {
      getLunarDatetime(buildDOBString(), '12:00:00');
    }
  }

  int currentYear = int.parse(DateFormat('yyyy').format(DateTime.now()));
  String buildDOBString() {
    String day = widget.dayDobTEC?.text.isEmpty ?? true
        ? '16'
        : formatWithLeadingZero(widget.dayDobTEC?.text ?? '');
    String month = widget.monthDobTEC?.text.isEmpty ?? true
        ? '05'
        : formatWithLeadingZero(widget.monthDobTEC?.text ?? '');
    String year = widget.yearDobTEC.text.isEmpty
        ? currentYear.toString()
        : widget.yearDobTEC.text;

    return '$day/$month/$year';
  }

  List<String> months = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  void updateMonth(int monthIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        widget.monthDobTEC?.text = (monthIndex + 1).toString().padLeft(2, '0');
        validateDay();
      });
    });
  }

  String selectedMonth = '';
  int selectedIndex = -1;
  int _initialIndex = 1;

  @override
  void didUpdateWidget(covariant TextFieldDOBTest oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kiểm tra nếu `widget.isClearMonth` đã thay đổi thành true
    if (widget.isClearMonth && !oldWidget.isClearMonth) {
      _resetValues();
    }
  }

  void _resetValues() {
    setState(() {
      selectedMonth = '';
      selectedIndex = -1;
      _initialIndex = 1;
    });
    // Gọi `onResetComplete` sau khi build hiện tại hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onResetComplete();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.monthDobTEC!.text.isNotEmpty) {
      selectedMonth = widget.monthDobTEC!.text;
      selectedIndex = _initialIndex = int.parse(selectedMonth) - 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onMonthSelected(selectedIndex + 1);
      });
    }
    isClearMonth = widget.isClearMonth;

    _initialIndex = selectedIndex == -1 ? 1 : selectedIndex;

    // Unfocus tất cả các TextField khi màn hình được khởi tạo lại
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpToItem(2);
      }
    });

    // int month = 5;
    // widget.monthDobTEC?.text = month.toString().padLeft(2, '0');
    if (widget.monthDobTEC!.text.isNotEmpty) {
      String dob = buildDOBString();
      if (widget.yearDobTEC.text.isNotEmpty) {
        getLunarDatetime(dob, '12:00:00');
      }
    }

    widget.dayDobTEC?.addListener(
      () => _validateDay(widget.dayDobTEC!, (isValid) {
        if (mounted) {
          setState(() {
            invalidDayDobTEC = !isValid;
            getAPIDOB = isValid && !invalidMonthDobTEC && !invalidYearDobTEC;
          });
        }
      }),
    );

    widget.monthDobTEC?.addListener(
      () => _validateMonth(widget.monthDobTEC!, (isValid) {
        if (mounted) {
          setState(() {
            invalidMonthDobTEC = !isValid;
            getAPIDOB = isValid && !invalidDayDobTEC && !invalidYearDobTEC;
          });
        }
      }),
    );

    widget.yearDobTEC.addListener(
      () => _validateYear(widget.yearDobTEC, (isValid) {
        if (mounted) {
          setState(() {
            invalidYearDobTEC = !isValid;
            getAPIDOB = isValid && !invalidDayDobTEC && !invalidMonthDobTEC;
          });
        }
      }),
    );
  }

  @override
  void dispose() {
    // Hủy các listener khi widget bị hủy
    widget.dayDobTEC?.removeListener(() {});
    widget.monthDobTEC?.removeListener(() {});
    widget.yearDobTEC.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTextField(
              focusNode: widget.focusnodeDay,
              hintText: 'day'.tr,
              controller: widget.dayDobTEC,
              onChanged: (value) {
                validateDay();
                if (value.length <= 2) {
                  String dob = buildDOBString();
                  if (widget.yearDobTEC.text.isNotEmpty) {
                    getLunarDatetime(dob, '12:00:00');
                  }
                }
                if (value.isEmpty) {
                  invalidDayDobTEC = false;
                }
                // _hideKeyboard();  // Ẩn bàn phím khi người dùng nhập xong
              },
              maxLength: 2,
              invalidField: invalidDayDobTEC,
            ),
            const SizedBox(width: 4),
            // _buildTextField(
            //   focusNode: FocusNode(),
            //   hintText: 'month'.tr,
            //   controller: widget.monthDobTEC,
            //   onChanged: (value) {
            //     validateDay();
            //     if (value.length <= 2 && getAPIDOB) {
            //           String dob = buildDOBString();
            //           getLunarDatetime(
            //               dob,
            //               '12:00:00');
            //         }
            //         if(value.isEmpty) {
            //           invalidMonthDobTEC = false;
            //         }
            //   },
            //   maxLength: 2,
            //   invalidField: invalidMonthDobTEC
            // ),
            _choiceMonth(),
            const SizedBox(width: 4),
            _buildTextField(
              focusNode: widget.focusnodeYear,
              hintText: '${'year'.tr}*',
              controller: widget.yearDobTEC,
              onChanged: (value) {
                if (value.length == 4) {
                  String dob = buildDOBString();
                  getLunarDatetime(dob, '12:00:00');
                }
              },
              maxLength: 4,
              invalidField: invalidYearDobTEC,
            ),
          ],
        ),
        Text(
          'no_need_to_fill_day_month'.tr,
          style: TextAppStyle().thinTextStyleExtraSmallLight(),
        ),
        widget.dayDobTEC?.text.length == 0
            ? const SizedBox()
            : Visibility(
                visible: invalidDayDobTEC,
                child: RichText(
                  text: TextSpan(
                    text: 'day_dob_note'.tr,
                    style: TextAppStyle().normalTextStyleSmall().copyWith(
                      color: AppColor.colorRedBold,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${widget.dayDobTEC?.text ?? ''}',
                        style: TextAppStyle().normalTextStyleSmall().copyWith(
                          color: AppColor.colorRedBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        // widget.monthDobTEC?.text.length == 0
        //     ? SizedBox()
        //     : Visibility(
        //         visible: invalidMonthDobTEC,
        //         child: Text(
        //           'Không có tháng ${widget.monthDobTEC?.text}'.tr,
        //           style: TextAppStyle()
        //               .normalTextStyleSmall()
        //               .copyWith(color: AppColor.colorRedBold),
        //         )),
        Visibility(
          visible: invalidYearDobTEC,
          child: Text(
            'year_dob_note'.tr,
            style: TextAppStyle().normalTextStyleSmall().copyWith(
              color: AppColor.colorRedBold,
            ),
          ),
        ),
        widget.isGetLunarDate ?? false
            ? Visibility(
                visible:
                    isShowDobNote == true &&
                    !invalidYearDobTEC &&
                    widget.yearDobTEC.text.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          margin: const EdgeInsets.only(top: 8),
                          color: AppColor.secondaryColor.withAlpha(
                            (0.25 * 255).toInt(),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      Text(
                                        '${'lunar'.tr}: ',
                                        style: TextAppStyle()
                                            .normalTextStyleExtraSmallLight(),
                                      ),
                                      Text(
                                        '${(lunarDatetimeData?.namCan ?? '').tr} ${(lunarDatetimeData?.namChi ?? '').tr}',
                                        style: TextAppStyle()
                                            .titleStyleSmall()
                                            .copyWith(
                                              color: AppColor.newPrimaryColor2,
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 1,
                                          left: 6,
                                        ),
                                        child: Image.asset(
                                          getZodiacImage(
                                            getZodiacIndex(
                                              lunarDatetimeData?.namChi ?? '',
                                            ),
                                          ),
                                          fit: BoxFit.contain,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: 4,
                              height: 32,
                              color: AppColor.secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _choiceMonth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _showMonthPicker,
          child: Container(
            width: (Get.width - 48 - 24 - 10) / 3,
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.9 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: AppColor.secondaryColor),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isClearMonth
                        ? 'month'.tr
                        : (selectedMonth.isNotEmpty
                              ? selectedMonth.tr
                              : 'month'.tr),
                    style: widget.isClearMonth
                        ? TextAppStyle().hintTextGrey().copyWith(fontSize: 14)
                        : selectedMonth.isNotEmpty
                        ? TextAppStyle().normalTextStyleLight()
                        : TextAppStyle().hintTextGrey().copyWith(fontSize: 14),
                  ),
                  SvgPicture.asset(
                    IconConstants.ic_arrow_down_gradient,
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hintText,
    required TextEditingController? controller,
    required Function(String) onChanged,
    required int maxLength,
    required bool invalidField,
    required FocusNode focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: (Get.width - 48 - 24 - 10) / 3,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha((0.9 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: invalidField ? AppColor.colorRed : AppColor.secondaryColor,
            ),
          ),
          child: Center(
            child: TextField(
              autofocus: false,
              focusNode: focusNode,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(maxLength),
              ],
              controller: controller,
              cursorColor: AppColor.secondaryColor,
              cursorHeight: 24,
              keyboardType: TextInputType.number,
              style: TextAppStyle().normalTextStyleLight(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
                isDense: true,
                hintText: hintText,
                hintStyle: TextAppStyle().hintTextGrey().copyWith(fontSize: 14),
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getLunarDatetime(String date, String time) async {
    isShowDobNote = false;
    final url = Uri.parse(
      'https://apis-dev.xheroapp.com/calendars/lunar-datetime?date=$date&time=$time',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Dùng fromJson từ model
        final lunarDateResponse = LunarDatetimeResponse.fromJson(jsonResponse);
        printConsole('Parsed JSON: $jsonResponse');
        EasyLoading.dismiss();
        setState(() {
          lunarDatetimeData = lunarDateResponse.data;
          isShowDobNote = true;
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

  void _showMonthPicker() async {
    widget.focusnodeDay.unfocus();
    widget.focusnodeYear.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_controller.hasClients) {
            _controller.jumpToItem(_initialIndex);
          }
        });
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Container(
            height: Get.height * 0.3,
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(color: AppColor.actionTextYellow, width: 6),
              ),
              image: const DecorationImage(
                image: AssetImage(ImageConstants.img_bg_mbs_flower),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          capitalForText('choice_month'.tr),
                          style: TextAppStyle().titleStyleLight().copyWith(
                            color: Colors.black,
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
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withAlpha(
                      (0.25 * 255).toInt(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListWheelScrollView(
                    controller: _controller,
                    magnification: 3,
                    itemExtent: 60.0, // Chiều cao của mỗi item
                    diameterRatio: 1.25, // Tăng độ cong của danh sách
                    perspective: 0.003, // Hiệu ứng 3D nhẹ
                    physics:
                        const FixedExtentScrollPhysics(), // Cố định kích thước của mỗi item
                    clipBehavior: Clip.none,

                    children: List.generate(
                      months.length,
                      (index) => onTapWidget(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            _initialIndex = selectedIndex;

                            String month = '';
                            if (index < 9) {
                              month = '0${(index + 1)}';
                            } else {
                              month = (index + 1).toString();
                            }
                            if (widget.isClearMonth) {
                              selectedMonth = '';
                            }
                            selectedMonth = month;
                            if (widget.type == 'dob') {
                              // AppDataGlobal.monthDobIsSelected = true;
                            } else if (widget.type == 'wife') {
                              // AppDataGlobal.monthWifeIsSelected = true;
                            } else if (widget.type == 'borrow') {
                              // AppDataGlobal.monthBorrowIsSelected = true;
                            }
                          });

                          updateMonth(selectedIndex);
                          widget.onMonthSelected(selectedIndex + 1);
                          String dob = buildDOBString();
                          Navigator.pop(context);
                          if (widget.yearDobTEC.text.isNotEmpty) {
                            int year =
                                int.tryParse(widget.yearDobTEC.text) ??
                                currentYear;
                            int month =
                                selectedIndex + 1; // Không cần .text ở đây
                            int day =
                                int.tryParse(widget.dayDobTEC!.text) ?? 16;

                            // Kiểm tra năm nhuận và tháng 2
                            if (isLeapYear(year) && month == 2 && day > 29)
                              return;
                            if (!isLeapYear(year) && month == 2 && day > 28)
                              return;

                            // Gọi API nếu hợp lệ
                            getLunarDatetime(dob, '12:00:00');
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          alignment: Alignment.center,
                          margin: selectedIndex == index
                              ? const EdgeInsets.symmetric(horizontal: 32)
                              : const EdgeInsets.symmetric(horizontal: 48),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: selectedIndex == index
                                ? Border.all(
                                    width: 2,
                                    color: AppColor.borderYellow,
                                  )
                                : Border.all(
                                    width: 1,
                                    color: AppColor.grayTextwhiteColor
                                        .withAlpha((0.25 * 255).toInt()),
                                  ),
                            gradient: selectedIndex == index
                                ? LinearGradient(
                                    colors: [
                                      AppColor.blackColor.withAlpha(
                                        (0.9 * 255).toInt(),
                                      ),
                                      AppColor.blackColor.withAlpha(
                                        (0.9 * 255).toInt(),
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.grey.withAlpha(
                                        (0.3 * 255).toInt(),
                                      ),
                                      Colors.grey.withAlpha(
                                        (0.3 * 255).toInt(),
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: selectedIndex == index
                                ? [
                                    BoxShadow(
                                      color: AppColor.textGrey.withAlpha(
                                        (0.5 * 255).toInt(),
                                      ),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                      offset: const Offset(
                                        3,
                                        3,
                                      ), // Đổ bóng tạo hiệu ứng 3D
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            months[index].tr,
                            style: TextAppStyle()
                                .normalTextStyleLarge()
                                .copyWith(
                                  color: selectedIndex == index
                                      ? AppColor.actionTextYellow
                                      : AppColor.grayTextBoldColor,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      // Cuộn tới vị trí sau khi modal đã hiển thị
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients) {
          _controller.jumpToItem(_initialIndex);
        }
      });
    });
  }
}
