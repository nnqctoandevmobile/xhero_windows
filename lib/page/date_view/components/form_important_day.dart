// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:xhero_windows_app/constants/colors.dart';

import '../../../constants/common.dart';
import '../../../datasource/fetch_api_repository.dart';
import '../../../reponse/calendar/important_date_response.dart';
import '../../../reponse/calendar/lunar_datetime_response.dart';
import '../../../resource/assets_constant/btn_constant.dart';
import '../../../resource/assets_constant/frames_constant.dart';
import '../../../resource/assets_constant/icon_constants.dart';
import '../../../resource/assets_constant/images_constants.dart';
import '../../../setup_url/url.dart';
import '../../../shared/multi_appear_widgets/custom_textfield_dark.dart';
import '../../../shared/multi_appear_widgets/gradient_border_container.dart';
import '../../../shared/multi_appear_widgets/popup_error_state.dart';
import '../../../shared/text_style.dart';
import '../../../utils/logic/common_widget.dart';
import '../../../utils/logic/xhero_common_logics.dart';
import 'logic_fnc.dart';
import 'result_important_day.dart';
import 'text_field_dob.dart';

class FormImportantDayScreen extends StatefulWidget {
  final ImportantData importantData;
  final XheroFetchApiRespository uiRepository;
  const FormImportantDayScreen({
    super.key,
    required this.importantData,
    required this.uiRepository,
  });

  @override
  State<FormImportantDayScreen> createState() => _FormImportantDayScreenState();
}

class _FormImportantDayScreenState extends State<FormImportantDayScreen> {
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  //textEditControllers
  TextEditingController nameTEC = TextEditingController();
  TextEditingController yearDobTEC = TextEditingController();
  TextEditingController monthDobTEC = TextEditingController();
  TextEditingController dayDobTEC = TextEditingController();
  TextEditingController yearDeathTEC = TextEditingController();
  TextEditingController yearBorrowTEC = TextEditingController();
  TextEditingController monthBorrowTEC = TextEditingController();
  TextEditingController dayBorrowTEC = TextEditingController();
  TextEditingController yearWifeTEC = TextEditingController();
  TextEditingController monthWifeTEC = TextEditingController();
  TextEditingController dayWifeTEC = TextEditingController();
  TextEditingController degreeTEC = TextEditingController();
  TextEditingController nameWifeTEC = TextEditingController();
  int initialIndex = 1;
  int selectedIndex = -1;
  String selectedWork = '';
  String selectedMonth = '';
  bool isClearMonth = false;
  bool showClearButtonFullName = false;
  void clearMonthData() {
    setState(() {
      isClearMonth = false;
    });
  }

  void handleMonthWifeDOBSelected(int month) {
    setState(() {
      monthWifeTEC.text = month.toString();
      if (yearWifeTEC.text.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 200), () {
          getLunarDatetimeSecond(buildWifeDOBString(), '12:00:00');
          // getLunarDatetimeSecond(buildBorrowDOBString(), '12:00:00');
        });
      }
    });
  }

  void handleMonthSelected(int month) {
    setState(() {
      monthDobTEC.text = month.toString();
      if (yearDobTEC.text.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 200), () {
          printConsole("This message is shown after 2 seconds");
          getLunarDatetime(buildDOBString(), '12:00:00');
        });
      }
    });
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

  void handleMonthBorrowDOBSelected(int month) {
    setState(() {
      monthBorrowTEC.text = month.toString();
      if (yearBorrowTEC.text.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 200), () {
          // getLunarDatetimeSecond(buildWifeDOBString(), '12:00:00');
          getLunarDatetimeSecond(buildBorrowDOBString(), '12:00:00');
        });
      }
    });
  }

  String formatWithLeadingZero(String value) {
    int number = int.tryParse(value) ?? 0;
    return number < 10 ? '0$number' : value;
  }

  int currentYear = int.parse(DateFormat('yyyy').format(DateTime.now()));

  String buildDOBString() {
    // Lấy giá trị ngày và tháng từ TextEditingController
    printConsole('data dob: ${monthDobTEC.text}');
    String day =
        dayDobTEC.text.isEmpty ? '16' : formatWithLeadingZero(dayDobTEC.text);
    String month = monthDobTEC.text.isEmpty ? '05' : monthDobTEC.text;
    String year = yearDobTEC.text.isEmpty
        ? currentYear.toString()
        : yearDobTEC.text; // Mặc định năm nếu không nhập

    return '$day/$month/$year'; // Trả về chuỗi ngày/tháng/năm
  }

  String buildWifeDOBString() {
    String day =
        dayWifeTEC.text.isEmpty ? '16' : formatWithLeadingZero(dayWifeTEC.text);
    String month = monthWifeTEC.text.isEmpty
        ? '05'
        : formatWithLeadingZero(monthWifeTEC.text);
    String year = yearWifeTEC.text;
    return '$day/$month/$year';
  }

  String buildBorrowDOBString() {
    String day = dayBorrowTEC.text.isEmpty
        ? '16'
        : formatWithLeadingZero(dayBorrowTEC.text);
    String month = monthBorrowTEC.text.isEmpty
        ? '05'
        : formatWithLeadingZero(monthBorrowTEC.text);
    String year = yearBorrowTEC.text;
    return '$day/$month/$year';
  }

  //unfocus-node
  final FocusNode _yearDobFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _yearWifeFocusNode = FocusNode();
  final FocusNode _yearBorrowFocusNode = FocusNode();
  final FocusNode _direCoorFocusNode = FocusNode();
  final FocusNode _dayDobFocusNode = FocusNode();
  final FocusNode _dayWifeFocusNode = FocusNode();
  final FocusNode _dayBorrowFocusNode = FocusNode();
  bool hasText = false;
  //for-borrow
  String borrowDateTmp = '';
  String borrowDateSelected = '';
  String borrowTimeTmp = '';
  String borrowTimeSelected = '';
  //for-death
  String deathDateTmp = '';
  String deathDateSelected = '';
  String deathTimeTmp = '';
  String deathTimeSelected = '';
  //for-dob
  String dobDateTmp = '';
  String dobDateSelected = '';
  String dobTimeTmp = '';
  String dobTimeSelected = '';
  //for-wifr
  String wifeDateTmp = '';
  String wifeDateSelected = '';
  String wifeTimeTmp = '';
  String wifeTimeSelected = '';
  List<String> lstGender = [
    'male',
    'female',
  ];
  int idxGender = 0;
  List<String> typeOfTime = ['specifically', 'about'];
  int idxTimeType = 0;
  bool isSameTime = true;
  DireCoor? selectedDireCoor;
  String? codeOfDirect;
  String? codeOfCoor;
  String? codeOfDegree;
  String? codeDirection;
  bool isOpenDropDownMenu = false;
  bool isShowDobNote = false;
  bool isShowDobNoteSecond = false;
  bool isDongTho = false;
  bool isTrungTang = false;
  DateTime today = DateTime.now();
  DateTime? limitedDay;
  DateTime? dob;
  String? fromDate;
  String? toDate;
  LunarDatetimeData? lunarDatetimeMajorData;
  LunarDatetimeData? lunarDatetimeOthersData;
  bool is2LightTime = false;
  bool is2LightDeathDate = false;
  bool is2LightDireCoor = false;
  bool is2LightThingToCheck = false;
  bool is2LightBA = false;
  bool isIncludingDIA(String code) {
    List<String> listCode = CommonConstants.allOfCodesData;
    return listCode.contains(code);
  }

  List<Description> lstThing = [];
  bool isIncludingDIAInside(String thing) {
    List<String> lstThing = CommonConstants.allOfThingsData;
    return lstThing.contains(thing);
  }

  void onItemSelected(DireCoor selectedItem, bool isType) {
    printConsole(selectedItem.code);
    printConsole(selectedItem.codeDirection);
    printConsole(selectedItem.title);
    printConsole(selectedItem.titleDirection);
    setState(() {
      if (isType) {
        codeOfDegree = degreeTEC.text;
        is2LightDireCoor = false;
        selectedDireCoor = selectedItem;
        codeOfDirect = selectedItem.code;
        codeOfCoor = selectedItem.titleDirection;
        codeDirection = selectedItem.codeDirection;
        if (widget.importantData.code == 'sang-cat') {
          isSelectedBA = true;
        }
      } else {
        codeDirection = selectedItem.codeDirection;
        selectedDireCoor = selectedItem;
        codeOfDirect = selectedItem.code;
        codeOfCoor = selectedItem.titleDirection;
        codeOfDegree = selectedItem.degree;

        is2LightDireCoor = false;
        if (widget.importantData.code == 'sang-cat') {
          isSelectedBA = true;
        }
      }
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    lstThing = widget.importantData.descriptions ?? [];
    printConsole('ListThing: $lstThing');
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
    fromDate = DateFormat('dd/MM/yyyy').format(today);
    nameTEC.addListener(_capitalizeWordsForName);
    nameWifeTEC.addListener(_capitalizeWordsForNameWife);
    degreeTEC.addListener(_validateDegree);
    yearDeathTEC.addListener(_onYearDeathChanged);
    yearDobTEC.addListener(_onYearDOBChanged);
    yearBorrowTEC.addListener(_onYearBorrowChanged);
    yearWifeTEC.addListener(_onYearWifeChanged);
    dayDobTEC.addListener(_onDayDOBChanged);
    dayWifeTEC.addListener(_onDayWifeChanged);
    dayBorrowTEC.addListener(_onDayBorrowDOBChanged);
    printConsole('data month: ${monthDobTEC.text}');
  }

  void _onDayDOBChanged() {
    getLunarDatetime(buildDOBString(), '12:00:00');
  }

  void _onDayWifeChanged() {
    getLunarDatetimeSecond(buildWifeDOBString(), '12:00:00');
  }

  void _onDayBorrowDOBChanged() {
    getLunarDatetimeSecond(buildBorrowDOBString(), '12:00:00');
  }

  bool hasApiCalled = false;
  void _onYearDOBChanged() {
    _validateYear(yearDobTEC, (isValid) {
      final hasFourDigits = yearDobTEC.text.length == 4;
      setState(() {
        invalidYearDobTEC = !isValid;
        if (isValid && hasFourDigits && !hasApiCalled) {
          getLunarDatetime(buildDOBString(), '12:00:00');
          _yearDobFocusNode.unfocus();
          hasApiCalled = true;
        }
        if (hasFourDigits == false) {
          hasApiCalled = false;
        }
      });
    });
  }

  bool hasApiCalled2 = false;
  void _onYearWifeChanged() {
    _validateYear(yearWifeTEC, (isValid) {
      final hasFourDigits = yearWifeTEC.text.length == 4;
      setState(() {
        invalidYearWifeTEC = !isValid;
        if (isValid && hasFourDigits && !hasApiCalled2) {
          getLunarDatetimeSecond(buildWifeDOBString(), '12:00:00');
          hasApiCalled2 = true;
          FocusScope.of(context).unfocus();
        }
        if (hasFourDigits == false) {
          hasApiCalled2 = false;
        }
      });
    });
  }

  void _onYearBorrowChanged() {
    _validateYear(yearBorrowTEC, (isValid) {
      final hasFourDigits = yearBorrowTEC.text.length == 4;

      setState(() {
        invalidYearBorrowTEC = !isValid;
        if (widget.importantData.code == 'sang-cat' || isSelectedBA) {
          invalidYearBorrowTEC = !isValid;
          getAPIBorrow = isValid;
        }
        if (isValid && hasFourDigits && !hasApiCalled2) {
          getLunarDatetimeSecond(buildBorrowDOBString(), '12:00:00');

          hasApiCalled2 = true;
          FocusScope.of(context).unfocus();
        }
        if (hasFourDigits == false) {
          hasApiCalled2 = false;
        }
      });
    });
  }

  void _onYearDeathChanged() {
    _validateYear(yearDeathTEC, (isValid) {
      setState(() {
        invalidYearDeathTEC = !isValid;
        getAPIDeath = isValid;
        if (isValid) {
          int? yearDob = int.tryParse(yearDobTEC.text);
          int? yearDeath = int.tryParse(yearDeathTEC.text);
          if (yearDob != null && yearDeath != null) {
            is2LightDeathDate = yearDeath < yearDob;
          } else {
            is2LightDeathDate = false;
          }
        } else {
          is2LightDeathDate = false;
        }
      });
    });
  }

  @override
  void dispose() {
    yearDobTEC.removeListener(_onYearDOBChanged);
    yearDeathTEC.removeListener(_onYearDeathChanged);
    yearBorrowTEC.removeListener(_onYearBorrowChanged);
    yearWifeTEC.removeListener(_onYearWifeChanged);
    yearDeathTEC.dispose();
    monthDobTEC.dispose();
    monthBorrowTEC.dispose();
    monthWifeTEC.dispose();
    dayBorrowTEC.dispose();
    dayDobTEC.dispose();
    dayWifeTEC.dispose();
    nameTEC.dispose();
    degreeTEC.dispose();
    nameWifeTEC.dispose();
    super.dispose();
  }

  void _capitalizeWordsForName() {
    capitalizeWords(nameTEC);
  }

  void _capitalizeWordsForNameWife() {
    capitalizeWords(nameWifeTEC);
  }

  bool invalidDayDobTEC = false;
  bool invalidMonthDobTEC = false;
  bool invalidYearDobTEC = false;
  bool invalidYearDeathTEC = false;
  bool invalidYearBorrowTEC = false;
  bool invalidYearWifeTEC = false;
  bool getAPIDOB = false;
  bool getAPIDeath = false;
  bool getAPIBorrow = false;
  bool getAPIWife = false;

  final int minYear = 1900;
  final int maxYear = DateTime.now().year;
  String? errorMessage;
  void _validateYear(
      TextEditingController controller, Function(bool) callback) {
    String value = controller.text;
    bool isValid = true;
    if (value.length == 4) {
      int? year = int.tryParse(value);
      if (year == null || year < minYear || year > maxYear) {
        isValid = false;
        if (controller == yearDobTEC) {
          yearDobTEC.clear();
        } else if (controller == yearBorrowTEC) {
          yearBorrowTEC.clear();
        } else if (controller == yearWifeTEC) {
          yearWifeTEC.clear();
        }
      }
    } else {
      isValid = false;
    }
    callback(isValid);
  }

  bool invalidDegree = false;
  void _validateDegree() {
    String value = degreeTEC.text.replaceAll('°', '');
    if (value.isNotEmpty) {
      int? degree = int.tryParse(value);
      if (degree == null || degree < 0 || degree > 360) {
        setState(() {
          invalidDegree = true;
        });
        degreeTEC.value = const TextEditingValue(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
        );
      } else {
        setState(() {
          invalidDegree = false;
        });
      }
    } else {
      setState(() {
        invalidDegree = true;
      });
    }

    if (!degreeTEC.text.endsWith('°')) {
      degreeTEC.value = TextEditingValue(
        text: '$value°',
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  Future<void> fetchAuspiciousDate({
    required String aim,
    String? type,
    String? toaNha,
    String? toaMo,
    String? gender,
    String? name,
    String? date,
    String? time,
    String? maleName,
    String? maleDate,
    String? maleTime,
    String? femaleName,
    String? femaleDate,
    String? femaleTime,
    String? deadDate,
    String? deadTime,
    String? dateStart,
    String? dateEnd,
    bool? isMuonTuoi,
    String? borrowDate,
    String? borrowTime,
    String? lang,
    bool? isGiaChuDay,
    bool? isGiaChuMonth,
    bool? isGiaChuNamDay,
    bool? isGiaChuNamMonth,
    bool? isGiaChuNuDay,
    bool? isGiaChuNuMonth,
    bool? isTuoiMuonDay,
    bool? isTuoiMuonMonth,
  }) async {
    final String baseUrl = '$mainUrl/auspicious-date/$aim';
    Map<String, String> queryParams = {
      'type': type ?? '',
      'toaNha': toaNha ?? '',
      'toaMo': toaMo ?? '',
      'gender': gender ?? '',
      'name': name ?? '',
      'date': date ?? '',
      'time': time ?? '',
      'male_name': maleName ?? '',
      'male_date': maleDate ?? '',
      'male_time': maleTime ?? '',
      'female_name': femaleName ?? '',
      'female_date': femaleDate ?? '',
      'female_time': femaleTime ?? '',
      'dead_date': deadDate ?? '',
      'dead_time': deadTime ?? '',
      'dateStart': dateStart ?? '',
      'dateEnd': dateEnd ?? '',
      'isMuonTuoi': isMuonTuoi == null ? 'false' : isMuonTuoi.toString(),
      'borrow_date': borrowDate ?? '',
      'borrow_time': borrowTime ?? '',
      'lang': lang ?? '',
      'isGiaChuDay': isGiaChuDay.toString(),
      'isGiaChuMonth': isGiaChuMonth.toString(),
      'isGiaChuNamDay': isGiaChuNamDay.toString(),
      'isGiaChuNamMonth': isGiaChuNamMonth.toString(),
      'isGiaChuNuDay': isGiaChuNuDay.toString(),
      'isGiaChuNuMonth': isGiaChuNuMonth.toString(),
      'isTuoiMuonDay': isTuoiMuonDay.toString(),
      'isTuoiMuonMonth': isTuoiMuonMonth.toString()
    };
    queryParams.removeWhere((key, value) => value.isEmpty);
    Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    await EasyLoading.show(maskType: EasyLoadingMaskType.black);
    printConsole(uri.toString());
    // Kiểm tra xem người dùng đã đăng nhập hay chưa
    final response = await http.get(uri,
            headers: {'accept': 'application/json'}); // Nếu chưa đăng nhập

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      EasyLoading.dismiss();

      if (isLessThan18YearsApart(
              yearBorrowTEC.text, DateTime.now().year.toString()) &&
          isSelectedBA) {
        _showWarningPopupNotEnought18(context);
        return;
      }

      if (data['data']['warning'] != null &&
          data['data']['warning']['isShowWarning'] == true) {
        if (data['data']['warning']['recommendYears'] != null) {
          final yearList =
              (data['data']['warning']['recommendValidYears'] as List)
                  .map((item) => item as Map<String, dynamic>)
                  .toList();
          _showWarningPopup(context, data, yearList);

          return;
        } else {
          final yearList = [];
          _showWarningPopup(context, data, yearList);
        }
      }
      _dayDobFocusNode.unfocus();
      _yearDobFocusNode.unfocus();
      _dayWifeFocusNode.unfocus();
      _yearWifeFocusNode.unfocus();
      _dayBorrowFocusNode.unfocus();
      _yearBorrowFocusNode.unfocus();

      FocusScope.of(context).requestFocus(FocusNode());
      List<String> datePartsBorrow = buildBorrowDOBString().split('/');

      // Gán giá trị cho từng biến
      String dayBorrow = isTuoiMuonDay == false ? datePartsBorrow[0] : '--';
      String monthBorrow = isTuoiMuonMonth == false ? datePartsBorrow[1] : '--';
      String yearBorrow = datePartsBorrow[2];

      List<String> datePartsDOB = buildDOBString().split('/');

      // Gán giá trị cho từng biến
      String dayDOB = isGiaChuNamDay == false ? datePartsDOB[0] : '--';
      String monthDOB = isGiaChuNamMonth == false ? datePartsDOB[1] : '--';
      String yearDOB = datePartsDOB[2];

      List<String> datePartsWife = buildWifeDOBString().split('/');

      // Gán giá trị cho từng biến
      String dayWife = isGiaChuNuDay == false ? datePartsWife[0] : '--';
      String monthWife = isGiaChuNuMonth == false ? datePartsWife[1] : '--';
      String yearWife = datePartsWife[2];
      // Get.to(() => ResultOfImportantDayScreen(
      //       uiRepository: widget.uiRepository,
      //       wfName: nameWifeTEC.text,
      //       wfDob: AppDataGlobal.monthWifeIsSelected
      //           ? '$dayWife/$monthWife/$yearWife (${lunarDatetimeOthersData?.namCan?.tr ?? ''} ${lunarDatetimeOthersData?.namChi?.tr ?? ''})'
      //           : '${yearWifeTEC.text} (${lunarDatetimeOthersData?.namCan?.tr ?? ''} ${lunarDatetimeOthersData?.namChi?.tr ?? ''})',
      //       dataResult: data,
      //       incluDIA: codeOfDirect == null
      //           ? false
      //           : isIncludingDIA(widget.importantData.code ?? ''),
      //       code: widget.importantData.code ?? '',
      //       name: nameTEC.text,
      //       dob:
      //           '$dayDOB/$monthDOB/$yearDOB (${lunarDatetimeMajorData?.namCan?.tr ?? ''} ${lunarDatetimeMajorData?.namChi?.tr ?? ''})',
      //       aim: widget.importantData.name ?? '',
      //       title: selectedValue?.name ?? '',
      //       type: selectedValue?.code ?? '',
      //       gender: lstGender[idxGender],
      //       borrowDate: isSelectedBA
      //           ? (AppDataGlobal.monthBorrowIsSelected
      //               ? ('$dayBorrow/$monthBorrow/$yearBorrow (${lunarDatetimeOthersData?.namCan?.tr ?? ''} ${lunarDatetimeOthersData?.namChi?.tr ?? ''})')
      //               : '${yearBorrowTEC.text} (${lunarDatetimeOthersData?.namCan?.tr ?? ''} ${lunarDatetimeOthersData?.namChi?.tr ?? ''})')
      //           : '',
      //       deathDate:
      //           '$deathDateSelected (${lunarDatetimeOthersData?.namCan?.tr ?? ''} ${lunarDatetimeOthersData?.namChi?.tr ?? ''})',
      //       deathTime: deathTimeSelected == ''
      //           ? '12:00:00'
      //           : '$deathTimeSelected (${lunarDatetimeOthersData?.gioCan?.tr ?? ''} ${lunarDatetimeOthersData?.gioChi?.tr ?? ''})',
      //       isGiaChuNamDay: isGiaChuNamDay ?? false,
      //       isGiaChuNamMonth: isGiaChuNamMonth ?? false,
      //       isGiaChuNuDay: isGiaChuNuDay ?? false,
      //       isGiaChuNuMonth: isGiaChuNuMonth ?? false,
      //       isTuoiMuonDay: isTuoiMuonDay ?? false,
      //       isTuoiMuonMonth: isTuoiMuonMonth ?? false,
      //     ));

      if (kDebugMode) {
        printConsole(data);
      }
    } else {
      EasyLoading.dismiss();
        printConsole('missing_some_info'.tr);

    }
  }

  Future<void> getLunarDatetime(String date, String time) async {
    printConsole('data lunar1: ${monthDobTEC.text}');

    await widget.uiRepository.getLunarDatetime(date, time).then((response) {
      if (response.status ?? false) {
        EasyLoading.dismiss();
        setState(() {
          lunarDatetimeMajorData = response.data;
          printConsole(lunarDatetimeMajorData?.namCan ?? '');
          printConsole(lunarDatetimeMajorData?.namChi ?? '');
          isShowDobNote = true;
          printConsole('data lunar2: ${monthDobTEC.text}');
        });
      } else {
        EasyLoading.dismiss();
      }
    }).catchError(
      (onError) {
        EasyLoading.dismiss();
      },
    );
  }

  Future<void> getLunarDatetimeSecond(String date, String time) async {
    await widget.uiRepository.getLunarDatetime(date, time).then((response) {
      if (response.status ?? false) {
        EasyLoading.dismiss();
        setState(() {
          lunarDatetimeOthersData = response.data;
          isShowDobNoteSecond = true;
        });
      } else {
        EasyLoading.dismiss();
      }
    }).catchError(
      (onError) {
        EasyLoading.dismiss();
      },
    );
  }

  bool isSelectedBA = false;
  List<String> items = [];
  Description? selectedValue;
  int initSelectedPick = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: frameCommonWidget(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox( height: 108),
                SizedBox(
                  width: getResponsiveWidth(context),
                  child: Container(
                    margin: const EdgeInsets.all(22),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: AppColor.blackColor.withAlpha(60),
                              border: const GradientBoxBorder(
                                  gradient: LinearGradient(
                                      colors: CommonConstants.name),
                                  width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _headerTarget(),
                              const SizedBox( height: 20),
                              Visibility(
                                  visible:
                                      selectedValue?.code != 'tinh-trung-tang',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _infoTHIENArea(context),
                                    ],
                                  )),
                              const SizedBox( height: 20),
                              _infoNHANArea(context),
                              !isIncludingDIAInside(selectedValue?.code ?? '')
                                  ? const SizedBox()
                                  : Visibility(
                                      visible: isIncludingDIA(
                                          widget.importantData.code ?? ''),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox( height: 20),
                                          _infoDIAArea(context),
                                          const SizedBox( height: 12),
                                        ],
                                      )),
                              const SizedBox( height: 24),
                              _btnSubmit(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox( height: 80),
              ],
            ),
          ),
          titleAppbar: capitalForText(widget.importantData.name ?? '')),
    );
  }

  Widget _headerTarget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'thing_to_check'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextAppStyle().titleStyleLight(),
        ),
        const SizedBox( height: 8),
        GestureDetector(
          onTap: _showThingList,
          child: Container(
              width: Get.width,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.9 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color: is2LightThingToCheck
                      ? AppColor.colorRed
                      : AppColor.secondaryColor,
                ),
              ),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      selectedWork.isEmpty
                          ? 'select_thing_to_check'.tr
                          : selectedWork.tr,
                      style: selectedWork.isNotEmpty
                          ? TextAppStyle().normalTextStyleLight()
                          : TextAppStyle()
                              .hintTextGrey()
                              .copyWith(fontSize: 14),
                    ),
                  ),
                  Image.asset(
                    IconConstants.ic_arrow_down_gradient,
                    width: 20,
                  )
                ],
              ))),
        ),
      ],
    );
  }

  Widget _infoNHANArea(BuildContext context) {
    return Column(
      children: [
        _commonInfoArea(context),
        _weedingInfoArea(context),
        _deathInfoArea(context)
      ],
    );
  }

  Widget _infoDIAArea(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  height: 1,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: CommonConstants.name)),
                ),
              ),
              Center(
                child: Image.asset(
                  '' == 'vi'
                      ? FrameConstants.fr_dia_label
                      : '' == 'en'
                          ? FrameConstants.fr_dia_label_en
                          : FrameConstants.fr_dia_label_zh,
                  width: optimizedSize(
                      phone: 100, zfold: 148, tablet: 180, context: context),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                child: Container(
                  width: 100,
                  height: 1,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: CommonConstants.name)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox( height: 8),
        Text(
          widget.importantData.code == 'cuoi-hoi' &&
                  selectedValue?.code == 'ngay-dam-ngo'
              ? 'female_home_dire_coor'.tr
              : widget.importantData.code == 'cuoi-hoi'
                  ? 'male_home_dire_coor'.tr
                  : widget.importantData.code == 'sang-cat'
                      ? 'grave_dire_coor'.tr
                      : 'info_cons'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextAppStyle().titleStyleLight(),
        ),
        const SizedBox( height: 8),
        onTapWidget(
          onTap: () {
            _selectDireCoor(context);
          },
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: AppColor.blackColor.withAlpha((0.9 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 1,
                          color: is2LightDireCoor
                              ? AppColor.colorRed
                              : AppColor.textLightColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          codeOfDegree ?? '${'coordinates'.tr} (0-360\u00B0)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: (codeOfDegree ?? '') == ''
                              ? TextAppStyle()
                                  .hintTextGrey()
                                  .copyWith(fontSize: 14)
                              : TextAppStyle().normalTextStyleLight(),
                        ),
                      ),
                      Image.asset(
                        IconConstants.ic_place_gradient,
                        width: 24,
                        height: 24,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
            visible: (codeOfDirect ?? '') != '',
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '${'direction'.tr}: ${selectedDireCoor?.title.tr} ${codeOfCoor?.tr}\n${'seat'.tr}: ${codeOfDirect?.tr} $codeDirection',
                style: TextAppStyle().normalTextStyleLight(),
              ),
            )),
        const SizedBox( height: 8),
        onTapWidget(
          onTap: () {
            // Get.toNamed(Routes.QUICKACTIONCOMPASS);
          },
          child: Row(
            children: [
              GradientText(
                'get_coor_by_compass'.tr,
                colors: CommonConstants.gradientsBtn,
                style: TextAppStyle().normalTextStyleSmall().copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.newPrimaryColor2),
              ),
              const SizedBox( width: 8),
              Image.asset(
                IconConstants.ic_forward_gradient,
                width: 24,
                height: 24,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoTHIENArea(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  height: 1,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: CommonConstants.name)),
                ),
              ),
              Center(
                child: Image.asset(
                  '' == 'vi'
                      ? FrameConstants.fr_thien_label
                      : '' == 'en'
                          ? FrameConstants.fr_thien_label_en
                          : FrameConstants.fr_thien_label_zh,
                  width: optimizedSize(
                      phone: 100, zfold: 148, tablet: 180, context: context),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                child: Container(
                  width: 100,
                  height: 1,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: CommonConstants.name)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox( height: 8),
        Text(
          'time_to_check'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextAppStyle().titleStyleLight(),
        ),
        const SizedBox( height: 12),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                typeOfTime.length,
                (index) => onTapWidget(
                      onTap: () {
                        setState(() {
                          idxTimeType = index;
                          limitedDay = DateTime.now();
                          if (index == 1) {
                            isSameTime = false;
                            fromDate = DateFormat('dd/MM/yyyy').format(today);
                            toDate = fromDate;
                          } else {
                            isSameTime = true;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        width: ((MediaQuery.of(context).size.width > 500
                                    ? Get.width / 1.5
                                    : Get.width) -
                                72) /
                            2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(idxTimeType == index
                                ? IconConstants.ic_radio_active
                                : IconConstants.ic_radio_inactive),
                            const SizedBox( width: 8),
                            Text(
                              typeOfTime[index].tr,
                              style: TextAppStyle().normalTextStyleLight(),
                            )
                          ],
                        ),
                      ),
                    ))),
        const SizedBox( height: 16),
        Visibility(
          visible: idxTimeType == 1,
          child: Column(
            children: [
              Center(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 0.5,
                      decoration: const BoxDecoration(
                          gradient:
                              LinearGradient(colors: CommonConstants.name)),
                    ),
                    Text(
                      ' ${'from_date'.tr}:',
                      textAlign: TextAlign.center,
                      style: TextAppStyle().normalTextStyleSmallLight(),
                    ),
                  ],
                ),
              ),
              const SizedBox( height: 8),
            ],
          ),
        ),
        onTapWidget(
          onTap: () {
            _fromDate(context, fromDate);
          },
          child: Container(
            width: Get.width - 48 - 24,
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: AppColor.blackColor.withAlpha((0.9 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: AppColor.secondaryColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      fromDate ?? 'from_date'.tr,
                      textAlign: TextAlign.left,
                      style: TextAppStyle().normalTextStyleLight(),
                    ),
                  ],
                ),
                Image.asset(IconConstants.ic_pick_date, width: 24, height: 24)
              ],
            ),
          ),
        ),
        Visibility(
            visible: idxTimeType == 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox( height: 8),
                Center(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 0.5,
                        decoration: const BoxDecoration(
                            gradient:
                                LinearGradient(colors: CommonConstants.name)),
                      ),
                      Text(
                        ' ${'to_date'.tr}:',
                        textAlign: TextAlign.left,
                        style: TextAppStyle().normalTextStyleSmallLight(),
                      ),
                    ],
                  ),
                ),
                const SizedBox( height: 8),
                onTapWidget(
                  onTap: () {
                    _toDate(context, toDate);
                  },
                  child: Container(
                    width: Get.width - 48 - 24,
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color:
                            AppColor.blackColor.withAlpha((0.9 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            width: 1, color: AppColor.secondaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              toDate ?? 'to_date'.tr,
                              textAlign: TextAlign.left,
                              style: TextAppStyle().normalTextStyleLight(),
                            ),
                          ],
                        ),
                        Image.asset(IconConstants.ic_pick_date,
                            width: 24, height: 24)
                      ],
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget _btnSubmit() {
    return onTapWidget(
      onTap: () async {
        if (invalidYearWifeTEC ||
            invalidYearDobTEC ||
            invalidYearBorrowTEC ||
            invalidYearDeathTEC) {
          if (widget.importantData.code == 'tang-su') {
            PopupErrorState.show(context: context, title: 'death_date_note'.tr);
            setState(() {
              is2LightDeathDate = true;
            });
            return;
          }
          PopupErrorState.show(context: context, title: 'year_dob_note'.tr);
          return;
        }
        if (dayDobTEC.text == '0' ||
            dayDobTEC.text == '00' ||
            dayWifeTEC.text == '0' ||
            dayWifeTEC.text == '00' ||
            dayBorrowTEC.text == '0' ||
            dayBorrowTEC.text == '00') {
          if (widget.importantData.code == 'tang-su') {
            PopupErrorState.show(context: context, title: 'year_dob_note'.tr);
            setState(() {
              is2LightDeathDate = true;
            });
            return;
          }
          PopupErrorState.show(context: context, title: 'enter_dob_note'.tr);
          return;
        }
        if (selectedValue?.code == null) {
          PopupErrorState.show(
              context: context, title: 'pls_choose_thing_to_check'.tr);
          setState(() {
            is2LightThingToCheck = true;
          });
          return;
        }
        if (yearDobTEC.text == '') {
          PopupErrorState.show(context: context, title: 'enter_dob_note'.tr);
          setState(() {
            invalidYearDobTEC = true;
          });
          return;
        }
        if (isSelectedBA && yearBorrowTEC.text == '') {
          PopupErrorState.show(context: context, title: 'enter_dob_note'.tr);
          setState(() {
            invalidYearBorrowTEC = true;
          });
          return;
        }
        if (isIncludingDIA(widget.importantData.code ?? '') &&
            isIncludingDIAInside(selectedValue?.code ?? '') &&
            ((selectedDireCoor?.degree ?? '') == '') &&
            selectedValue?.code != 'ngay-ra-mat-san-pham') {
          PopupErrorState.show(
              context: context, title: 'please_enter_dire_coor'.tr);
          setState(() {
            is2LightDireCoor = true;
          });
          return;
        }
        if (widget.importantData.code == 'tang-su' &&
            dobTimeSelected == '' &&
            deathTimeSelected == '') {
          PopupErrorState.show(
            context: context,
            title: 'please_enter_time_death'.tr,
          );
          setState(() {
            is2LightTime = true;
          });
          return;
        }

        if (is2LightDeathDate) {
          PopupErrorState.show(context: context, title: 'death_date_note'.tr);
          setState(() {
            is2LightTime = false;
          });
          return;
        }

        // Chỉ kiểm tra nếu là tang sự
        if (widget.importantData.code == 'tang-su') {
          // Hàm parseDate để tái sử dụng
          DateTime? parseDate(String dateStr) {
            try {
              final parts = dateStr.split('/');
              if (parts.length != 3) return null;
              final day = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final year = int.parse(parts[2]);
              return DateTime(year, month, day);
            } catch (e) {
              return null;
            }
          }

          DateTime? dobDate = parseDate(buildDOBString());
          DateTime? deathDate = parseDate(deathDateSelected);

          if (dobDate == null || deathDate == null) {
            printConsole("Sai định dạng ngày tháng");
            return;
          }

          if (dobDate.isAfter(deathDate)) {
            PopupErrorState.show(
              context: context,
              title: 'dob_before_death'.tr,
            );
            return;
          }
        }

        try {
          fetchAuspiciousDate(
            toaMo: codeOfDirect,
            aim: widget.importantData.code ?? '',
            type: selectedValue?.code ?? '',
            toaNha: codeOfDirect,
            time: '12:00:00',
            date: buildDOBString(),
            dateStart: fromDate,
            dateEnd: isSameTime ? fromDate : toDate,
            isMuonTuoi: isSelectedBA,
            borrowDate: buildBorrowDOBString(),
            borrowTime: '12:00:00',
            deadDate: deathDateSelected,
            deadTime:
                deathTimeSelected == '' ? '12:00:00' : '$deathTimeSelected:00',
            gender: (1 - idxGender).toString(),
            lang: '',
            femaleName: nameWifeTEC.text,
            femaleDate: buildWifeDOBString(),
            femaleTime: '12:00:00',
            maleName: nameTEC.text,
            maleTime: '12:00:00',
            maleDate: buildDOBString(),
            isGiaChuDay: false,
            isGiaChuMonth: false,
            isGiaChuNamDay: dayDobTEC.text.isEmpty,
            isGiaChuNamMonth: monthDobTEC.text.isEmpty,
            isGiaChuNuDay: dayWifeTEC.text.isEmpty,
            isGiaChuNuMonth: monthWifeTEC.text.isEmpty,
            isTuoiMuonDay: dayBorrowTEC.text.isEmpty,
            isTuoiMuonMonth: monthBorrowTEC.text.isEmpty,
          );
        } catch (e) {
          printConsole(e.toString());
        }
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          width: optimizedSize(
              phone: Get.width - 48,
              zfold: (Get.width / 1.5) - 48,
              tablet: (Get.width / 1.25) - 48,
              context: context),
          height:
              optimizedSize(phone: 54, zfold: 62, tablet: 74, context: context),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ButtonConstants.btn_large_primary_active),
                  fit: BoxFit.fill)),
          child: Center(
            child: Text(
              'check_result'.tr,
              style: custom3DTextStyle(context),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, String dateType) async {
    DateTime dateInitDob = DateTime.now();
    DateTime dateInitBorrow = DateTime.now();
    DateTime dateInitDeath = DateTime.now();
    DateTime dateInitWife = DateTime.now();
    DateFormat format = DateFormat('dd/MM/yyyy');
    if (dateType == 'dob') {
      setState(() {
        if (dobDateSelected != '') {
          dobDateTmp = dobDateSelected;
          dateInitDob = format.parse(dobDateSelected);
        } else {
          dobDateTmp = DateFormat('dd/MM/yyyy').format(dateInitDob);
        }
      });
    } else if (dateType == 'borrow') {
      setState(() {
        if (borrowDateSelected != '') {
          borrowDateTmp = borrowDateSelected;
          dateInitBorrow = format.parse(borrowDateSelected);
        } else {
          borrowDateTmp = DateFormat('dd/MM/yyyy').format(dateInitBorrow);
        }
      });
    } else if (dateType == 'death') {
      if (deathDateSelected != '') {
        deathDateTmp = deathDateSelected;
        dateInitDeath = format.parse(deathDateSelected);
      } else {
        setState(() {
          deathDateTmp = DateFormat('dd/MM/yyyy').format(dateInitDeath);
        });
      }
    } else if (dateType == 'wife') {
      setState(() {
        if (wifeDateSelected != '') {
          wifeDateTmp = wifeDateSelected;
          dateInitWife = format.parse(wifeDateSelected);
        } else {
          wifeDateTmp = DateFormat('dd/MM/yyyy').format(dateInitWife);
        }
      });
    }
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      barrierColor: AppColor.blackColor75,
      backgroundColor: AppColor.whiteColor,
      useSafeArea: true,
      builder: (context) {
        var size = MediaQuery.of(context).size;
        return CupertinoTheme(
            data: const CupertinoThemeData(
              primaryColor: Color.fromARGB(97, 241, 240, 240),
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                    color: Color.fromARGB(255, 241, 240, 240), fontSize: 16),
                pickerTextStyle: TextStyle(
                  color: Color.fromARGB(97, 241, 240, 240),
                ),
              ),
            ),
            child: Container(
              height: size.height * 0.4,
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26)),
                  border: Border(
                      top: BorderSide(
                          color: AppColor.newPrimaryColor2, width: 6)),
                  image: const DecorationImage(
                      image: AssetImage(ImageConstants.img_bg_mbs_flower),
                      fit: BoxFit.cover)),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox( width: 40),
                      Text("pick_date".tr, style: TextAppStyle().titleStyle()),
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
                      )
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  width: Get.width - 48,
                  margin: const EdgeInsets.only(top: 16, bottom: 0),
                  decoration: BoxDecoration(
                      color: AppColor.primaryColor
                          .withAlpha((0.25 * 255).toInt())),
                ),
                Expanded(
                  flex: 12,
                  child: Container(
                    margin: EdgeInsets.zero,
                    width: double.infinity,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle:
                              TextAppStyle().semiBoldTextStyle(),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        itemExtent: 44,
                        backgroundColor: AppColor.transparentColor,
                        onDateTimeChanged: (value) {
                          if (dateType == 'dob') {
                            setState(() {
                              dobDateTmp =
                                  DateFormat('dd/MM/yyyy').format(value);
                              dob = value;
                            });
                          } else if (dateType == 'borrow') {
                            setState(() {
                              borrowDateTmp =
                                  DateFormat('dd/MM/yyyy').format(value);
                            });
                          } else if (dateType == 'death') {
                            if (dob != null && value.isBefore(dob!)) {
                              setState(() {
                                is2LightDeathDate = true;
                              });
                            } else {
                              setState(() {
                                deathDateTmp =
                                    DateFormat('dd/MM/yyyy').format(value);
                                is2LightDeathDate = false;
                              });
                            }
                          } else if (dateType == 'wife') {
                            setState(() {
                              wifeDateTmp =
                                  DateFormat('dd/MM/yyyy').format(value);
                            });
                          }
                        },
                        initialDateTime: dateType == 'dob'
                            ? dateInitDob
                            : dateType == 'borrow'
                                ? dateInitBorrow
                                : dateType == 'death'
                                    ? dateInitDeath
                                    : dateInitWife,
                        minimumYear: 1900,
                        maximumYear: DateTime.now().year,
                        maximumDate: DateTime.now(),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: optimizedSize(
                              phone: (Get.width - 100) / 2,
                              zfold: (Get.width - 100) / 3,
                              tablet: (Get.width - 100) / 3,
                              context: context),
                          height: optimizedSize(
                              phone: 42,
                              zfold: 50,
                              tablet: 50,
                              context: context),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ButtonConstants
                                      .btn_small_primary_inactive),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: Text('cancel'.tr,
                                style: TextAppStyle()
                                    .normalTextStyle()
                                    .copyWith(
                                        color: AppColor.secondaryColor
                                            .withAlpha((0.5 * 255).toInt()))),
                          ),
                        ),
                      ),
                      const SizedBox( width: 16),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (dateType == 'dob') {
                            setState(() {
                              dobDateSelected = dobDateTmp;
                              Navigator.pop(context);
                              getLunarDatetime(
                                  dobDateSelected,
                                  dobTimeTmp == ''
                                      ? '01:00:00'
                                      : '$dobTimeTmp:00');
                            });
                          } else if (dateType == 'borrow') {
                            setState(() {
                              borrowDateSelected = borrowDateTmp;
                              Navigator.pop(context);
                              getLunarDatetimeSecond(
                                  borrowDateSelected,
                                  borrowTimeTmp == ''
                                      ? '01:00:00'
                                      : '$borrowTimeTmp:00');
                            });
                          } else if (dateType == 'death') {
                            setState(() {
                              deathDateSelected = deathDateTmp;
                              Navigator.pop(context);
                              getLunarDatetimeSecond(
                                  deathDateSelected,
                                  deathTimeTmp == ''
                                      ? '01:00:00'
                                      : '$deathTimeTmp:00');
                            });
                          } else if (dateType == 'wife') {
                            setState(() {
                              wifeDateSelected = wifeDateTmp;
                              Navigator.pop(context);
                              getLunarDatetimeSecond(
                                  wifeDateSelected,
                                  wifeTimeTmp == ''
                                      ? '01:00:00'
                                      : '$wifeTimeTmp:00');
                            });
                          }
                        },
                        child: Container(
                          width: optimizedSize(
                              phone: (Get.width - 100) / 2,
                              zfold: (Get.width - 100) / 3,
                              tablet: (Get.width - 100) / 3,
                              context: context),
                          height: optimizedSize(
                              phone: 42,
                              zfold: 50,
                              tablet: 50,
                              context: context),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      ButtonConstants.btn_small_primary_active),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: Text('confirm'.tr,
                                style: custom3DTextStyle(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 3,
                )
              ]),
            ));
      },
    );
  }

  Future<void> _selectTime(BuildContext context, String timeType) async {
    DateFormat format = DateFormat('HH:mm');
    DateTime timeInit = format.parse('00:00:00');
    if (timeType == 'dob') {
      setState(() {
        if (dobTimeSelected != '') {
          dobTimeTmp = dobTimeSelected;
          timeInit = format.parse(dobTimeSelected);
        } else {
          dobTimeTmp = '00:00';
        }
      });
    } else if (timeType == 'borrow') {
      setState(() {
        if (borrowTimeSelected != '') {
          borrowTimeTmp = borrowTimeSelected;
          timeInit = format.parse(borrowTimeSelected);
        } else {
          borrowTimeTmp = DateFormat('dd/MM/yyyy').format(timeInit);
        }
      });
    } else if (timeType == 'death') {
      setState(() {
        if (deathTimeSelected != '') {
          deathTimeTmp = deathTimeSelected;
          timeInit = format.parse(deathTimeSelected);
        } else {
          deathTimeTmp = '00:00';
        }
      });
    } else if (timeType == 'wife') {
      setState(() {
        if (wifeTimeSelected != '') {
          wifeTimeTmp = wifeTimeSelected;
          timeInit = format.parse(wifeTimeSelected);
        } else {
          wifeTimeTmp = '00:00';
        }
      });
    }

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      barrierColor: AppColor.blackColor75,
      backgroundColor: AppColor.whiteColor,
      useSafeArea: true,
      builder: (context) {
        var size = MediaQuery.of(context).size;
        return CupertinoTheme(
            data: const CupertinoThemeData(
              primaryColor: Color.fromARGB(97, 241, 240, 240),
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                    color: Color.fromARGB(255, 241, 240, 240), fontSize: 16),
                pickerTextStyle: TextStyle(
                  color: Color.fromARGB(97, 241, 240, 240),
                ),
              ),
            ),
            child: Container(
              height: size.height * 0.4,
              width: getResponsiveWidth(context),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26)),
                  border: Border(
                      top: BorderSide(
                          color: AppColor.newPrimaryColor2, width: 6)),
                  image: const DecorationImage(
                      image: AssetImage(ImageConstants.img_bg_mbs_flower),
                      fit: BoxFit.cover)),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox( width: 40),
                      Text("pick_date".tr, style: TextAppStyle().titleStyle()),
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
                      )
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  width: Get.width - 48,
                  margin: const EdgeInsets.only(top: 16, bottom: 0),
                  decoration: BoxDecoration(
                      color: AppColor.primaryColor
                          .withAlpha((0.25 * 255).toInt())),
                ),
                Expanded(
                  flex: 12,
                  child: Container(
                    margin: EdgeInsets.zero,
                    width: double.infinity,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle:
                              TextAppStyle().semiBoldTextStyle(),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        itemExtent: 44,
                        backgroundColor: AppColor.transparentColor,
                        onDateTimeChanged: (value) {
                          if (timeType == 'dob') {
                            setState(() {
                              dobTimeTmp = DateFormat('HH:mm').format(value);
                            });
                          } else if (timeType == 'borrow') {
                            setState(() {
                              borrowTimeTmp = DateFormat('HH:mm').format(value);
                            });
                          } else if (timeType == 'death') {
                            setState(() {
                              deathTimeTmp = DateFormat('HH:mm').format(value);
                            });
                          } else if (timeType == 'wife') {
                            setState(() {
                              wifeTimeTmp = DateFormat('HH:mm').format(value);
                            });
                          }
                        },
                        initialDateTime: timeInit,
                        minimumYear: 1900,
                        maximumYear: DateTime.now().year,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: optimizedSize(
                              phone: (Get.width - 100) / 2,
                              zfold: (Get.width - 100) / 3,
                              tablet: (Get.width - 100) / 3,
                              context: context),
                          height: optimizedSize(
                              phone: 42,
                              zfold: 50,
                              tablet: 50,
                              context: context),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ButtonConstants
                                      .btn_small_primary_inactive),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: Text('cancel'.tr,
                                style: TextAppStyle()
                                    .normalTextStyle()
                                    .copyWith(
                                        color: AppColor.secondaryColor
                                            .withAlpha((0.5 * 255).toInt()))),
                          ),
                        ),
                      ),
                      const SizedBox( width: 16),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (timeType == 'dob') {
                            setState(() {
                              dobTimeSelected = dobTimeTmp;
                              Navigator.pop(context);
                              is2LightTime = false;
                              getLunarDatetime(
                                  dobDateSelected,
                                  dobTimeSelected == ''
                                      ? '01:00:00'
                                      : '$dobTimeSelected:00');
                            });
                          } else if (timeType == 'borrow') {
                            setState(() {
                              borrowTimeSelected = borrowTimeTmp;
                              Navigator.pop(context);
                              is2LightTime = false;
                              getLunarDatetimeSecond(
                                  borrowDateSelected,
                                  borrowTimeSelected == ''
                                      ? '01:00:00'
                                      : '$borrowTimeSelected:00');
                            });
                          } else if (timeType == 'death') {
                            setState(() {
                              deathTimeSelected = deathTimeTmp;
                              Navigator.pop(context);
                              is2LightTime = false;
                            });
                          } else if (timeType == 'wife') {
                            setState(() {
                              wifeTimeSelected = wifeTimeTmp;
                              Navigator.pop(context);
                              is2LightTime = false;

                              getLunarDatetimeSecond(
                                  wifeDateSelected,
                                  wifeDateSelected == ''
                                      ? '01:00'
                                      : '$wifeDateSelected:00');
                            });
                          }
                        },
                        child: Container(
                          width: optimizedSize(
                              phone: (Get.width - 100) / 2,
                              zfold: (Get.width - 100) / 3,
                              tablet: (Get.width - 100) / 3,
                              context: context),
                          height: optimizedSize(
                              phone: 42,
                              zfold: 50,
                              tablet: 50,
                              context: context),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      ButtonConstants.btn_small_primary_active),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: Text('confirm'.tr,
                                style: custom3DTextStyle(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 3,
                )
              ]),
            ));
      },
    );
  }

  Future<void> _selectDireCoor(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      barrierColor: AppColor.blackColor75,
      backgroundColor: AppColor.whiteColor,
      useSafeArea: true,
      builder: (context) {
        var size = MediaQuery.of(context).size;
        return CupertinoTheme(
            data: const CupertinoThemeData(
              primaryColor: Color.fromARGB(97, 241, 240, 240),
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                    color: Color.fromARGB(255, 241, 240, 240), fontSize: 16),
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
                        topRight: Radius.circular(26)),
                    border: Border(
                        top: BorderSide(
                            color: AppColor.newPrimaryColor2, width: 6)),
                    image: const DecorationImage(
                        image: AssetImage(ImageConstants.img_bg_mbs_flower),
                        fit: BoxFit.cover)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox( height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox( width: 40),
                            Flexible(
                              child: Text(
                                capitalForText('pick_dire_coor'.tr),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextAppStyle()
                                    .titleStyle()
                                    .copyWith(color: AppColor.primaryColor),
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
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 0.5,
                        width: Get.width - 48,
                        margin: const EdgeInsets.only(top: 16, bottom: 0),
                        decoration: BoxDecoration(
                            color: AppColor.primaryColor
                                .withAlpha((0.25 * 255).toInt())),
                      ),
                      const SizedBox( height: 12),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.black
                                      .withAlpha((0.9 * 255).toInt()),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: TextField(
                                    focusNode: _direCoorFocusNode,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    controller: degreeTEC,
                                    cursorColor: AppColor.secondaryColor,
                                    cursorHeight: 24,
                                    keyboardType: TextInputType.number,
                                    style:
                                        TextAppStyle().normalTextStyleLight(),
                                    decoration: InputDecoration(
                                      suffixIconConstraints:
                                          const BoxConstraints(
                                              maxWidth: 80, maxHeight: 40),
                                      suffixIcon: onTapWidget(
                                        onTap: () async {
                                          _direCoorFocusNode.unfocus();
                                          String value = degreeTEC.text
                                              .replaceAll('°', '');
                                          if (value != '') {
                                            printConsole(value);
                                            onItemSelected(
                                                getCoorFromDegree(
                                                        int.parse(value)) ??
                                                    DireCoor(
                                                        title: 'Tý',
                                                        degree: '0\u00B0',
                                                        code: 'ngo',
                                                        titleDirection: '(Bắc)',
                                                        codeDirection: '(Nam)'),
                                                true);
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.clear_rounded,
                                                  size: 20,
                                                  color: AppColor
                                                      .grayTextwhiteColor),
                                              onPressed: () {
                                                degreeTEC.clear();
                                                setState(() {
                                                  hasText = false;
                                                });
                                              },
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  border: const GradientBoxBorder(
                                                      gradient: LinearGradient(
                                                          colors: CommonConstants
                                                              .gradientsLight),
                                                      width: 0.5),
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                      colors: CommonConstants
                                                          .gradientBrownBtn)),
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                    AppColor.borderYellow,
                                                    BlendMode.srcATop),
                                                child: Image.asset(
                                                  IconConstants.ic_search_light,
                                                  width: 18,
                                                  height: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 6, bottom: 3, left: 0),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                              maxWidth: 120, maxHeight: 40),
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Image.asset(
                                          IconConstants.ic_satellite_gradient,
                                          width: 28,
                                          height: 28,
                                        ),
                                      ),
                                      isDense: true,
                                      hintText: 'enter_your_degree'.tr,
                                      hintStyle: TextAppStyle()
                                          .hintTextGrey()
                                          .copyWith(fontSize: 14),
                                      border: InputBorder.none,
                                    ),
                                    onSubmitted: (value) async {
                                      _direCoorFocusNode.unfocus();

                                      String value =
                                          degreeTEC.text.replaceAll('°', '');
                                      if (value != '') {
                                        onItemSelected(
                                            getCoorFromDegree(
                                                    int.parse(value)) ??
                                                DireCoor(
                                                    title: 'Tý',
                                                    degree: '0\u00B0',
                                                    code: 'ngo',
                                                    titleDirection: '(Bắc)',
                                                    codeDirection: '(Nam)'),
                                            true);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox( width: 24),
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
                                  left: 32, right: 24, top: 4),
                              child: RawScrollbar(
                                thumbColor: AppColor.actionTextYellow,
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
                                                MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        500
                                                    ? 1.65
                                                    : 1.25),
                                    itemCount:
                                        CommonConstants.lstDireCoor.length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          CommonConstants.lstDireCoor[index];
                                      return GestureDetector(
                                        onTap: () {
                                          onItemSelected(item, false);
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: selectedDireCoor == item
                                                  ? AppColor.actionTextYellow
                                                  : const Color.fromARGB(
                                                      255, 251, 250, 239),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: selectedDireCoor == item
                                                  ? GradientBoxBorder(
                                                      gradient: LinearGradient(
                                                          colors: CommonConstants
                                                              .gradientBrownBtn))
                                                  : const GradientBoxBorder(
                                                      gradient: LinearGradient(
                                                          colors:
                                                              CommonConstants
                                                                  .name))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(item.title,
                                                  textAlign: TextAlign.center,
                                                  style: TextAppStyle()
                                                      .titleStyleLarge()),
                                              Text(item.titleDirection,
                                                  textAlign: TextAlign.center,
                                                  style: TextAppStyle()
                                                      .thinTextStyleSmall()),
                                              Text(
                                                item.degree,
                                                style: TextAppStyle()
                                                    .normalTextStyleLarge(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ))),
                    ]),
              ),
            ));
      },
    );
  }

  Future<void> _fromDate(BuildContext context, String? fromDateArg) async {
    DateTime dateInit = DateTime.now();
    DateTime minimumDate = DateTime.now();
    DateFormat format = DateFormat('dd/MM/yyyy');
    setState(() {
      if ((fromDate ?? '') != '') {
        fromDateArg = fromDate;
        dateInit = format.parse(fromDate ?? '01/01/2025');
      } else {
        fromDateArg = format.format(dateInit);
      }
    });
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      barrierColor: AppColor.blackColor75,
      backgroundColor: AppColor.whiteColor,
      useSafeArea: true,
      builder: (context) {
        var size = MediaQuery.of(context).size;
        return CupertinoTheme(
            data: const CupertinoThemeData(
              primaryColor: Color.fromARGB(97, 241, 240, 240),
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                    color: Color.fromARGB(255, 241, 240, 240), fontSize: 16),
                pickerTextStyle: TextStyle(
                  color: Color.fromARGB(97, 241, 240, 240),
                ),
              ),
            ),
            child: Container(
              height: size.height * 0.4,
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26)),
                  border: Border(
                      top: BorderSide(
                          color: AppColor.newPrimaryColor2, width: 6)),
                  image: const DecorationImage(
                      image: AssetImage(ImageConstants.img_bg_mbs_flower),
                      fit: BoxFit.cover)),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox( width: 40),
                      Text("pick_date".tr, style: TextAppStyle().titleStyle()),
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
                      )
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  width: Get.width - 48,
                  margin: const EdgeInsets.only(top: 16, bottom: 0),
                  decoration: BoxDecoration(
                      color: AppColor.primaryColor
                          .withAlpha((0.25 * 255).toInt())),
                ),
                Expanded(
                  flex: 12,
                  child: Container(
                    margin: EdgeInsets.zero,
                    width: double.infinity,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle:
                              TextAppStyle().semiBoldTextStyle(),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        itemExtent: 44,
                        backgroundColor: AppColor.transparentColor,
                        onDateTimeChanged: (value) {
                          setState(() {
                            fromDateArg =
                                DateFormat('dd/MM/yyyy').format(value);
                            limitedDay = value;
                          });
                        },
                        initialDateTime: dateInit.isBefore(minimumDate)
                            ? minimumDate
                            : dateInit,
                        minimumYear: DateTime.now().year,
                        minimumDate: minimumDate,
                        maximumDate: DateTime.now()
                            .add(const Duration(days: 365 * 1000)),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                          _yearDobFocusNode.unfocus();
                          _yearWifeFocusNode.unfocus();
                          _yearBorrowFocusNode.unfocus();
                        },
                        child: Container(
                          width: optimizedSize(
                              phone: (Get.width - 100) / 2,
                              zfold: (Get.width - 100) / 3,
                              tablet: (Get.width - 100) / 3,
                              context: context),
                          height: optimizedSize(
                              phone: 42,
                              zfold: 50,
                              tablet: 50,
                              context: context),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ButtonConstants
                                      .btn_small_primary_inactive),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: Text('cancel'.tr,
                                style: TextAppStyle()
                                    .normalTextStyle()
                                    .copyWith(
                                        color: AppColor.secondaryColor
                                            .withAlpha((0.5 * 255).toInt()))),
                          ),
                        ),
                      ),
                      const SizedBox( width: 16),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                          _yearDobFocusNode.unfocus();
                          _yearWifeFocusNode.unfocus();
                          _yearBorrowFocusNode.unfocus();
                          setState(() {
                            fromDate = fromDateArg;
                            if (idxTimeType == 1 &&
                                format
                                    .parse(fromDate ?? '')
                                    .isAfter(format.parse(toDate ?? ''))) {
                              toDate = fromDateArg;
                            }
                          });
                        },
                        child: Container(
                          width: optimizedSize(
                              phone: (Get.width - 100) / 2,
                              zfold: (Get.width - 100) / 3,
                              tablet: (Get.width - 100) / 3,
                              context: context),
                          height: optimizedSize(
                              phone: 42,
                              zfold: 50,
                              tablet: 50,
                              context: context),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      ButtonConstants.btn_small_primary_active),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: Text('confirm'.tr,
                                style: custom3DTextStyle(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 3,
                )
              ]),
            ));
      },
    );
  }

  Future<void> _toDate(BuildContext context, String? toDateArg) async {
    DateTime dateInit = limitedDay ?? DateTime.now();
    DateTime minimumDate = limitedDay ?? DateTime.now();

    DateFormat format = DateFormat('dd/MM/yyyy');
    setState(() {
      if ((toDate ?? '') != '') {
        toDateArg = toDate;
        dateInit = format.parse(toDate ?? '01/01/2025');
      } else {
        toDateArg = format.format(dateInit);
      }
    });
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      barrierColor: AppColor.blackColor75,
      backgroundColor: AppColor.whiteColor,
      useSafeArea: true,
      builder: (context) {
        var size = MediaQuery.of(context).size;
        return CupertinoTheme(
            data: const CupertinoThemeData(
              primaryColor: Color.fromARGB(97, 241, 240, 240),
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                    color: Color.fromARGB(255, 241, 240, 240), fontSize: 16),
                pickerTextStyle: TextStyle(
                  color: Color.fromARGB(97, 241, 240, 240),
                ),
              ),
            ),
            child: Container(
              height: size.height * 0.4,
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26)),
                  border: Border(
                      top: BorderSide(
                          color: AppColor.newPrimaryColor2, width: 6)),
                  image: const DecorationImage(
                      image: AssetImage(ImageConstants.img_bg_mbs_flower),
                      fit: BoxFit.cover)),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox( width: 40),
                      Text("pick_date".tr, style: TextAppStyle().titleStyle()),
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
                      )
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  width: Get.width - 48,
                  margin: const EdgeInsets.only(top: 16, bottom: 0),
                  decoration: BoxDecoration(
                      color: AppColor.primaryColor
                          .withAlpha((0.25 * 255).toInt())),
                ),
                Expanded(
                  flex: 12,
                  child: Container(
                    margin: EdgeInsets.zero,
                    width: double.infinity,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle:
                              TextAppStyle().semiBoldTextStyle(),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        itemExtent: 44,
                        backgroundColor: AppColor.transparentColor,
                        onDateTimeChanged: (value) {
                          setState(() {
                            toDateArg = DateFormat('dd/MM/yyyy').format(value);
                          });
                        },
                        initialDateTime: dateInit.isBefore(minimumDate)
                            ? minimumDate
                            : dateInit,
                        minimumYear: DateTime.now().year,
                        minimumDate: limitedDay,
                        maximumDate: DateTime.now()
                            .add(const Duration(days: 365 * 1000)),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                          _yearDobFocusNode.unfocus();
                          _yearWifeFocusNode.unfocus();
                          _yearBorrowFocusNode.unfocus();
                        },
                        child: Container(
                          width: optimizedSize(
                              phone: (Get.width - 100) / 2,
                              zfold: (Get.width - 100) / 3,
                              tablet: (Get.width - 100) / 3,
                              context: context),
                          height: optimizedSize(
                              phone: 42,
                              zfold: 50,
                              tablet: 50,
                              context: context),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ButtonConstants
                                      .btn_small_primary_inactive),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: Text('cancel'.tr,
                                style: TextAppStyle()
                                    .normalTextStyle()
                                    .copyWith(
                                        color: AppColor.secondaryColor
                                            .withAlpha((0.5 * 255).toInt()))),
                          ),
                        ),
                      ),
                      const SizedBox( width: 16),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                          _yearDobFocusNode.unfocus();
                          _yearWifeFocusNode.unfocus();
                          _yearBorrowFocusNode.unfocus();
                          setState(() {
                            toDate = toDateArg;
                          });
                        },
                        child: Container(
                          width: optimizedSize(
                              phone: (Get.width - 100) / 2,
                              zfold: (Get.width - 100) / 3,
                              tablet: (Get.width - 100) / 3,
                              context: context),
                          height: optimizedSize(
                              phone: 42,
                              zfold: 50,
                              tablet: 50,
                              context: context),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      ButtonConstants.btn_small_primary_active),
                                  fit: BoxFit.fill)),
                          child: Center(
                            child: Text('confirm'.tr,
                                style: custom3DTextStyle(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 3,
                )
              ]),
            ));
      },
    );
  }

  Widget _commonInfoArea(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  height: 1,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: CommonConstants.name)),
                ),
              ),
              Center(
                child: Image.asset(
                  '' == 'vi'
                      ? FrameConstants.fr_nhan_label
                      : '' == 'en'
                          ? FrameConstants.fr_nhan_label_en
                          : FrameConstants.fr_nhan_label_zh,
                  width: optimizedSize(
                      phone: 100, zfold: 148, tablet: 180, context: context),
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                child: Container(
                  width: 100,
                  height: 1,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: CommonConstants.name)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox( height: 8),
        Visibility(
            visible: widget.importantData.code == 'cuoi-hoi',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 0.5,
                      decoration: const BoxDecoration(
                          gradient:
                              LinearGradient(colors: CommonConstants.name)),
                    ),
                    const SizedBox( width: 4),
                    ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            AppColor.secondaryColor, BlendMode.srcATop),
                        child: Image.asset(
                          IconConstants.ic_male_avatar,
                          width: 16,
                        )),
                    const SizedBox( width: 4),
                    Text(
                      'male'.tr,
                      style: TextAppStyle().semiBoldTextStyleSmall().copyWith(
                          fontSize: 14, color: AppColor.secondaryColor),
                    ),
                  ],
                ),
                const SizedBox( height: 8)
              ],
            )),
        Text(
          'full_name'.tr,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextAppStyle().titleStyleLight(),
        ),
        const SizedBox( height: 8),
        Container(
          height: 52,
          width: Get.width - 48 - 24,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColor.blackColor.withAlpha((0.9 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: AppColor.secondaryColor,
            ),
          ),
          child: Center(
            child: TextField(
              focusNode: _nameFocusNode,
              controller: nameTEC,
              cursorColor: AppColor.secondaryColor,
              cursorHeight: 24,
              keyboardType: TextInputType.text,
              style: TextAppStyle().normalTextStyleLight(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
                isDense: true,
                hintText: 'enter_your_fullname'.tr,
                hintStyle: TextAppStyle().hintTextGrey().copyWith(fontSize: 14),
                border: InputBorder.none,
                suffixIconConstraints: const BoxConstraints(maxWidth: 40),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showClearButtonFullName) // Show clear button based on state
                      GestureDetector(
                        onTap: () {
                          nameTEC.clear(); // Clear the text
                          setState(() {
                            showClearButtonFullName =
                                false; // Hide clear button
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Icon(Icons.clear_rounded,
                              size: 24, color: AppColor.grayTextwhiteColor),
                        ),
                      ),
                  ],
                ),
              ),
              onEditingComplete: () {
                _nameFocusNode.unfocus();
              },
              onChanged: (v) {
                if (v.isNotEmpty) {
                  setState(() {
                    showClearButtonFullName = v.isNotEmpty;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox( height: 12),
        Visibility(
            visible: widget.importantData.code == 'tang-su',
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      lstGender.length,
                      (index) => SizedBox(
                            width: (Get.width - 72) / 2,
                            child: onTapWidget(
                              onTap: () {
                                setState(() {
                                  idxGender = index;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(idxGender == index
                                      ? IconConstants.ic_radio_active
                                      : IconConstants.ic_radio_inactive),
                                  const SizedBox( width: 8),
                                  Text(
                                    lstGender[index].tr,
                                    style:
                                        TextAppStyle().normalTextStyleLight(),
                                  ),
                                ],
                              ),
                            ),
                          )),
                ),
                const SizedBox( height: 12)
              ],
            )),
        const SizedBox( height: 12),
        Row(
          children: [
            Text(
              '${'day'.tr}/${'month'.tr}/${'dob_year'.tr}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextAppStyle().titleStyleLight(),
            ),
            Flexible(
              child: Text(
                ' (${'solar'.tr})',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextAppStyle().normalTextStyleSmallLight(),
              ),
            ),
          ],
        ),
        const SizedBox( height: 8),
        TextFieldDOBTest(
          type: 'dob',
          yearDobTEC: yearDobTEC,
          dayDobTEC: dayDobTEC,
          monthDobTEC: monthDobTEC,
          uiRepository: widget.uiRepository,
          isGetLunarDate: true,
          onMonthSelected: handleMonthSelected,
          focusnodeDay: _dayDobFocusNode,
          focusnodeYear: _yearDobFocusNode,
          selectedMonth: selectedMonth,
          isClearMonth: isClearMonth,
          onResetComplete: clearMonthData,
        ),
        (selectedValue?.code ?? '') == 'dong-tho' ||
                (selectedValue?.code ?? '') == 'khoi-cong'
            ? _borrowAge(context)
            : const SizedBox(),
        _personRep(context),
      ],
    );
  }

  Widget _weedingInfoArea(BuildContext context) {
    return Visibility(
        visible: widget.importantData.code == 'cuoi-hoi',
        child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox( height: 24),
            Row(
              children: [
                const SizedBox( height: 24),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 0.5,
                      decoration: const BoxDecoration(
                          gradient:
                              LinearGradient(colors: CommonConstants.name)),
                    ),
                    const SizedBox( width: 4),
                    ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            AppColor.secondaryColor, BlendMode.srcATop),
                        child: Image.asset(
                          IconConstants.ic_female_avatar,
                          width: 16,
                        )),
                    const SizedBox( width: 4),
                    Text(
                      'female'.tr,
                      style: TextAppStyle().semiBoldTextStyleSmall().copyWith(
                          fontSize: 14, color: AppColor.secondaryColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox( height: 8),
            Text(
              'full_name'.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextAppStyle().titleStyleLight(),
            ),
            const SizedBox( height: 8),
            CustomTextFieldDark(
              onTap: () {},
              isEnable: true,
              controller: nameWifeTEC,
              hintText: 'enter_your_fullname'.tr,
              onChanged: (v) {},
            ),
            const SizedBox( height: 12),
            Row(
              children: [
                Text(
                  '${'day'.tr}/${'month'.tr}/${'dob_year'.tr}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextAppStyle().titleStyleLight(),
                ),
                Text(
                  ' (${'solar'.tr})',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextAppStyle().normalTextStyleSmallLight(),
                ),
              ],
            ),
            const SizedBox( height: 8),
            TextFieldDOBTest(
              type: 'wife',
              yearDobTEC: yearWifeTEC,
              monthDobTEC: monthWifeTEC,
              dayDobTEC: dayWifeTEC,
              uiRepository: widget.uiRepository,
              isGetLunarDate: true,
              onMonthSelected: handleMonthWifeDOBSelected,
              focusnodeDay: _dayWifeFocusNode,
              focusnodeYear: _yearWifeFocusNode,
              selectedMonth: selectedMonth,
              isClearMonth: isClearMonth,
              onResetComplete: clearMonthData,
            ),
          ])
        ]));
  }

  Widget _deathInfoArea(BuildContext context) {
    return Visibility(
        visible: widget.importantData.code == 'tang-su',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox( height: 12),
            Text(
              '${'death_time'.tr} (${'solar'.tr})',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextAppStyle().titleStyleLight(),
            ),
            const SizedBox( height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                onTapWidget(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _selectDate(context, 'death');
                  },
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        color:
                            AppColor.blackColor.withAlpha((0.9 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            width: 1,
                            color: is2LightTime
                                ? AppColor.colorRed
                                : AppColor.secondaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            deathDateSelected == ''
                                ? 'dd/MM/yyyy'.tr
                                : deathDateTmp,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: deathDateSelected == ''
                                ? TextAppStyle()
                                    .hintTextGrey()
                                    .copyWith(fontSize: 14)
                                : TextAppStyle().normalTextStyleLight(),
                          ),
                        ),
                        Image.asset(
                          IconConstants.ic_calendar_gradient,
                          width: 24,
                          height: 24,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox( height: 12),
                onTapWidget(
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    _selectTime(context, 'death');
                  },
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        color:
                            AppColor.blackColor.withAlpha((0.9 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            width: 1,
                            color: is2LightTime
                                ? AppColor.colorRed
                                : AppColor.secondaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            deathTimeSelected == '' ? 'HH:mm'.tr : deathTimeTmp,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: deathTimeSelected == ''
                                ? TextAppStyle()
                                    .hintTextGrey()
                                    .copyWith(fontSize: 14)
                                : TextAppStyle().normalTextStyleLight(),
                          ),
                        ),
                        Image.asset(
                          IconConstants.ic_time_gradient,
                          width: 24,
                          height: 24,
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: is2LightDeathDate,
                    child: Text(
                      'death_date_note'.tr,
                      style: TextAppStyle()
                          .normalTextStyleSmall()
                          .copyWith(color: AppColor.colorRedBold),
                    )),
                Visibility(
                    visible: isShowDobNoteSecond && !is2LightDeathDate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox( height: 4),
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              margin: const EdgeInsets.only(top: 8),
                              color: AppColor.secondaryColor
                                  .withAlpha((0.25 * 255).toInt()),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox( width: 12),
                                      Row(
                                        children: [
                                          Text(
                                            '${'lunar'.tr}: ',
                                            style: TextAppStyle()
                                                .normalTextStyleExtraSmallLight(),
                                          ),
                                          Text(
                                            '${'''${lunarDatetimeOthersData?.namCan}'''.tr} ${'''${lunarDatetimeOthersData?.namChi}'''.tr}',
                                            style: TextAppStyle()
                                                .titleStyleSmall()
                                                .copyWith(
                                                    color: AppColor
                                                        .newPrimaryColor2),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 1, left: 6),
                                            child: Image.asset(
                                              getZodiacImage(getZodiacIndex(
                                                  lunarDatetimeOthersData
                                                          ?.namChi ??
                                                      '')),
                                              fit: BoxFit.contain,
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                        ],
                                      )
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
                        )
                      ],
                    )),
              ],
            ),
          ],
        ));
  }

  Widget _personRep(BuildContext context) {
    return Visibility(
      visible: widget.importantData.code == 'sang-cat',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox( height: 16),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 0.5,
                        decoration: const BoxDecoration(
                            gradient:
                                LinearGradient(colors: CommonConstants.name)),
                      ),
                      const SizedBox( width: 4),
                      ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              AppColor.secondaryColor, BlendMode.srcATop),
                          child: Image.asset(
                            IconConstants.ic_dad_avatar,
                            width: 16,
                          )),
                      const SizedBox( width: 4),
                      Text(
                        'person_representation'.tr,
                        style: TextAppStyle().semiBoldTextStyleSmall().copyWith(
                            fontSize: 14, color: AppColor.secondaryColor),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox( height: 12),
              Row(
                children: [
                  Text(
                    '${'day'.tr}/${'month'.tr}/${'dob_year'.tr}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextAppStyle().titleStyleLight(),
                  ),
                  Text(
                    ' (${'solar'.tr})',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextAppStyle().normalTextStyleSmallLight(),
                  ),
                ],
              ),
              const SizedBox( height: 12),
              TextFieldDOBTest(
                type: 'borrow',
                yearDobTEC: yearBorrowTEC,
                monthDobTEC: monthBorrowTEC,
                dayDobTEC: dayBorrowTEC,
                uiRepository: widget.uiRepository,
                isGetLunarDate: true,
                onMonthSelected: handleMonthBorrowDOBSelected,
                focusnodeDay: _dayBorrowFocusNode,
                focusnodeYear: _yearBorrowFocusNode,
                selectedMonth: selectedMonth,
                isClearMonth: isClearMonth,
                onResetComplete: clearMonthData,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _borrowAge(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox( height: 16),
        Visibility(
          visible: selectedValue?.code == 'dong-tho' ||
              (selectedValue?.code ?? '') == 'khoi-cong',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 0.5,
                      decoration: const BoxDecoration(
                          gradient:
                              LinearGradient(colors: CommonConstants.name)),
                    ),
                    const SizedBox( width: 4),
                    ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            AppColor.secondaryColor, BlendMode.srcATop),
                        child: Image.asset(
                          IconConstants.ic_bmb_date_active,
                          width: 16,
                        )),
                    const SizedBox( width: 4),
                    Text(
                      'borrow_age'.tr,
                      style: TextAppStyle().semiBoldTextStyleSmall().copyWith(
                          fontSize: 14, color: AppColor.secondaryColor),
                    ),
                    const SizedBox( width: 8),
                  ],
                ),
              ),
              onTapWidget(
                onTap: () {
                  setState(() {
                    isSelectedBA = !isSelectedBA;
                    if (!isSelectedBA) {
                      invalidYearBorrowTEC = false;
                      setState(() {});
                    }
                  });
                },
                child: Image.asset(
                  isSelectedBA
                      ? IconConstants.ic_tick_active_gradient
                      : IconConstants.ic_tick_inactive_gradient,
                  width: 32,
                  height: 32,
                ),
              )
            ],
          ),
        ),
        Visibility(
            visible: isSelectedBA,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox( height: 12),
                Row(
                  children: [
                    Text(
                      '${'day'.tr}/${'month'.tr}/${'dob_year'.tr}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextAppStyle().titleStyleLight(),
                    ),
                    Text(
                      ' (${'solar'.tr})',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextAppStyle().normalTextStyleSmallLight(),
                    ),
                  ],
                ),
                const SizedBox( height: 8),
                TextFieldDOBTest(
                  type: 'borrow',
                  yearDobTEC: yearBorrowTEC,
                  monthDobTEC: monthBorrowTEC,
                  dayDobTEC: dayBorrowTEC,
                  uiRepository: widget.uiRepository,
                  isGetLunarDate: true,
                  onMonthSelected: handleMonthBorrowDOBSelected,
                  focusnodeDay: _dayBorrowFocusNode,
                  focusnodeYear: _yearBorrowFocusNode,
                  selectedMonth: selectedMonth,
                  isClearMonth: isClearMonth,
                  onResetComplete: clearMonthData,
                ),
              ],
            )),
      ],
    );
  }

  void _showWarningPopupNotEnought18(BuildContext context) {
    showDialog(
        barrierColor: AppColor.blackColor75,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              padding: const EdgeInsets.all(12),
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                border: Border.all(width: 1.5, color: AppColor.secondaryColor),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(ImageConstants.img_bg_result_important),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      IconConstants.ic_warning_date_view,
                      width: widthFlexible(148),
                      height: widthFlexible(148),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: GradientText(
                      'tuoi_muon_is_not_enough_18'.tr,
                      colors: CommonConstants.gradientAccountIcons,
                      textAlign: TextAlign.center,
                      gradientDirection: GradientDirection.ttb,
                      style: TextAppStyle().titleStyleExtraLarge(),
                    ),
                  ),
                  const SizedBox( height: 48),
                  onTapWidget(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: 48,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  ButtonConstants.btn_small_primary_active))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Center(
                        child: Text(
                          'try_again'.tr,
                          style: custom3DTextStyle(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox( height: 12),
                ],
              ),
            ),
          );
        });
  }

  void _showWarningPopup(
      BuildContext context, var data, List<dynamic> yearList) {
    showDialog(
        barrierColor: AppColor.blackColor,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 12),
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Container(
              padding: const EdgeInsets.all(12),
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                border: Border.all(width: 1.5, color: AppColor.secondaryColor),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(ImageConstants.img_bg_result_important),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              IconConstants.ic_warning_date_view,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          data['data']['warning']['tuoiMuon'] == null
                              ? const SizedBox()
                              : data['data']['warning']['tuoiMuon']
                                          ['isXungTuoi'] ==
                                      true
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: GradientText(
                                        '${'borrow_age'.tr} ${'${data['data']['warning']['tuoiMuon']['tuoiMuon']}'.tr} ${'conflict_with_owner_age'.tr.toLowerCase()} ${'${data['data']['warning']['tuoiMuon']['tuoiGiaChu']}'.tr}',
                                        colors: CommonConstants
                                            .gradientAccountIcons,
                                        textAlign: TextAlign.center,
                                        gradientDirection:
                                            GradientDirection.ttb,
                                        style: TextAppStyle().titleStyle(),
                                      ),
                                    )
                                  : const SizedBox(),
                          const SizedBox( height: 16),
                          RichText(
                            text: TextSpan(
                              text: isSelectedBA == true
                                  ? '${'year'.tr} ${yearBorrowTEC.text} '
                                  : '${'year'.tr} ${'${data['data']['warning']['warningContent']['namSinhDuong']}'} ${'duong_lich_short'.tr} (${'${data['data']['warning']['warningContent']['namSinh']}'} ${'am_lich_short'.tr}) ',
                              style: TextAppStyle()
                                  .semiBoldTextStyle()
                                  .copyWith(
                                      fontSize: 14.0,
                                      color: AppColor.primaryColor),
                              children: [
                                TextSpan(
                                    text: isSelectedBA == true
                                        ? 'borrow_age'.tr.toLowerCase()
                                        : 'age'.tr.toLowerCase(),
                                    style: TextAppStyle().thinTextStyleSmall()),
                                TextSpan(
                                    text:
                                        ' ${'${data['data']['warning']['warningContent']['tuoiCanChi']}'.tr} ',
                                    style: TextAppStyle()
                                        .titleStyleSmall()
                                        .copyWith(
                                            color: AppColor.colorGreenDark)),
                                TextSpan(
                                    text: '${'pham'.tr.toLowerCase()}:',
                                    style: TextAppStyle().thinTextStyleSmall()),
                              ],
                            ),
                          ),
                          const SizedBox( height: 8),
                          Column(
                            children: List.generate(
                              data['data']['warning']['warningContent']
                                          ['warningData']
                                      .length ??
                                  0,
                              (idxWarningData) {
                                final warningDataItem = data['data']['warning']
                                        ['warningContent']['warningData']
                                    [idxWarningData];

                                if (warningDataItem == null) {
                                  return const SizedBox();
                                }
                                return Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      border: Border.all(
                                          width: 0.25,
                                          color: AppColor.colorRedBold),
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                          image: AssetImage(ImageConstants
                                              .img_bg_manage_book_expert),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        initiallyExpanded: true,
                                        minTileHeight: 40,
                                        tilePadding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        expandedAlignment: Alignment.centerLeft,
                                        childrenPadding:
                                            const EdgeInsets.fromLTRB(
                                                16, 0, 16, 16),
                                        collapsedIconColor:
                                            AppColor.colorRedBold,
                                        iconColor: AppColor.grayTextwhiteColor,
                                        title: Text(
                                          '${'year'.tr} ${warningDataItem['year']} ${'pham'.tr}:',
                                          style: TextAppStyle()
                                              .semiBoldTextStyleSmall()
                                              .copyWith(
                                                  color: AppColor.colorRedBold),
                                        ),
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 24, top: 0),
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                    width: 0.5,
                                                    color: AppColor.colorRedBold
                                                        .withAlpha((0.5 * 255)
                                                            .toInt()),
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  warningDataItem['kimlau'] ==
                                                          true
                                                      ? Text(
                                                          '• ${'kim_lau'.tr}: ${'${warningDataItem['details']['kimLau'] ?? ''}'.tr}',
                                                          style: TextAppStyle()
                                                              .normalTextStyleSmall()
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .colorRedBold))
                                                      : const SizedBox(),
                                                  if (warningDataItem[
                                                              'hoangOc'] ==
                                                          true &&
                                                      warningDataItem[
                                                              'kimlau'] ==
                                                          true)
                                                    const SizedBox( height: 8),
                                                  warningDataItem['hoangOc'] ==
                                                          true
                                                      ? Text(
                                                          '• ${'hoang_oc'.tr}: ${'${warningDataItem['details']['hoangOc'] ?? ''}'.tr}',
                                                          style: TextAppStyle()
                                                              .normalTextStyleSmall()
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .colorRedBold))
                                                      : const SizedBox(),
                                                  if (warningDataItem[
                                                          'tamTai'] ==
                                                      true)
                                                    const SizedBox( height: 8),
                                                  warningDataItem['tamTai'] ==
                                                          true
                                                      ? Text(
                                                          '• ${'tam_tai'.tr}',
                                                          style: TextAppStyle()
                                                              .normalTextStyleSmall()
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .colorRedBold))
                                                      : const SizedBox(),
                                                  if (warningDataItem[
                                                          'thaiTue'] ==
                                                      true)
                                                    if (warningDataItem[
                                                            'thaiTue'] ==
                                                        true)
                                                      const SizedBox( height: 8),
                                                  warningDataItem['thaiTue'] ==
                                                          true
                                                      ? Text(
                                                          '• ${'thai_tue'.tr}',
                                                          style: TextAppStyle()
                                                              .normalTextStyle()
                                                              .copyWith(
                                                                  color: AppColor
                                                                      .colorRedBold))
                                                      : const SizedBox(),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  yearList.isEmpty
                      ? const SizedBox()
                      : Row(
                          children: [
                            Text(
                              'maybe_borrow_age'.tr,
                              textAlign: TextAlign.left,
                              style: TextAppStyle().semiBoldTextStyleSmall(),
                            ),
                          ],
                        ),
                  yearList.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  FrameConstants.fr_empty_search,
                                  width: MediaQuery.of(context).size.width > 500
                                      ? getResponsiveWidth(context) / 4
                                      : getResponsiveWidth(context) / 3.5,
                                  height:
                                      MediaQuery.of(context).size.width > 500
                                          ? getResponsiveWidth(context) / 4
                                          : getResponsiveWidth(context) / 3.5,
                                ),
                                const SizedBox( height: 8),
                                Text(
                                  'not_have_borrow_age'.tr,
                                  style: TextAppStyle()
                                      .semiBoldTextStyleSmall()
                                      .copyWith(fontStyle: FontStyle.normal),
                                ),
                                const SizedBox( height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child: Text(
                                    'note_borrow_age_find'.tr,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextAppStyle()
                                        .thinTextStyleExtraSmall()
                                        .copyWith(
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: RawScrollbar(
                              thumbColor: AppColor.borderYellow,
                              radius: const Radius.circular(100),
                              thickness: 2,
                              child: SizedBox(
                                width: Get.width,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox( height: 8),
                                      Column(
                                        children: List.generate(
                                          yearList.length,
                                          (idxYear) {
                                            final yearData = yearList[idxYear];

                                            if (yearData == null) {
                                              return const SizedBox();
                                            }

                                            final dateKey =
                                                yearData['dateKey'] ?? {};
                                            final validYears =
                                                yearData['validYears'] ?? [];

                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 4),
                                              decoration: BoxDecoration(
                                                color: AppColor.whiteColor,
                                                border: Border.all(
                                                    width: 0.25,
                                                    color: AppColor
                                                        .colorGreenDark),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: AssetImage(ImageConstants
                                                      .img_bg_manage_book_expert),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        dividerColor:
                                                            Colors.transparent),
                                                child: ExpansionTile(
                                                  minTileHeight: 40,
                                                  tilePadding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  expandedAlignment:
                                                      Alignment.centerLeft,
                                                  childrenPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 0, 16, 16),
                                                  collapsedIconColor:
                                                      AppColor.colorGreenDark,
                                                  iconColor: AppColor
                                                      .grayTextwhiteColor,
                                                  title: Text(
                                                    '${'day'.tr} ${'${dateKey['day'] ?? ''}/${dateKey['month'] ?? ''}/${dateKey['year'] ?? ''}'.tr} mượn tuổi:',
                                                    style: TextAppStyle()
                                                        .semiBoldTextStyleSmall()
                                                        .copyWith(
                                                            color: AppColor
                                                                .colorGreenDark),
                                                  ),
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 24, top: 0),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                            width: 0.5,
                                                            color: AppColor
                                                                .colorGreenDark
                                                                .withAlpha(
                                                                    (0.75 * 255)
                                                                        .toInt()),
                                                          ),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children:
                                                                List.generate(
                                                              validYears.length,
                                                              (idxValidYear) {
                                                                final validYear =
                                                                    validYears[
                                                                        idxValidYear];

                                                                if (validYear ==
                                                                    null) {
                                                                  return const SizedBox();
                                                                }

                                                                return Text(
                                                                  '• ${'${validYear['canChi'] ?? ''}'.tr} - ${validYear['year'] ?? ''}',
                                                                  style: TextAppStyle()
                                                                      .normalTextStyleSmall()
                                                                      .copyWith(
                                                                          color:
                                                                              AppColor.colorGreenDark),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox( height: 8),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  onTapWidget(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 48,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  ButtonConstants.btn_small_primary_active))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Center(
                        child: Text(
                          'try_again'.tr,
                          style: custom3DTextStyle(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox( height: 12),
                ],
              ),
            ),
          );
        });
  }

  void _showThingList() async {
    FocusScope.of(context).requestFocus(FocusNode());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_controller.hasClients) {
            _controller.jumpToItem(initialIndex);
          }
        });
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(26), topRight: Radius.circular(26)),
              border: Border(
                  top: BorderSide(color: AppColor.newPrimaryColor2, width: 6)),
              image: const DecorationImage(
                  image: AssetImage(ImageConstants.img_bg_mbs_flower),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'select_thing_to_check'.tr,
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
                    )
                  ],
                ),
              ),
              Container(
                height: 0.5,
                width: Get.width - 48,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withAlpha((0.25 * 255).toInt()),
                ),
              ),
              Expanded(
                child: ListWheelScrollView(
                  controller: _controller,
                  magnification: 3,
                  itemExtent: 60.0,
                  diameterRatio: 1.25,
                  perspective: 0.003,
                  physics: const FixedExtentScrollPhysics(),
                  clipBehavior: Clip.none,
                  children: List.generate(
                      lstThing.length,
                      (index) => onTapWidget(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                initialIndex = selectedIndex;

                                if (initSelectedPick == 1) {
                                
                                  selectedDireCoor = null;
                                  nameTEC.clear();
                                  nameWifeTEC.clear();
                                  yearBorrowTEC.clear();
                                  yearDobTEC.clear();
                                  yearDeathTEC.clear();
                                  yearWifeTEC.clear();
                                  monthDobTEC.clear();
                                  monthBorrowTEC.clear();
                                  monthWifeTEC.clear();
                                  isClearMonth = true;
                                  dayBorrowTEC.clear();
                                  dayDobTEC.clear();
                                  dayWifeTEC.clear();
                                  isShowDobNoteSecond = false;
                                  isShowDobNote = false;
                                  codeOfDirect = '';
                                  deathDateSelected = '';
                                  deathDateSelected = '';
                                  isSelectedBA = false;
                                  codeOfDegree = null;

                                  invalidYearDobTEC = false;
                                  invalidYearDeathTEC = false;
                                  invalidYearBorrowTEC = false;
                                  invalidYearWifeTEC = false;
                                  is2LightDireCoor = false;
                                  showClearButtonFullName = false;
                                  deathTimeTmp = '';
                                  deathTimeSelected = '';
                                }
                              });
                              selectedWork = lstThing[index].name ?? '';
                              selectedValue = lstThing[index];
                              is2LightThingToCheck = false;
                              initSelectedPick = 1;
                              Navigator.pop(context);
                              printConsole(
                                  'buildDOBString month: ${monthDobTEC.text}');
                              String day = buildDOBString();
                              printConsole('buildDOBString: $day');
                            },
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                alignment: Alignment.center,
                                margin: selectedIndex == index
                                    ? const EdgeInsets.symmetric(horizontal: 32)
                                    : const EdgeInsets.symmetric(
                                        horizontal: 48),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: selectedIndex == index
                                      ? Border.all(
                                          width: 2,
                                          color: AppColor.borderYellow)
                                      : Border.all(
                                          width: 1,
                                          color: AppColor.grayTextwhiteColor
                                              .withAlpha((0.25 * 255).toInt())),
                                  gradient: selectedIndex == index
                                      ? LinearGradient(
                                          colors: [
                                            AppColor.blackColor
                                                .withAlpha((0.9 * 255).toInt()),
                                            AppColor.blackColor
                                                .withAlpha((0.9 * 255).toInt())
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : LinearGradient(
                                          colors: [
                                            Colors.grey
                                                .withAlpha((0.3 * 255).toInt()),
                                            Colors.grey
                                                .withAlpha((0.3 * 255).toInt())
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: selectedIndex == index
                                      ? [
                                          BoxShadow(
                                            color: AppColor.textGrey
                                                .withAlpha((0.5 * 255).toInt()),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                            offset: const Offset(3, 3),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  lstThing[index].name ?? '',
                                  style: selectedIndex == index
                                      ? TextAppStyle()
                                          .titleStyleLarge()
                                          .copyWith(
                                              color: AppColor.actionTextYellow)
                                      : TextAppStyle()
                                          .normalTextStyle()
                                          .copyWith(
                                            color: AppColor.grayTextBoldColor,
                                          ),
                                )),
                          )),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients) {
          _controller.jumpToItem(initialIndex);
        }
      });
    });
  }
}
