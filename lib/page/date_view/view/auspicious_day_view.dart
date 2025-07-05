// ignore_for_file: prefer_final_fields, unused_field, library_private_types_in_public_api, prefer_is_empty, invalid_use_of_visible_for_testing_member
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_calender/enums/language_name.dart';
import 'package:full_calender/enums/time_zone.dart';
import 'package:full_calender/full_calender.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/colors.dart';
import '../../../constants/common.dart';
import '../../../resource/assets_constant/btn_constant.dart';
import '../../../resource/assets_constant/icon_constants.dart';
import '../../../resource/assets_constant/images_constants.dart';
import '../../../shared/multi_appear_widgets/gradient_border_container.dart';
import '../../../shared/text_style.dart';
import '../../../utils/logic/common_widget.dart';
import '../../../utils/logic/xhero_common_logics.dart';
import 'package:http/http.dart' as http;

import '../components/form_important_day.dart';
import '../components/important_day_lobby.dart';
import '../model/calendar_model.dart';

class AuspicoiusDayScreen extends StatefulWidget {
  // final XheroFetchApiRespository uiRepository;
  final bool isShowBackBtn;
  final String id;
  const AuspicoiusDayScreen({
    super.key,
    // required this.uiRepository,
    required this.isShowBackBtn,
    required this.id,
  });

  @override
  _AuspicoiusDayScreenState createState() => _AuspicoiusDayScreenState();
}

class _AuspicoiusDayScreenState extends State<AuspicoiusDayScreen> {
  //for-api
  List<UpcomingHoliday>? upcomingHolidays = [];
  List<Calendar>? calendar = [];
  String auspiciousDayId = '';
  Timer? _apiTimer;
  DateTime? _currentHour;
  List<int> filteredDayEvents = [];
  List<int> filteredDayPersonEvents = [];
  String timeRequest = '';
  String dayDetailsRequest = '';
  bool isLoadingDetailsOfDay = false;
  bool isLoadingCalendarOfMonth = false;
  List<String> zodiacImages = [];
  Calendar? detailsOfDayModel;
  String formattedDate = '';
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedLunarDate = '';
  String _selectedLunarMonth = '';
  String _selectedLunarYear = '';
  String _selectedLunarZodiacDay = '';
  String _selectedLunarZodiacMonth = '';
  String _selectedLunarZodiacYear = '';
  String lunarDay = '';
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int dayRequest = DateTime.now().day;
  bool _isZodiacDay = false;
  bool _isLeapMonth = false;
  DateTime? selectedDateHeader;
  ScreenshotController screenshotController = ScreenshotController();
  bool isMonthChanged = false;
  int currentYear = int.parse(DateFormat('yyyy').format(DateTime.now()));

  final List<String> monthNames = [
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
  final List<String> weekdays = [
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
    'sun',
  ];
  late List<DateTime> days;
  late Map<DateTime, List<String>> events;
  late int displayMonth;
  late int displayYear;

  Map<DateTime, String> lunarDates = {};
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getLunarHour(
      day: _focusedDay.day,
      month: _focusedDay.month,
      year: _focusedDay.year,
    );
    timeRequest = DateFormat('dd/MM/yyyy').format(_focusedDay);
    setState(() {
      isLoadingDetailsOfDay = true;
    });
    _getCalendar(timeRequest, dayRequest);
    _selectedDay = _focusedDay;
    _initLunarDay();
    displayYear = year;
    days = _generateDays(year, month);
    displayMonth = month;
    _generateLunarDates();
  }

  Future<void> _backToday() async {
    setState(() {
      isMonthChanged = false;
    });
    timeRequest = DateFormat('dd/MM/yyyy').format(_focusedDay);
    _getCalendar(timeRequest, dayRequest);
    _selectedDay = _focusedDay;
    _initLunarDay();
    displayYear = year;
    days = _generateDays(year, month);
    displayMonth = month;
    _generateLunarDates();
    _updateCurrentMonth();
  }

  Future<void> _getCalendar(String time, int dayRequest) async {
    setState(() {
      isLoadingCalendarOfMonth = true;
    });

    final url = Uri.parse(
      'https://apis-dev.xheroapp.com/calendars?date=$time&isOnlyGetDataFromMonthYear=false',
    );

    final response = await http.get(url);
    printConsole('Status code: ${response.statusCode}');
    printConsole('Raw response body: ${response.body}');
    printConsole('URl: _getCalendar');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Dùng fromJson từ model
        final calendarResponse = CalendarResponse.fromJson(jsonResponse);
        printConsole('Parsed JSON: $jsonResponse');
        setState(() {
          upcomingHolidays = calendarResponse.data?.upcomingHolidays ?? [];
          calendar = calendarResponse.data?.calendar ?? [];
          auspiciousDayId = calendarResponse.data?.auspiciousDayId ?? '';
          isLoadingCalendarOfMonth = false;
          calendar?.forEach((element) {
            if (element.isHaveEvents == true) {
              if (year == element.yearSolar) {
                printConsole('mon is $month ======');
                if (month == element.monthSolar) {
                  filteredDayEvents.add(element.daySolar!);
                }
              }
            } else if (element.isHavePersonalEvents == true) {
              if (year == element.yearSolar) {
                if (month == element.monthSolar) {
                  filteredDayPersonEvents.add(element.daySolar!);
                }
              }
            }
          });
        });
        _getDayDetails(dayRequest);
      } catch (e) {
        printConsole('JSON decode error: $e');
      }
    } else {
      printConsole('Lỗi API: ${response.statusCode}');
    }
  }

  Future<void> _reGetCalendar(
    String time,
    int dayRequest,
    int yearRE,
    int monthRE,
  ) async {
    setState(() {
      isLoadingCalendarOfMonth = true;
    });
    printConsole(dayRequest.toString());
    printConsole(yearRE.toString());
    printConsole(monthRE.toString());
    final url = Uri.parse(
      'https://apis-dev.xheroapp.com/calendars?date=$time&isOnlyGetDataFromMonthYear=false',
    );
    final response = await http.get(url);
    printConsole('Status code: ${response.statusCode}');
    printConsole('Raw response body: ${response.body}');
    printConsole('URl: _reGetCalendar');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Dùng fromJson từ model
        final calendarResponse = CalendarResponse.fromJson(jsonResponse);
        printConsole('Parsed JSON: $jsonResponse');
        setState(() {
          upcomingHolidays = calendarResponse.data?.upcomingHolidays ?? [];
          calendar = calendarResponse.data?.calendar ?? [];
          auspiciousDayId = calendarResponse.data?.auspiciousDayId ?? '';
          isLoadingCalendarOfMonth = false;
          calendar?.forEach((element) {
            if (element.isHaveEvents == true) {
              if (year == element.yearSolar) {
                printConsole('mon is $month ======');
                if (month == element.monthSolar) {
                  filteredDayEvents.add(element.daySolar!);
                }
              }
            } else if (element.isHavePersonalEvents == true) {
              if (year == element.yearSolar) {
                if (month == element.monthSolar) {
                  filteredDayPersonEvents.add(element.daySolar!);
                }
              }
            }
          });
        });
        _getDayDetails(dayRequest);
      } catch (e) {
        printConsole('JSON decode error: $e');
      }
    } else {
      printConsole('Lỗi API: ${response.statusCode}');
    }
  }

  Future<void> _getDayDetails(int daySolar) async {
    calendar?.forEach((element) {
      if (element.yearSolar == year) {
        if (element.monthSolar == month) {
          if (element.daySolar == daySolar) {
            detailsOfDayModel = element;

            setState(() {
              isLoadingDetailsOfDay = false;
            });
          } else {}
        } else {}
      } else {}
    });
  }

  String translateZodiacToChinese(String vietnameseZodiac) {
    // Kiểm tra xem cung hoàng đạo tiếng Việt có tồn tại trong map không
    return CommonConstants.vietnameseToChineseZodiac[vietnameseZodiac] ??
        'updating'.tr;
  }

  String translateZodiacToAmerica(String vietnameseZodiac) {
    // Kiểm tra xem cung hoàng đạo tiếng Việt có tồn tại trong map không
    return CommonConstants.vietnameseToUSAZodiac[vietnameseZodiac] ??
        'updating'.tr;
  }

  void _initLunarDay() {
    if ('vi' == 'vi') {
      final lunarDate = FullCalender(
        date: _focusedDay,
        timeZone: (TimeZone.vietnamese.timezone),
      );
      _selectedLunarDate = '${lunarDate.lunarDate.day}';
      _selectedLunarMonth = '${lunarDate.lunarDate.month}';
      _selectedLunarYear = '${lunarDate.lunarDate.year}';
      _selectedLunarZodiacDay = lunarDate.lunarDate.stemBranchOfDay.name(
        LanguageName.vietNam,
      );
      _selectedLunarZodiacMonth = lunarDate.lunarDate.stemBranchOfMonth.name(
        LanguageName.vietNam,
      );
      _selectedLunarZodiacYear = lunarDate.lunarDate.stemBranchOfYear.name(
        LanguageName.vietNam,
      );
      _isZodiacDay = lunarDate.lunarDate.isLuckyDay;
      setState(() {});
    } else if ('' == 'zh') {
      final lunarDate = FullCalender(
        date: _focusedDay,
        timeZone: (TimeZone.vietnamese.timezone),
      );
      _selectedLunarDate = '${lunarDate.lunarDate.day}';
      _selectedLunarMonth = '${lunarDate.lunarDate.month}';
      _selectedLunarYear = '${lunarDate.lunarDate.year}';
      final vietnameseZodiacDay = lunarDate.lunarDate.stemBranchOfDay.name(
        LanguageName.vietNam,
      );
      final vietnameseZodiacMonth = lunarDate.lunarDate.stemBranchOfMonth.name(
        LanguageName.vietNam,
      );
      final vietnameseZodiacYear = lunarDate.lunarDate.stemBranchOfYear.name(
        LanguageName.vietNam,
      );
      _isZodiacDay = lunarDate.lunarDate.isLuckyDay;
      _selectedLunarZodiacDay = translateZodiacToChinese(vietnameseZodiacDay);
      _selectedLunarZodiacMonth = translateZodiacToChinese(
        vietnameseZodiacMonth,
      );
      _selectedLunarZodiacYear = translateZodiacToChinese(vietnameseZodiacYear);
      setState(() {});
    } else if ('' == 'en') {
      final lunarDate = FullCalender(
        date: _focusedDay,
        timeZone: (TimeZone.vietnamese.timezone),
      );
      _selectedLunarDate = '${lunarDate.lunarDate.day}';
      _selectedLunarMonth = '${lunarDate.lunarDate.month}';
      _selectedLunarYear = '${lunarDate.lunarDate.year}';
      final vietnameseZodiacDay = lunarDate.lunarDate.stemBranchOfDay.name(
        LanguageName.vietNam,
      );
      final vietnameseZodiacMonth = lunarDate.lunarDate.stemBranchOfMonth.name(
        LanguageName.vietNam,
      );
      final vietnameseZodiacYear = lunarDate.lunarDate.stemBranchOfYear.name(
        LanguageName.vietNam,
      );
      _isZodiacDay = lunarDate.lunarDate.isLuckyDay;
      _selectedLunarZodiacDay = translateZodiacToAmerica(vietnameseZodiacDay);
      _selectedLunarZodiacMonth = translateZodiacToAmerica(
        vietnameseZodiacMonth,
      );
      _selectedLunarZodiacYear = translateZodiacToAmerica(vietnameseZodiacYear);
      setState(() {});
    }
  }

  void _refreshLunarDay(int year, int month, int day) {
    printConsole('$day/$month/$year');
    final lunarDate = FullCalender(
      date: DateTime(year, month, day),
      timeZone: (TimeZone.vietnamese.timezone),
    );
    printConsole('${lunarDate.lunarDate.day}');
    printConsole('${lunarDate.lunarDate.month}');
    printConsole('${lunarDate.lunarDate.year}');
    _selectedLunarDate = '${lunarDate.lunarDate.day}';
    _selectedLunarMonth = '${lunarDate.lunarDate.month}';
    _selectedLunarYear = '${lunarDate.lunarDate.year}';
    if ('vi' == 'vi') {
      _selectedLunarZodiacDay = lunarDate.lunarDate.stemBranchOfDay.name(
        LanguageName.vietNam,
      );
      _selectedLunarZodiacMonth = lunarDate.lunarDate.stemBranchOfMonth.name(
        LanguageName.vietNam,
      );
      _selectedLunarZodiacYear = lunarDate.lunarDate.stemBranchOfYear.name(
        LanguageName.vietNam,
      );
    } else if ('' == 'zh') {
      final vietnameseZodiacDay = lunarDate.lunarDate.stemBranchOfDay.name(
        LanguageName.vietNam,
      );
      final vietnameseZodiacMonth = lunarDate.lunarDate.stemBranchOfMonth.name(
        LanguageName.vietNam,
      );
      final vietnameseZodiacYear = lunarDate.lunarDate.stemBranchOfYear.name(
        LanguageName.vietNam,
      );
      _isZodiacDay = lunarDate.lunarDate.isLuckyDay;
      _selectedLunarZodiacDay = translateZodiacToChinese(vietnameseZodiacDay);
      _selectedLunarZodiacMonth = translateZodiacToChinese(
        vietnameseZodiacMonth,
      );
      _selectedLunarZodiacYear = translateZodiacToChinese(vietnameseZodiacYear);
    } else if ('' == 'en') {
      final vietnameseZodiacDay = lunarDate.lunarDate.stemBranchOfDay.name(
        LanguageName.vietNam,
      );
      final vietnameseZodiacMonth = lunarDate.lunarDate.stemBranchOfMonth.name(
        LanguageName.vietNam,
      );
      final vietnameseZodiacYear = lunarDate.lunarDate.stemBranchOfYear.name(
        LanguageName.vietNam,
      );
      _isZodiacDay = lunarDate.lunarDate.isLuckyDay;
      _selectedLunarZodiacDay = translateZodiacToAmerica(vietnameseZodiacDay);
      _selectedLunarZodiacMonth = translateZodiacToAmerica(
        vietnameseZodiacMonth,
      );
      _selectedLunarZodiacYear = translateZodiacToAmerica(vietnameseZodiacYear);
    }
    _isZodiacDay = lunarDate.lunarDate.isLuckyDay;
    setState(() {});
  }

  List<DateTime> _generateDays(int year, int month) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    int daysInMonth = DateTime(year, month + 1, 0).day;
    List<DateTime> days = List.generate(daysInMonth, (index) {
      return DateTime(year, month, index + 1);
    });
    int firstWeekday = firstDayOfMonth.weekday;
    for (int i = 1; i < firstWeekday; i++) {
      days.insert(0, firstDayOfMonth.subtract(Duration(days: i)));
    }
    int lastWeekday = DateTime(year, month, daysInMonth).weekday;
    for (int i = 1; i <= 7 - lastWeekday; i++) {
      days.add(DateTime(year, month, daysInMonth + i));
    }
    return days;
  }

  void _generateLunarDates() {
    List<DateTime> allOfDays = _generateDays(year, month);
    for (var day in allOfDays) {
      final lunarDate = FullCalender(
        date: day,
        timeZone: (TimeZone.vietnamese.timezone),
      );
      String lunarDay = '${lunarDate.lunarDate.day}';
      String lunarMonth = '${lunarDate.lunarDate.month}';

      // Kiểm tra nếu là tháng nhuận
      if (lunarDate.lunarDate.isLeap) {
        if (lunarDate.lunarDate.day == 1) {
          _isLeapMonth = true;

          lunarDates[day] = '$lunarDay/$lunarMonth(N)'; // Tháng nhuận, ngày 1
        } else {
          lunarDates[day] = lunarDay; // Chỉ ghi ngày
          _isLeapMonth = false;
        }
      } else {
        if (lunarDate.lunarDate.day == 1) {
          lunarDates[day] = '$lunarDay/$lunarMonth'; // Tháng thường, ngày 1
        } else {
          lunarDates[day] = lunarDay; // Chỉ ghi ngày
        }
      }
    }

    setState(() {});
  }

  void _reGenerateLunarDates(int yearRE, int monthRE) {
    List<DateTime> allOfDays = _generateDays(yearRE, monthRE);
    for (var day in allOfDays) {
      final lunarDate = FullCalender(
        date: day,
        timeZone: (TimeZone.vietnamese.timezone),
      );
      if (lunarDate.lunarDate.day == 1) {
        lunarDates[day] =
            '${lunarDate.lunarDate.day}/${lunarDate.lunarDate.month}'; // Thêm cả tháng âm lịch
      } else {
        lunarDates[day] = '${lunarDate.lunarDate.day}'; // Chỉ thêm ngày âm lịch
      }
    }
    setState(() {});
  }

  bool isImportantHoliday(int day) {
    return filteredDayEvents.contains(day);
  }

  bool isPersonalEvents(int day) {
    return filteredDayPersonEvents.contains(day);
  }

  void _updateCurrentMonth() {
    filteredDayEvents.clear();
    filteredDayPersonEvents.clear();
    setState(() {
      // selectedDateHeader = null;
      displayMonth = _focusedDay.month;
      dayRequest = _selectedDay?.day ?? 1;
      displayYear = _focusedDay.year;
      month = displayMonth;
      year = displayYear;
      _getCalendar('1/$month/$year', dayRequest);
      _refreshLunarDay(year, month, dayRequest);
      _generateLunarDates();
      days = _generateDays(displayYear, displayMonth);
    });
  }

  void _updateMonth(int change) {
    if (isLoadingCalendarOfMonth) {
      Fluttertoast.showToast(
        msg: 'wait_a_sec'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.actionTextYellow,
        textColor: AppColor.secondaryColor,
        fontSize: 16.0,
      );
      return;
    }

    filteredDayPersonEvents.clear();
    filteredDayEvents.clear();

    setState(() {
      int previousMonth = displayMonth;
      int previousYear = displayYear;

      displayMonth += change;
      dayRequest = _selectedDay?.day ?? 1;

      // Xử lý chuyển năm khi cần thiết
      if (displayMonth < 1) {
        displayMonth = 12;
        displayYear -= 1;
        month = displayMonth;
        year = displayYear;
      } else if (displayMonth > 12) {
        displayMonth = 1;
        displayYear += 1;
        month = displayMonth;
        year = displayYear;
      } else {
        month = displayMonth;
        year = displayYear;
      }

      // Kiểm tra xem tháng hoặc năm có thay đổi không
      isMonthChanged =
          (displayMonth != previousMonth || displayYear != previousYear);

      printConsole('Month changed: $isMonthChanged');
      printConsole('Get calendar for new month: $month/$year');
      printConsole('The day to show details is ${_selectedDay?.day}');

      // Cập nhật dữ liệu nếu có thay đổi tháng/năm
      if (isMonthChanged) {
        getLunarHour(day: dayRequest, month: month, year: year);
        _getCalendar('1/$month/$year', dayRequest);
        // _refreshLunarDay(year, month, dayRequest);
        _generateLunarDates();
      }

      days = _generateDays(displayYear, displayMonth);
    });
  }

  Map<String, dynamic>? _apiResponse;
  bool _isLoading = false;
  Future<void> getLunarHour({
    required int day,
    required int month,
    required int year,
  }) async {
    final now = DateTime.now();
    final date =
        '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
    final hour = now.hour;

    final url = Uri.parse(
      'https://apis-dev.xheroapp.com/calendars/can-chi-hour?date=$date&hour=$hour',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _apiResponse = json.decode(response.body);
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load API data');
      }
    } catch (e) {
      printConsole('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _apiTimer?.cancel(); // Cancel the timer in dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        frameCommonWidget(
          background: 'assets/background.png',
          isShowAction:
              (_selectedDay!.day) != (_focusedDay.day) ||
              (_selectedDay!.month) != (_focusedDay.month) ||
              (_selectedDay!.year) != (_focusedDay.year) ||
              isMonthChanged,
          isHiddenBack: !widget.isShowBackBtn,
          action: onTapWidget(
            onTap: _backToday,
            child: Container(
              width: 52,
              padding: const EdgeInsets.only(bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    IconConstants.ic_refresh_today,
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: CustomRefreshIndicator(
                  builder: MaterialIndicatorDelegate(
                    builder: (context, controller) {
                      return Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColor.transparentColor,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(IconConstants.ic_bmb_center_active),
                      );
                    },
                  ).call,
                  onRefresh: () async {
                    _isLoading = true;
                    getLunarHour(
                      day: _focusedDay.day,
                      month: _focusedDay.month,
                      year: _focusedDay.year,
                    );
                    timeRequest = DateFormat('dd/MM/yyyy').format(_focusedDay);
                    setState(() {
                      isLoadingDetailsOfDay = true;
                    });
                    _getCalendar(timeRequest, dayRequest);
                    _selectedDay = _focusedDay;
                    _initLunarDay();
                    displayYear = year;
                    days = _generateDays(year, month);
                    displayMonth = month;
                    _generateLunarDates();
                  },
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: 120,
                      left: 24,
                      right: 24,
                      bottom: 100,
                    ),
                    child: SizedBox(
                      width: getResponsiveWidth(context),
                      child: Get.width > 1024
                          ? Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _calendarByMonth(context)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          _calendartByDay(context),
                                          const SizedBox(height: 12),
                                          _ageByDayAndMonth(context),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible:
                                      (detailsOfDayModel?.isHaveEvents ??
                                          false) ||
                                      (detailsOfDayModel
                                              ?.isHavePersonalEvents ??
                                          false),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      _eventsInDay(context),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      detailsOfDayModel
                                          ?.incenseAndLamps
                                          ?.isNotEmpty ??
                                      false,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      _incenseAndLamps(context),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 12),
                                _zodiacTimes(context),
                                const SizedBox(height: 12),
                                _upcomingEvents(context),
                              ],
                            )
                          : Column(
                              children: [
                                const SizedBox(height: 12),
                                _calendarByMonth(context),
                                const SizedBox(height: 12),
                                _calendartByDay(context),
                                Visibility(
                                  visible:
                                      (detailsOfDayModel?.isHaveEvents ??
                                          false) ||
                                      (detailsOfDayModel
                                              ?.isHavePersonalEvents ??
                                          false),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      _eventsInDay(context),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      detailsOfDayModel
                                          ?.incenseAndLamps
                                          ?.isNotEmpty ??
                                      false,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      _incenseAndLamps(context),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _zodiacTimes(context),
                                const SizedBox(height: 12),
                                _ageByDayAndMonth(context),
                                const SizedBox(height: 12),
                                _upcomingEvents(context),
                                widget.isShowBackBtn
                                    ? const SizedBox(height: 100)
                                    : const SizedBox(height: 168),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          titleAppbar: 'date_view'.tr,
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.width > 500
              ? (widget.isShowBackBtn ? 32 : 116)
              : (widget.isShowBackBtn ? 28 : 110),
          right: 24,
          child: onTapWidget(
            onTap: () {
              Get.to(() => CheckingTheDayScreen(
                                  id: '665ea8195ea03b2014cb5ec7',
                                ));
            },
            child: Center(
              child: Row(
                children: [
                  Image.asset(IconConstants.ic_auspicious_home_menu, width: 48),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _actionsHeader(BuildContext context) {
    return Container(
      width: Get.width * 0.3,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: isLoadingDetailsOfDay
          ? SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width > 500
                            ? (isSamsungZFold(context) ? 60 : 80)
                            : 60,
                        width: Get.width * 0.3,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: MediaQuery.of(context).size.width > 500
                                ? (isSamsungZFold(context) ? 60 : 80)
                                : 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        top: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width > 500
                                      ? (isSamsungZFold(context) ? 54 : 76)
                                      : 54,
                                  width: MediaQuery.of(context).size.width > 500
                                      ? (isSamsungZFold(context) ? 54 : 76)
                                      : 54,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width > 500
                                        ? (isSamsungZFold(context) ? 20 : 32)
                                        : 20,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width > 500
                                        ? (isSamsungZFold(context) ? 20 : 32)
                                        : 20,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
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
                    ],
                  ),
                ],
              ),
            )
          : onTapWidget(
              onTap: () {
                // if (index == 1) {
                //   if (AppDataGlobal.IS_SIGNED_IN ?? false) {
                //     Get.to(() => CheckingTheDayScreen(
                //           uiRepository: widget.uiRepository,
                //           id: auspiciousDayId == ''
                //               ? widget.id
                //               : auspiciousDayId,
                //         ));
                //   } else {
                //     AppDataGlobal.activeIdxBMB.value = 0;
                //     ToastUtil.showSignInRequiredToast();
                //     Get.toNamed(Routes.SIGNIN);
                //   }
                // } else {
                //   if (AppDataGlobal.IS_SIGNED_IN ?? false) {
                //     Get.to(
                //       () => BookExpertScreen(
                //           uiRepository: widget.uiRepository),
                //     );
                //   } else {
                //     AppDataGlobal.isRouteToContact = true;
                //     ToastUtil.showSignInRequiredToast();
                //     Get.toNamed(Routes.SIGNIN);
                //     return;
                //   }
                //   return;
                // }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    height: MediaQuery.of(context).size.width > 500
                        ? (isSamsungZFold(context) ? 60 : 80)
                        : 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          ButtonConstants.btn_calendar_actions_gradient,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ).copyWith(right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            IconConstants.ic_check_date,
                            height: MediaQuery.of(context).size.width > 500
                                ? (isSamsungZFold(context) ? 40 : 60)
                                : 40,
                            width: MediaQuery.of(context).size.width > 500
                                ? (isSamsungZFold(context) ? 40 : 60)
                                : 40,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Stack(
                              children: [
                                // Viền ngoài (Text border)
                                Text(
                                  MediaQuery.of(context).size.width > 500
                                      ? 'check_date'.tr.replaceAll('\n', ' ')
                                      : 'check_date'.tr,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: optimizedSize(
                                      phone: 15,
                                      zfold: 16,
                                      tablet: 18,
                                      context: context,
                                    ),
                                    fontFamily: CommonConstants.extrabold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth =
                                          3 // Độ dày viền
                                      ..color =
                                          AppColor.textBrownColor, // Màu viền
                                  ),
                                ),
                                // Văn bản chính (Text nội dung)
                                Text(
                                  MediaQuery.of(context).size.width > 500
                                      ? 'check_date'.tr.replaceAll('\n', ' ')
                                      : 'check_date'.tr,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: optimizedSize(
                                      phone: 15,
                                      zfold: 16,
                                      tablet: 18,
                                      context: context,
                                    ),
                                    fontFamily: CommonConstants.extrabold,
                                    color: AppColor.yellowLight, // Màu văn bản
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _calendarByMonth(BuildContext context) {
    DateTime today = DateTime.now();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: EdgeInsets.all(
        optimizedSize(phone: 2, zfold: 2, tablet: 2, context: context),
      ),
      decoration: BoxDecoration(
        border: const GradientBoxBorder(
          gradient: LinearGradient(colors: CommonConstants.button),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage(ImageConstants.img_bg_calendar),
          fit: BoxFit.cover,
        ),
        color: AppColor.whiteColor,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: MediaQuery.of(context).size.width > 500
                        ? const EdgeInsets.only(top: 24)
                        : const EdgeInsets.only(bottom: 12),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageConstants.img_bg_dainam_trans),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: AppColor.whiteColor.withAlpha((0.45 * 255).toInt()),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min, // Minimize the height of the column
            children: [
              Container(
                height: MediaQuery.of(context).size.width > 500
                    ? (isSamsungZFold(context) ? 50 : 60)
                    : 40,
                padding: EdgeInsets.only(
                  top: optimizedSize(
                    phone: 12,
                    zfold: 12,
                    tablet: 16,
                    context: context,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColor.primaryColor,
                        size: MediaQuery.of(context).size.width > 500 ? 24 : 20,
                      ),
                      onPressed: () {
                        _updateMonth(-1);
                      },
                    ),
                    onTapWidget(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Text(
                        '${monthNames[displayMonth - 1].tr}, $displayYear',
                        style: TextAppStyle().titleStyleExtraLarge().copyWith(
                          fontSize: MediaQuery.of(context).size.width > 500
                              ? (isSamsungZFold(context) ? 20 : 22)
                              : 18,
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColor.primaryColor,
                        size: MediaQuery.of(context).size.width > 500 ? 24 : 20,
                      ),
                      onPressed: () {
                        _updateMonth(1);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 0, bottom: 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 0.25,
                          color: AppColor.grayTextwhiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Image.asset(
                          ImageConstants.img_bg_dainam_trans,
                          width: 24,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 0.25,
                          color: AppColor.grayTextwhiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // SizedBox(
              //   width: getResponsiveWidth(context) - 48,
              //   child: DashedDivider(
              //       dashSpace: 5,
              //       dashWidth: 5,
              //       height: 0.75,
              //       color: AppColor.grayTextwhiteColor),
              // ),
              // Container(
              //   height: 0.5,

              //   decoration: BoxDecoration(
              //       color: AppColor.primaryColor.withAlpha((0.75 * 255).toInt())),
              // ),
              Container(
                width: optimizedSize(
                  phone: getResponsiveWidth(context) - 48,
                  zfold: 480,
                  tablet: 480 + 54,
                  context: context,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekdays.map((day) {
                    return Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: optimizedSize(
                            phone: 8,
                            zfold: 10,
                            tablet: 12,
                            context: context,
                          ),
                          horizontal: 0,
                        ),
                        child: Text(
                          day.tr,
                          textAlign: TextAlign.center,
                          style: TextAppStyle().titleStyle().copyWith(
                            fontSize: optimizedSize(
                              phone: 16,
                              zfold: 18,
                              tablet: 20,
                              context: context,
                            ),
                            color: day == 'sun'
                                ? AppColor.colorRedBold
                                : AppColor.primaryColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                // color: AppColor.colorBlueDark,
                width: optimizedSize(
                  phone: getResponsiveWidth(context) - 48,
                  zfold: 448,
                  tablet: 480 + 54,
                  context: context,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 7 days in a week
                  ),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    DateTime day = days[index];
                    bool isCurrentMonth = day.month == month;
                    bool isToday =
                        day.year == today.year &&
                        day.month == today.month &&
                        day.day == today.day;
                    bool isSunday = day.weekday == DateTime.sunday;
                    bool isSelected =
                        _selectedDay != null && _selectedDay == day;
                    lunarDay = lunarDates[day] ?? '';
                    final lunarDate = FullCalender(
                      date: day,
                      timeZone: (TimeZone.vietnamese.timezone),
                    );
                    final isLuckyDay = lunarDate.lunarDate.isLuckyDay;
                    final isUnluckyDay = !lunarDate.lunarDate.isLuckyDay;
                    return GestureDetector(
                      onTap: () {
                        if (isCurrentMonth) {
                          _getDayDetails(day.day);
                          setState(() {
                            _selectedDay = day;
                            _selectedLunarDate = '${lunarDate.lunarDate.day}';
                            _selectedLunarMonth =
                                '${lunarDate.lunarDate.month}';
                            _selectedLunarYear = '${lunarDate.lunarDate.year}';
                            if ('vi' == 'vi') {
                              _selectedLunarZodiacDay = lunarDate
                                  .lunarDate
                                  .stemBranchOfDay
                                  .name(LanguageName.vietNam);
                              _selectedLunarZodiacMonth = lunarDate
                                  .lunarDate
                                  .stemBranchOfMonth
                                  .name(LanguageName.vietNam);
                              _selectedLunarZodiacYear = lunarDate
                                  .lunarDate
                                  .stemBranchOfYear
                                  .name(LanguageName.vietNam);
                            } else if ('' == 'zh') {
                              final vietnameseZodiacDay = lunarDate
                                  .lunarDate
                                  .stemBranchOfDay
                                  .name(LanguageName.vietNam);
                              final vietnameseZodiacMonth = lunarDate
                                  .lunarDate
                                  .stemBranchOfMonth
                                  .name(LanguageName.vietNam);
                              final vietnameseZodiacYear = lunarDate
                                  .lunarDate
                                  .stemBranchOfYear
                                  .name(LanguageName.vietNam);
                              _isZodiacDay = lunarDate.lunarDate.isLuckyDay;
                              _selectedLunarZodiacDay =
                                  translateZodiacToChinese(vietnameseZodiacDay);
                              _selectedLunarZodiacMonth =
                                  translateZodiacToChinese(
                                    vietnameseZodiacMonth,
                                  );
                              _selectedLunarZodiacYear =
                                  translateZodiacToChinese(
                                    vietnameseZodiacYear,
                                  );
                            } else if ('' == 'en') {
                              final vietnameseZodiacDay = lunarDate
                                  .lunarDate
                                  .stemBranchOfDay
                                  .name(LanguageName.vietNam);
                              final vietnameseZodiacMonth = lunarDate
                                  .lunarDate
                                  .stemBranchOfMonth
                                  .name(LanguageName.vietNam);
                              final vietnameseZodiacYear = lunarDate
                                  .lunarDate
                                  .stemBranchOfYear
                                  .name(LanguageName.vietNam);
                              _isZodiacDay = lunarDate.lunarDate.isLuckyDay;
                              _selectedLunarZodiacDay =
                                  translateZodiacToAmerica(vietnameseZodiacDay);
                              _selectedLunarZodiacMonth =
                                  translateZodiacToAmerica(
                                    vietnameseZodiacMonth,
                                  );
                              _selectedLunarZodiacYear =
                                  translateZodiacToAmerica(
                                    vietnameseZodiacYear,
                                  );
                            }
                            _isZodiacDay = lunarDate.lunarDate.isLuckyDay;
                            getLunarHour(
                              day: _selectedDay?.day ?? 1,
                              month: _selectedDay?.month ?? 1,
                              year: _selectedDay?.year ?? currentYear,
                            );

                            if (lunarDate.lunarDate.isLeap) {
                              _isLeapMonth = true;
                            } else {
                              _isLeapMonth = false;
                            }
                          });
                        } else {
                          if (day.year < year ||
                              (day.year == year && day.month < month)) {
                            printConsole('case 1:');
                            filteredDayPersonEvents.clear();
                            filteredDayEvents.clear();
                            setState(() {
                              filteredDayEvents.clear();
                              isLoadingDetailsOfDay = true;
                              _selectedDay = day;
                              lunarDay = lunarDates[_selectedDay] ?? '';

                              if (day.year < year) {
                                displayYear -= 1;
                                displayMonth = 12;
                                month = 12;
                                year = displayYear;

                                _refreshLunarDay(
                                  year,
                                  month,
                                  _selectedDay?.day ?? dayRequest,
                                );
                                _generateLunarDates();

                                days = _generateDays(displayYear, displayMonth);
                                _reGetCalendar(
                                  '$day/$month/$year',
                                  _selectedDay?.day ?? 1,
                                  year,
                                  month,
                                );
                                _getDayDetails(_selectedDay?.day ?? 1);
                                getLunarHour(
                                  day: _selectedDay?.day ?? dayRequest,
                                  month: month,
                                  year: year,
                                );
                              } else {
                                printConsole('222222222222222');

                                setState(() {
                                  displayMonth -= 1; // Giảm tháng đi 1
                                  month = displayMonth;
                                  year = displayYear;

                                  _refreshLunarDay(
                                    year,
                                    month,
                                    _selectedDay?.day ?? dayRequest,
                                  );
                                  _generateLunarDates();

                                  // Tạo lại danh sách ngày trong tháng mới
                                  days = _generateDays(
                                    displayYear,
                                    displayMonth,
                                  );
                                  _reGetCalendar(
                                    '$day/$month/$year',
                                    _selectedDay?.day ?? 1,
                                    year,
                                    month,
                                  );
                                  _getDayDetails(_selectedDay?.day ?? 1);
                                  getLunarHour(
                                    day: _selectedDay?.day ?? dayRequest,
                                    month: month,
                                    year: year,
                                  );
                                });
                              }
                            });
                          } else if (day.year > year ||
                              (day.year == year && day.month > month)) {
                            printConsole('case 2:');

                            filteredDayPersonEvents.clear();
                            filteredDayEvents.clear();

                            setState(() {
                              isLoadingDetailsOfDay = true;
                              _selectedDay = day;

                              if (day.year > year) {
                                printConsole('case 2.1:');

                                displayYear += 1;
                                displayMonth = 1;
                                month = 1;
                                year = displayYear;

                                _refreshLunarDay(
                                  year,
                                  month,
                                  _selectedDay?.day ?? dayRequest,
                                );

                                _generateLunarDates();
                                days = _generateDays(displayYear, displayMonth);
                                _reGetCalendar(
                                  '$day/$month/$year',
                                  _selectedDay?.day ?? 1,
                                  year,
                                  month,
                                );
                                _getDayDetails(_selectedDay?.day ?? 1);
                                getLunarHour(
                                  day: _selectedDay?.day ?? dayRequest,
                                  month: month,
                                  year: year,
                                );
                              } else {
                                printConsole('case 2.2:');

                                setState(() {
                                  displayMonth += 1; // Tăng tháng lên 1
                                  month = displayMonth;
                                  year = displayYear;
                                  printConsole(
                                    '${_selectedDay?.day ?? dayRequest}/$month/$year',
                                  );
                                  _refreshLunarDay(
                                    year,
                                    month,
                                    _selectedDay?.day ?? dayRequest,
                                  );
                                  _generateLunarDates();

                                  days = _generateDays(
                                    displayYear,
                                    displayMonth,
                                  );
                                  _reGetCalendar(
                                    '${_selectedDay?.day}/$month/$year',
                                    _selectedDay?.day ?? 1,
                                    year,
                                    month,
                                  );
                                  _getDayDetails(_selectedDay?.day ?? 1);
                                  getLunarHour(
                                    day: _selectedDay?.day ?? dayRequest,
                                    month: month,
                                    year: year,
                                  );
                                });
                              }
                            });
                          } else {
                            printConsole('case 3:');

                            // Trường hợp ngày thuộc tháng hiện tại
                            setState(() {
                              isLoadingDetailsOfDay = true;
                              _selectedDay = day;
                              // Không cần thay đổi tháng nếu ngày đã chọn nằm trong tháng hiện tại
                            });
                          }
                        }
                      },
                      child: isToday
                          ? GradientBorderContainer(
                              lstColor: CommonConstants.button,
                              margin: const EdgeInsets.all(1),
                              padding: const EdgeInsets.all(0.5),
                              radius: 7,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.colorGreenDark,
                                      AppColor.colorGreen,
                                      // const Color.fromARGB(
                                      //     255, 27, 224, 34),
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.center,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${day.day}',
                                              style: TextAppStyle()
                                                  .titleStyle()
                                                  .copyWith(
                                                    fontSize: optimizedSize(
                                                      phone:
                                                          MediaQuery.of(
                                                                context,
                                                              ).size.width >
                                                              395
                                                          ? 17
                                                          : 16,
                                                      zfold: 18,
                                                      tablet: 20,
                                                      context: context,
                                                    ),
                                                    color: isCurrentMonth
                                                        ? (isToday
                                                              ? AppColor
                                                                    .secondaryColor
                                                              : isSunday
                                                              ? AppColor
                                                                    .colorRedBold
                                                              : AppColor
                                                                    .secondaryColor)
                                                        : AppColor
                                                              .secondaryColor,
                                                  ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 2,
                                            ),
                                            margin: const EdgeInsets.only(
                                              bottom: 2,
                                            ),
                                            child: Text(
                                              lunarDay,
                                              style: TextAppStyle()
                                                  .normalTextStyleExtraSmall()
                                                  .copyWith(
                                                    fontSize: optimizedSize(
                                                      phone: 12,
                                                      zfold: 12.95,
                                                      tablet: 16,
                                                      context: context,
                                                    ),
                                                    color:
                                                        AppColor.secondaryColor,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isLuckyDay ||
                                        isUnluckyDay ||
                                        isImportantHoliday(day.day) &&
                                            isCurrentMonth)
                                      Positioned(
                                        right: 2,
                                        top: 2,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isLuckyDay)
                                              Container(
                                                width: optimizedSize(
                                                  phone: 5,
                                                  zfold: 6,
                                                  tablet: 8,
                                                  context: context,
                                                ),
                                                height: optimizedSize(
                                                  phone: 5,
                                                  zfold: 6,
                                                  tablet: 8,
                                                  context: context,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  bottom: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColor.newPrimaryColor1,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            if (isUnluckyDay && isCurrentMonth)
                                              Container(
                                                width: optimizedSize(
                                                  phone: 5,
                                                  zfold: 6,
                                                  tablet: 8,
                                                  context: context,
                                                ),
                                                height: optimizedSize(
                                                  phone: 5,
                                                  zfold: 6,
                                                  tablet: 8,
                                                  context: context,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  bottom: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColor.dotBlackDay,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            if (isImportantHoliday(day.day) &&
                                                isCurrentMonth)
                                              Container(
                                                width: optimizedSize(
                                                  phone: 5,
                                                  zfold: 6,
                                                  tablet: 8,
                                                  context: context,
                                                ),
                                                height: optimizedSize(
                                                  phone: 5,
                                                  zfold: 6,
                                                  tablet: 8,
                                                  context: context,
                                                ),
                                                margin: const EdgeInsets.only(
                                                  bottom: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColor.dotEventDay,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    if (isPersonalEvents(day.day) &&
                                        isCurrentMonth)
                                      Positioned(
                                        bottom: 1,
                                        right: 1,
                                        child: SvgPicture.asset(
                                          IconConstants.ic_star_red,
                                          width: optimizedSize(
                                            phone: 12,
                                            zfold: 12.75,
                                            tablet: 14,
                                            context: context,
                                          ),
                                          height: optimizedSize(
                                            phone: 12,
                                            zfold: 12.75,
                                            tablet: 14,
                                            context: context,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.all(1),
                              decoration: isSelected && isCurrentMonth
                                  ? BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 255, 246, 203),
                                          Color(0xffFAC600),
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.center,
                                      ),
                                      border: Border.all(
                                        color: isCurrentMonth
                                            ? AppColor.primaryColor.withAlpha(
                                                (0.25 * 255).toInt(),
                                              )
                                            : AppColor.inactiveDayCalendar,
                                        width: 0.25,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    )
                                  : BoxDecoration(
                                      color: (isCurrentMonth
                                          ? AppColor.sandColor.withAlpha(150)
                                          : AppColor.transparentColor),
                                      border: Border.all(
                                        color: isCurrentMonth
                                            ? AppColor.actionTextYellow
                                            : AppColor.transparentColor,
                                        width: 0.35,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${day.day}',
                                            style: TextAppStyle()
                                                .normalTextStyle()
                                                .copyWith(
                                                  fontSize: optimizedSize(
                                                    phone:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width >
                                                            395
                                                        ? 17
                                                        : 16,
                                                    zfold: 17.5,
                                                    tablet: 20,
                                                    context: context,
                                                  ),
                                                  color: isCurrentMonth
                                                      ? isSunday
                                                            ? AppColor
                                                                  .colorRedBold
                                                            : AppColor
                                                                  .primaryColor
                                                      : AppColor
                                                            .grayTextwhiteColor,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          margin: const EdgeInsets.only(
                                            bottom: 2,
                                          ),
                                          child: Text(
                                            lunarDay,
                                            style: TextAppStyle()
                                                .thinTextStyleExtraSmall()
                                                .copyWith(
                                                  fontSize: optimizedSize(
                                                    phone: 11,
                                                    zfold: 12.5,
                                                    tablet: 14,
                                                    context: context,
                                                  ),

                                                  // decoration: TextDecoration
                                                  //     .underline,
                                                  // decorationColor:
                                                  //     AppColor.primaryColor,
                                                  // decorationThickness: 0.5,
                                                  color: isCurrentMonth
                                                      ? AppColor.primaryColor
                                                      : AppColor
                                                            .grayTextBoldColor,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isLuckyDay ||
                                      isUnluckyDay ||
                                      isImportantHoliday(day.day))
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isLuckyDay && isCurrentMonth)
                                            Container(
                                              width:
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      500
                                                  ? 8
                                                  : 5,
                                              height:
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      500
                                                  ? 8
                                                  : 5,
                                              margin: const EdgeInsets.only(
                                                bottom: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColor.newPrimaryColor1,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          if (isUnluckyDay && isCurrentMonth)
                                            Container(
                                              width:
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      500
                                                  ? 8
                                                  : 5,
                                              height:
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      500
                                                  ? 8
                                                  : 5,
                                              margin: const EdgeInsets.only(
                                                bottom: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColor.dotBlackDay,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          if (isImportantHoliday(day.day) &&
                                              isCurrentMonth)
                                            Container(
                                              width:
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      500
                                                  ? 8
                                                  : 5,
                                              height:
                                                  MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      500
                                                  ? 8
                                                  : 5,
                                              margin: const EdgeInsets.only(
                                                bottom: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColor.dotEventDay,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  if (isPersonalEvents(day.day) &&
                                      isCurrentMonth)
                                    Positioned(
                                      bottom: 1,
                                      right: 1,
                                      child: SvgPicture.asset(
                                        IconConstants.ic_star_red,
                                        width:
                                            MediaQuery.of(context).size.width >
                                                500
                                            ? 16
                                            : 12,
                                        height:
                                            MediaQuery.of(context).size.width >
                                                500
                                            ? 16
                                            : 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.activeDayCalendar,
                                  AppColor.activeDayCalendar.withAlpha(
                                    (0.75 * 255).toInt(),
                                  ),
                                  AppColor.activeDayCalendar.withAlpha(
                                    (0.25 * 255).toInt(),
                                  ),
                                  AppColor.activeDayCalendar.withAlpha(
                                    (0.0001 * 255).toInt(),
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: MediaQuery.of(context).size.width > 500
                                  ? (isSamsungZFold(context) ? 6 : 10)
                                  : 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.dotZodiacDay,
                                    border: Border.all(
                                      width: 0.5,
                                      strokeAlign: BorderSide.strokeAlignInside,
                                      color: AppColor.blackColor.withAlpha(
                                        (0.25 * 255).toInt(),
                                      ),
                                    ),
                                  ),
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      'zodiac_day'.tr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextAppStyle()
                                          .normalTextStyleSmall()
                                          .copyWith(
                                            color: AppColor.primaryColor,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xffbfbfbf),
                                  const Color(
                                    0xffbfbfbf,
                                  ).withAlpha((0.75 * 255).toInt()),
                                  const Color(
                                    0xffbfbfbf,
                                  ).withAlpha((0.25 * 255).toInt()),
                                  const Color(
                                    0xffbfbfbf,
                                  ).withAlpha((0.0001 * 255).toInt()),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: MediaQuery.of(context).size.width > 500
                                  ? (isSamsungZFold(context) ? 6 : 10)
                                  : 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.dotBlackDay,
                                    border: Border.all(
                                      width: 0.5,
                                      strokeAlign: BorderSide.strokeAlignInside,
                                      color: AppColor.dotZodiacDay.withAlpha(
                                        (0.5 * 255).toInt(),
                                      ),
                                    ),
                                  ),
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      'black_day'.tr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextAppStyle()
                                          .normalTextStyleSmall()
                                          .copyWith(
                                            color: AppColor.primaryColor,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.backgroundRedLight,
                                  AppColor.backgroundRedLight.withAlpha(
                                    (0.75 * 255).toInt(),
                                  ),
                                  AppColor.backgroundRedLight.withAlpha(
                                    (0.25 * 255).toInt(),
                                  ),
                                  AppColor.backgroundRedLight.withAlpha(
                                    (0.0001 * 255).toInt(),
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: MediaQuery.of(context).size.width > 500
                                  ? (isSamsungZFold(context) ? 6 : 10)
                                  : 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.dotEventDay,
                                    border: Border.all(
                                      width: 0.5,
                                      strokeAlign: BorderSide.strokeAlignInside,
                                      color: AppColor.blackColor.withAlpha(
                                        (0.25 * 255).toInt(),
                                      ),
                                    ),
                                  ),
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(width: 6),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    'event_day'.tr,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextAppStyle()
                                        .normalTextStyleSmall()
                                        .copyWith(
                                          color: AppColor.primaryColor,
                                          fontSize: 12,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFffeacf),
                                  const Color(
                                    0xFFffeacf,
                                  ).withAlpha((0.75 * 255).toInt()),
                                  const Color(
                                    0xFFffeacf,
                                  ).withAlpha((0.25 * 255).toInt()),
                                  const Color(
                                    0xFFffeacf,
                                  ).withAlpha((0.0001 * 255).toInt()),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: MediaQuery.of(context).size.width > 500
                                  ? (isSamsungZFold(context) ? 6 : 10)
                                  : 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 6),
                                SvgPicture.asset(
                                  IconConstants.ic_star_red,
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      'my_event'.tr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextAppStyle()
                                          .normalTextStyleSmall()
                                          .copyWith(
                                            color: AppColor.primaryColor,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calendartByDay(BuildContext context) {
    String formattedTime =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}';

    final dayOfWeek = weekdays[_selectedDay!.weekday - 1];
    final day = _selectedDay!.day;
    final month = monthNames[_selectedDay!.month - 1];
    final year = _selectedDay!.year;
    return Screenshot(
      controller: screenshotController,
      child: GradientBorderContainer(
        lstColor: CommonConstants.button,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        padding: const EdgeInsets.all(2),
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        radius: 10,
        child: Stack(
          children: [
            Container(
              width: getResponsiveWidth(context),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(ImageConstants.img_bg_day_calendar),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.transparentColor,
                      AppColor.whiteColor.withAlpha(100),
                      AppColor.whiteColor.withAlpha(200),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 1),
                              Text(
                                parseDay(dayOfWeek).tr,
                                style: TextAppStyle().superStyle().copyWith(
                                  color: AppColor.primaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width > 500
                                      ? (isSamsungZFold(context) ? 18 : 26)
                                      : 18,
                                ),
                              ),
                              Text(
                                '$day',
                                style: TextAppStyle().titleStyle().copyWith(
                                  fontSize: 72,
                                ),
                              ),
                              Text(
                                '${month.tr}, $year',
                                style: TextAppStyle()
                                    .semiBoldTextStyle()
                                    .copyWith(fontSize: 14.0),
                              ),
                              Text(
                                '(${'solar'.tr.replaceAll('\n', ' ')})',
                                style: TextAppStyle().thinTextStyle().copyWith(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 0.25, // The width of the dashed line
                          height: 200, // The desired height, adjust as needed
                          child: Container(
                            width: 0.25,
                            height: 200,
                            color: AppColor.grayTextwhiteColor,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${'day'.tr} $_selectedLunarDate ${'month'.tr} $_selectedLunarMonth'
                                ' ${_isLeapMonth ? 'leap_year'.tr : ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextAppStyle().superStyle().copyWith(
                                  fontSize: _isLeapMonth
                                      ? (MediaQuery.of(context).size.width > 500
                                            ? (isSamsungZFold(context)
                                                  ? 18
                                                  : 26)
                                            : 16)
                                      : (MediaQuery.of(context).size.width > 500
                                            ? (isSamsungZFold(context)
                                                  ? 19
                                                  : 28)
                                            : 17.5),
                                  color: AppColor.textBrownColor,
                                ),
                              ),
                              Text(
                                '(${'lunar'.tr.replaceAll('\n', ' ')})',
                                style: TextAppStyle().thinTextStyle().copyWith(
                                  fontSize: 12.0,
                                  color: AppColor.textBrownColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Column(
                                children: List.generate(
                                  3,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: [
                                          'day'.tr,
                                          'month'.tr,
                                          'year'.tr,
                                        ][index],
                                        style: TextAppStyle()
                                            .normalTextStyle()
                                            .copyWith(fontSize: 14.0),
                                        children: [
                                          TextSpan(
                                            text: [
                                              ' $_selectedLunarZodiacDay',
                                              ' $_selectedLunarZodiacMonth',
                                              ' $_selectedLunarZodiacYear',
                                            ][index],
                                            style: TextAppStyle()
                                                .titleStyle()
                                                .copyWith(
                                                  color:
                                                      AppColor.textBrownColor,
                                                  fontSize: 16.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              _isLoading
                                  ? const SizedBox(height: 24)
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'hour'.tr,
                                          style: TextAppStyle()
                                              .normalTextStyle()
                                              .copyWith(fontSize: 14.0),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${_apiResponse?['data']['name']}'.tr,
                                          style: TextAppStyle()
                                              .titleStyle()
                                              .copyWith(
                                                color: AppColor.textBrownColor,
                                                fontSize: 16.0,
                                              ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SizedBox(
                        width: getResponsiveWidth(context) - 48,
                        child: Container(
                          height: 0.25,
                          color: AppColor.grayTextwhiteColor,
                        ),
                      ),
                    ),
                    isLoadingDetailsOfDay
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: SizedBox(
                                  height: 24,
                                  width: getResponsiveWidth(context),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 80,
                                  ),
                                  child: SizedBox(
                                    height: 24,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: SizedBox(
                                  height: 24,
                                  width: getResponsiveWidth(context),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 80,
                                  ),
                                  child: SizedBox(
                                    height: 24,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: getResponsiveWidth(context),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildRichText(
                                  detailsOfDayModel?.truc ?? '',
                                  detailsOfDayModel?.tu ?? '',
                                  detailsOfDayModel?.tiet ?? '',
                                  context,
                                ),
                                const SizedBox(height: 4),
                                _isZodiacDay
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColor.lightBackgroundColor,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: Border.all(
                                            width: 0.5,
                                            color: AppColor.dotZodiacDay,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    AppColor.newPrimaryColor1,
                                                border: Border.all(
                                                  width: 0.25,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignInside,
                                                  color: AppColor.primaryColor
                                                      .withAlpha(
                                                        (0.25 * 255).toInt(),
                                                      ),
                                                ),
                                              ),
                                              width: 8,
                                              height: 8,
                                            ),
                                            const SizedBox(width: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 3,
                                                right: 2,
                                                top: 1,
                                              ),
                                              child: Text(
                                                'zodiac_day'.tr,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextAppStyle()
                                                    .semiBoldTextStyle()
                                                    .copyWith(
                                                      color: AppColor
                                                          .newPrimaryColor1,
                                                      fontSize: 12.0,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.grayTab,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: Border.all(
                                            width: 0.5,
                                            color: AppColor.dotBlackDay,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColor.dotBlackDay,
                                                border: Border.all(
                                                  width: 0.25,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignInside,
                                                  color: AppColor.secondaryColor
                                                      .withAlpha(
                                                        (0.5 * 255).toInt(),
                                                      ),
                                                ),
                                              ),
                                              width: 8,
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 3,
                                                left: 4,
                                                top: 1,
                                              ),
                                              child: Text(
                                                'black_day'.tr,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextAppStyle()
                                                    .semiBoldTextStyle()
                                                    .copyWith(
                                                      color: AppColor
                                                          .grayTextBoldColor,
                                                      fontSize: 12.0,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                        ),
                                      ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: AppColor.colorRed,
                                        width: 0.25,
                                      ),
                                      bottom: BorderSide(
                                        color: AppColor.colorRed,
                                        width: 0.25,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 2,
                                        ),
                                        child: Text(
                                          '${'${'bachky'.tr}: '.tr}${detailsOfDayModel?.bachKy?.map((item) => item.tr).join(', ') ?? ''}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextAppStyle()
                                              .semiBoldTextStyle()
                                              .copyWith(
                                                color: AppColor.colorRed,
                                                fontSize: 14.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // ignore: prefer_const_constructors
                                  padding: EdgeInsets.fromLTRB(12, 0, 8, 6),

                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 32,
                                            child: Center(
                                              child: Text(
                                                formattedTime,
                                                style: TextAppStyle()
                                                    .semiBoldTextStyle()
                                                    .copyWith(
                                                      color:
                                                          AppColor.primaryColor,
                                                      fontSize: 16.0,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                            ),
                                            width: 4,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColor.primaryColor,
                                            ),
                                          ),
                                          onTapWidget(
                                            onTap: () async {
                                              _capturingAndShareScreenshot();
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  getZodiacImage(
                                                    _apiResponse?['data']['order'] ??
                                                        1,
                                                  ),
                                                  fit: BoxFit.contain,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${_apiResponse?['data']['name']}'
                                                      .tr,
                                                  style: TextAppStyle()
                                                      .semiBoldTextStyleExtraSmall()
                                                      .copyWith(fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      (_apiResponse?['data']['isHoangDaoTime'] ??
                                              false)
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 0,
                                                  ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ColorFiltered(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          AppColor.primaryColor,
                                                          BlendMode.srcATop,
                                                        ),
                                                    child: SvgPicture.asset(
                                                      IconConstants
                                                          .ic_time_white,
                                                      width: 14,
                                                      height: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 2,
                                                        ),
                                                    child: Text(
                                                      'zodiac_hours'.tr,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextAppStyle()
                                                          .normalTextStyle()
                                                          .copyWith(
                                                            color: AppColor
                                                                .primaryColor,
                                                            fontSize: 12.0,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(height: 17),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: CommonConstants.gradientBrownBtn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _zodiacTimes(BuildContext context) {
    return GradientBorderContainer(
      lstColor: CommonConstants.button,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(2),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      radius: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: getResponsiveWidth(context),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(ImageConstants.img_bg_zodiac_hours),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Text(
              'zodiac_hours'.tr.toUpperCase(),
              style: TextAppStyle().titleStyleExtraLarge().copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 0, // Khoảng cách giữa các icon
              runSpacing: 16, // Khoảng cách giữa các dòng
              children: isLoadingDetailsOfDay
                  ? List.generate(6, (index) {
                      return InkWell(
                        onTap: () {},
                        child: SizedBox(
                          width:
                              (getResponsiveWidth(context) - 60 - 8 - 20) / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 52,
                                width: 52,
                                child: ClipOval(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 52,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  : List.generate(detailsOfDayModel?.gioHoangDao?.length ?? 0, (
                      index,
                    ) {
                      return InkWell(
                        onTap: () {
                          // showDialog(
                          //   barrierColor:
                          //       AppColor.blackColor.withAlpha((0.9 * 255).toInt()),
                          //   context: context,
                          //   builder: (context) {
                          //     return AlertDialog(
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(200),
                          //         ),
                          //         backgroundColor:
                          //             AppColor.blackColor.withAlpha((0.15 * 255).toInt()),
                          //         insetPadding: EdgeInsets.zero,
                          //         contentPadding: EdgeInsets.zero,
                          //         content: Container(
                          //           decoration: BoxDecoration(
                          //               shape: BoxShape.circle,
                          //               border: Border.all(
                          //                   width: 24,
                          //                   color: AppColor.whiteColor
                          //                       .withAlpha((0.1 * 255).toInt()))),
                          //           width: getResponsiveWidth(context) / 5,
                          //           padding: const EdgeInsets.all(8),
                          //           child: Container(
                          //               decoration: BoxDecoration(
                          //                 color: AppColor.transparentColor,
                          //               ),
                          //               width: getResponsiveWidth(context) / 5,
                          //               padding: const EdgeInsets.all(16),
                          //               child: Image.asset(
                          //                 getZodiacImage(detailsOfDayModel
                          //                         ?.gioHoangDao?[index]
                          //                         .order ??
                          //                     0),
                          //                 fit: BoxFit.cover,
                          //               )),
                          //         ));
                          //   },
                          // );
                        },
                        child: SizedBox(
                          width: (getResponsiveWidth(context) - 52 - 4) / 3,
                          // height: (getResponsiveWidth(context) - 8 - 8 - 8) / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  index == 0 || index == 3
                                      ? SizedBox(
                                          width:
                                              (((getResponsiveWidth(context) -
                                                          52 -
                                                          4) /
                                                      3) /
                                                  2) -
                                              26,
                                        )
                                      : Container(
                                          width:
                                              (((getResponsiveWidth(context) -
                                                          52 -
                                                          4) /
                                                      3) /
                                                  2) -
                                              26,
                                          height: 1,
                                          color: AppColor.brownLight,
                                        ),
                                  ClipOval(
                                    child: SizedBox(
                                      width: 52,
                                      height: 52,
                                      child: Image.asset(
                                        getZodiacImage(
                                          detailsOfDayModel
                                                  ?.gioHoangDao?[index]
                                                  .order ??
                                              0,
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  index == 2 || index == 5
                                      ? SizedBox(
                                          width:
                                              (((getResponsiveWidth(context) -
                                                          52 -
                                                          4) /
                                                      3) /
                                                  2) -
                                              26,
                                        )
                                      : Container(
                                          width:
                                              (((getResponsiveWidth(context) -
                                                          52 -
                                                          4) /
                                                      3) /
                                                  2) -
                                              26,
                                          height: 1,
                                          color: AppColor.brownLight,
                                        ),
                                ],
                              ),
                              // ),
                              const SizedBox(height: 8),
                              Column(
                                children: [
                                  Text(
                                    (detailsOfDayModel
                                                ?.gioHoangDao?[index]
                                                .name ??
                                            '')
                                        .tr,
                                    style: TextAppStyle().titleStyle().copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${formatHourSecond(detailsOfDayModel?.gioHoangDao?[index].start ?? 0)} - ${formatHourSecond(detailsOfDayModel?.gioHoangDao?[index].end ?? 0)}',
                                    style: TextAppStyle()
                                        .normalTextStyleExtraSmall()
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
            ),
            const SizedBox(height: 16),
            isLoadingDetailsOfDay
                ? Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 24,
                            width: getResponsiveWidth(context) / 1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.primaryColor,
                              border: Border.all(
                                width: 0.5,
                                strokeAlign: BorderSide.strokeAlignInside,
                                color: AppColor.blackColor.withAlpha(
                                  (0.25 * 255).toInt(),
                                ),
                              ),
                            ),
                            width: 6,
                            height: 6,
                          ),
                          const SizedBox(width: 8),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: '${'death_hours'.tr}: ',
                                style: TextAppStyle()
                                    .normalTextStyle()
                                    .copyWith(fontSize: 14.0),
                                children: [
                                  TextSpan(
                                    text:
                                        '${(detailsOfDayModel?.gioThoTu?.name ?? '-- : --').tr} (${formatHourSecond(detailsOfDayModel?.gioThoTu?.start ?? 0)} - ${formatHourSecond(detailsOfDayModel?.gioThoTu?.end ?? 0)})',
                                    style: TextAppStyle().titleStyle().copyWith(
                                      color: AppColor.primaryColor,
                                      fontSize: 16.0,
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
            const SizedBox(height: 8),
            isLoadingDetailsOfDay
                ? Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 24,
                            width: getResponsiveWidth(context) / 1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.primaryColor,
                            border: Border.all(
                              width: 0.5,
                              strokeAlign: BorderSide.strokeAlignInside,
                              color: AppColor.blackColor.withAlpha(
                                (0.25 * 255).toInt(),
                              ),
                            ),
                          ),
                          width: 6,
                          height: 6,
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            text: '${'killer_hours'.tr}: ',
                            style: TextAppStyle().normalTextStyle().copyWith(
                              fontSize: 14.0,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${(detailsOfDayModel?.gioSatChu?.name ?? '-- : --').tr} (${formatHourSecond(detailsOfDayModel?.gioSatChu?.start ?? 0)} - ${formatHourSecond(detailsOfDayModel?.gioSatChu?.end ?? 0)})',
                                style: TextAppStyle().titleStyle().copyWith(
                                  color: AppColor.primaryColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _ageByDayAndMonth(BuildContext context) {
    return GradientBorderContainer(
      lstColor: CommonConstants.button,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(2),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      radius: 10,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: getResponsiveWidth(context),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(ImageConstants.img_bg_ages),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'age_around_days'.tr.toUpperCase(),
                  style: TextAppStyle().titleStyleExtraLarge().copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 0, // Khoảng cách giữa các icon
                  runSpacing: 0, // Khoảng cách giữa các dòng
                  children: isLoadingDetailsOfDay
                      ? List.generate(4, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipOval(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 52,
                                      width: 52,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      : List.generate(
                          detailsOfDayModel?.tuoiXungNgay?.length ?? 0,
                          (index) {
                            return InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                      child: SizedBox(
                                        width: 52,
                                        height: 52,
                                        child: Image.asset(
                                          getZodiacImage(
                                            (detailsOfDayModel
                                                    ?.tuoiXungNgay?[index]
                                                    .order ??
                                                0),
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    // ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 2),
                                        Text(
                                          (detailsOfDayModel
                                                      ?.tuoiXungNgay?[index]
                                                      .key ??
                                                  '')
                                              .tr,
                                          style: TextAppStyle()
                                              .titleStyle()
                                              .copyWith(fontSize: 14),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          (detailsOfDayModel
                                                      ?.tuoiXungNgay?[index]
                                                      .nguHanh ??
                                                  '')
                                              .tr,
                                          style: TextAppStyle()
                                              .normalTextStyle()
                                              .copyWith(
                                                fontSize: 14,
                                                color: getColorByElement(
                                                  detailsOfDayModel
                                                          ?.tuoiXungNgay?[index]
                                                          .nguHanh ??
                                                      '',
                                                ),
                                              ),
                                        ),
                                      ],
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
            const SizedBox(height: 32),
            Column(
              children: [
                Text(
                  'age_around_months'.tr.toUpperCase(),
                  style: TextAppStyle().titleStyleExtraLarge().copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8, // Khoảng cách giữa các icon
                  runSpacing: 24, // Khoảng cách giữa các dòng
                  children: isLoadingDetailsOfDay
                      ? List.generate(2, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipOval(
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 52,
                                      width: 52,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      : List.generate(
                          detailsOfDayModel?.tuoiXungThang?.length ?? 0,
                          (index) {
                            return InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                      child: SizedBox(
                                        width: 52,
                                        height: 52,
                                        child: Image.asset(
                                          getZodiacImage(
                                            (detailsOfDayModel
                                                    ?.tuoiXungThang?[index]
                                                    .order ??
                                                0),
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 2),
                                        Text(
                                          (detailsOfDayModel
                                                      ?.tuoiXungThang?[index]
                                                      .key ??
                                                  '')
                                              .tr,
                                          style: TextAppStyle()
                                              .titleStyle()
                                              .copyWith(fontSize: 14),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          (detailsOfDayModel
                                                      ?.tuoiXungThang?[index]
                                                      .nguHanh ??
                                                  '')
                                              .tr,
                                          style: TextAppStyle()
                                              .normalTextStyle()
                                              .copyWith(
                                                fontSize: 14,
                                                color: getColorByElement(
                                                  detailsOfDayModel
                                                          ?.tuoiXungThang?[index]
                                                          .nguHanh ??
                                                      '',
                                                ),
                                              ),
                                        ),
                                      ],
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
          ],
        ),
      ),
    );
  }

  Widget _eventsInDay(BuildContext context) {
    return GradientBorderContainer(
      lstColor: CommonConstants.button,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(2),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      radius: 10,
      child: Container(
        width: getResponsiveWidth(context),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(ImageConstants.img_bg_upcoming_events),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.whiteColor.withAlpha((0.5 * 255).toInt()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'events_in_day'.tr.toUpperCase(),
                    style: TextAppStyle().titleStyleExtraLarge().copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: List.generate(
                      detailsOfDayModel?.events?.length ?? 0,
                      (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: getResponsiveWidth(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(
                                          int.tryParse(
                                                detailsOfDayModel
                                                        ?.events?[index]
                                                        .color ??
                                                    '0xff8A0003',
                                              ) ??
                                              0xff262626,
                                        ),
                                        border: Border.all(
                                          width: 0.5,
                                          strokeAlign:
                                              BorderSide.strokeAlignInside,
                                          color: AppColor.blackColor.withAlpha(
                                            (0.25 * 255).toInt(),
                                          ),
                                        ),
                                      ),
                                      width: 6,
                                      height: 6,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        detailsOfDayModel
                                                ?.events?[index]
                                                .name ??
                                            '',
                                        textAlign: TextAlign.left,
                                        style: TextAppStyle()
                                            .titleStyle()
                                            .copyWith(
                                              color: Color(
                                                int.tryParse(
                                                      detailsOfDayModel
                                                              ?.events?[index]
                                                              .color ??
                                                          '0xff8A0003',
                                                    ) ??
                                                    0xff262626,
                                              ),
                                              fontSize: 16,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 4,
                                      margin: const EdgeInsets.only(
                                        left: 1,
                                        top: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(
                                          int.tryParse(
                                                detailsOfDayModel
                                                        ?.events?[index]
                                                        .color ??
                                                    '0xff8A0003',
                                              ) ??
                                              0xff262626,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      children: [
                                        Text(
                                          '${detailsOfDayModel?.events?[index].solarDate ?? ''} (${'duong_lich_short'.tr})',
                                          textAlign: TextAlign.left,
                                          style: TextAppStyle()
                                              .normalTextStyle()
                                              .copyWith(
                                                fontSize: 14,
                                                color: Color(
                                                  int.tryParse(
                                                        detailsOfDayModel
                                                                ?.events?[index]
                                                                .color ??
                                                            '0xff8A0003',
                                                      ) ??
                                                      0xff262626,
                                                ),
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${detailsOfDayModel?.events?[index].lunarDate ?? ''} (${'am_lich_short'.tr})',
                                          textAlign: TextAlign.left,
                                          style: TextAppStyle()
                                              .normalTextStyle()
                                              .copyWith(
                                                fontSize: 14,
                                                color: Color(
                                                  int.tryParse(
                                                        detailsOfDayModel
                                                                ?.events?[index]
                                                                .color ??
                                                            '0xff8A0003',
                                                      ) ??
                                                      0xff262626,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          index + 1 >= (detailsOfDayModel?.events?.length ?? 0)
                              ? const SizedBox()
                              : Container(
                                  height: 1,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  width: getResponsiveWidth(context) - 72,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: CommonConstants.button,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _incenseAndLamps(BuildContext context) {
    return GradientBorderContainer(
      lstColor: CommonConstants.button,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(2),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      radius: 10,
      child: Container(
        width: getResponsiveWidth(context),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(ImageConstants.img_bg_upcoming_events),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.whiteColor.withAlpha((0.5 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: Column(
                children: [
                  Text(
                    'incense_n_lamps'.tr.toUpperCase(),
                    style: TextAppStyle().titleStyleExtraLarge().copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: List.generate(
                      detailsOfDayModel?.incenseAndLamps?.length ?? 0,
                      (index) => onTapWidget(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         IncenseAndLampsInside(
                          //       id: detailsOfDayModel
                          //               ?.incenseAndLamps?[index].id ??
                          //           '',
                          //       title: detailsOfDayModel
                          //               ?.incenseAndLamps?[index]
                          //               .name ??
                          //           '',
                          //       uiRepository: widget.uiRepository,
                          //       background: ImageConstants.img_bg_auth,
                          //       icon: IconConstants.apple,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: getResponsiveWidth(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              IconConstants
                                                  .ic_menu_incense_n_lamps,
                                              width: 32,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                detailsOfDayModel
                                                        ?.incenseAndLamps?[index]
                                                        .name ??
                                                    '',
                                                textAlign: TextAlign.left,
                                                style: TextAppStyle()
                                                    .titleStyle()
                                                    .copyWith(
                                                      color:
                                                          AppColor.primaryColor,
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Image.asset(
                                        ImageConstants.img_next_tab_feng_shui,
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 100,
                                    child: Html(
                                      data:
                                          detailsOfDayModel
                                              ?.incenseAndLamps?[index]
                                              .descriptions
                                              ?.first
                                              .content ??
                                          '',
                                      style: {
                                        "body": Style(
                                          fontSize: FontSize(14.0),
                                          color: AppColor.primaryColor,
                                          maxLines: 4,
                                          textOverflow: TextOverflow.ellipsis,
                                          fontFamily: CommonConstants.light,
                                        ),
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
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
          ],
        ),
      ),
    );
  }

  Widget _upcomingEvents(BuildContext context) {
    return GradientBorderContainer(
      lstColor: CommonConstants.button,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(2),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      radius: 10,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: getResponsiveWidth(context),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(ImageConstants.img_bg_upcoming_events),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      width: getResponsiveWidth(context) - 120,
                      height: getResponsiveWidth(context) - 120,
                      // height: getResponsiveWidth(context) / 2,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageConstants.img_bg_ial_content),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  'upcoming_events'.tr.toUpperCase(),
                  style: TextAppStyle().titleStyleExtraLarge().copyWith(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 8, // Khoảng cách giữa các icon
                  runSpacing: 0, // Khoảng cách giữa các dòng
                  children: upcomingHolidays?.length == 0
                      ? List.generate(4, (index) {
                          return Column(
                            children: [
                              SizedBox(
                                width: getResponsiveWidth(context),
                                height: 100,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 100,
                                    width: getResponsiveWidth(context),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              index + 1 >= 4
                                  ? const SizedBox()
                                  : Container(
                                      height: 0.5,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      width: getResponsiveWidth(context) - 72,
                                      decoration: BoxDecoration(
                                        color: AppColor.textBrownColor
                                            .withAlpha((0.5 * 255).toInt()),
                                      ),
                                    ),
                            ],
                          );
                        })
                      : List.generate(upcomingHolidays?.length ?? 0, (index) {
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: getResponsiveWidth(context),
                                    // height: (getResponsiveWidth(context) - 8 - 8 - 8) / 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    top: 0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(
                                                      int.tryParse(
                                                            upcomingHolidays?[index]
                                                                    .color ??
                                                                '',
                                                          ) ??
                                                          0xff431E05,
                                                    ),
                                                    border: Border.all(
                                                      width: 0.5,
                                                      strokeAlign: BorderSide
                                                          .strokeAlignInside,
                                                      color: AppColor.blackColor
                                                          .withAlpha(
                                                            (0.25 * 255)
                                                                .toInt(),
                                                          ),
                                                    ),
                                                  ),
                                                  width: 6,
                                                  height: 6,
                                                ),
                                                alignment: PlaceholderAlignment
                                                    .middle, // Giữ cho biểu tượng ở giữa
                                              ),
                                              const WidgetSpan(
                                                child: SizedBox(
                                                  width: 6,
                                                ), // Tạo khoảng trống ngang giữa các phần tử
                                              ),
                                              TextSpan(
                                                text:
                                                    upcomingHolidays?[index]
                                                        .name ??
                                                    '',
                                                style: TextAppStyle()
                                                    .titleStyle()
                                                    .copyWith(
                                                      fontSize: 16,
                                                      color: Color(
                                                        int.tryParse(
                                                              upcomingHolidays?[index]
                                                                      .color ??
                                                                  '',
                                                            ) ??
                                                            0xff431E05,
                                                      ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 48,
                                                  width: 4,
                                                  margin: const EdgeInsets.only(
                                                    left: 1,
                                                    top: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(
                                                      int.tryParse(
                                                            upcomingHolidays?[index]
                                                                    .color ??
                                                                '',
                                                          ) ??
                                                          0xff262626,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${upcomingHolidays?[index].solarDate ?? ''} (${'duong_lich_short'.tr})',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextAppStyle()
                                                            .normalTextStyle()
                                                            .copyWith(
                                                              color: Color(
                                                                int.tryParse(
                                                                      upcomingHolidays?[index]
                                                                              .color ??
                                                                          '',
                                                                    ) ??
                                                                    0xff262626,
                                                              ),
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '${upcomingHolidays?[index].lunarDate ?? ''} (${'am_lich_short'.tr})',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextAppStyle()
                                                            .normalTextStyle()
                                                            .copyWith(
                                                              color: Color(
                                                                int.tryParse(
                                                                      upcomingHolidays?[index]
                                                                              .color ??
                                                                          '',
                                                                    ) ??
                                                                    0xff262626,
                                                              ),
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 2,
                                                          ),
                                                      child: Icon(
                                                        Icons
                                                            .access_time_rounded,
                                                        size: 12,
                                                        color: AppColor
                                                            .grayTextBoldColor,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    daysUntil(
                                                              upcomingHolidays?[index]
                                                                      .solarDate ??
                                                                  '',
                                                            ) ==
                                                            0
                                                        ? Text(
                                                            'today'.tr,
                                                            style: TextAppStyle()
                                                                .thinTextStyle()
                                                                .copyWith(
                                                                  color: AppColor
                                                                      .grayTextBoldColor,
                                                                  fontSize: 10,
                                                                ),
                                                          )
                                                        : Text(
                                                            '${'left'.tr} ${upcomingHolidays?[index].remainingDays ?? 0} ${'day'.tr.toLowerCase()}',
                                                            style: TextAppStyle()
                                                                .thinTextStyle()
                                                                .copyWith(
                                                                  color: AppColor
                                                                      .grayTextBoldColor,
                                                                  fontSize: 10,
                                                                ),
                                                          ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if ((upcomingHolidays?[index].type ?? '') ==
                                      'my-events')
                                    Positioned(
                                      right: 0,
                                      top: 4,
                                      child: SvgPicture.asset(
                                        IconConstants.ic_star_red,
                                        width: 16,
                                      ),
                                    ),
                                ],
                              ),
                              index + 1 >= (upcomingHolidays?.length ?? 0)
                                  ? const SizedBox()
                                  : Container(
                                      height: 0.5,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      width: getResponsiveWidth(context) - 72,
                                      decoration: BoxDecoration(
                                        color: AppColor.primaryColor.withAlpha(
                                          (0.25 * 255).toInt(),
                                        ),
                                      ),
                                    ),
                            ],
                          );
                        }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime dateInit = DateTime.now();
    // DateFormat format = DateFormat('dd/MM/yyyy');
    setState(() {
      if (selectedDateHeader != null) {
        dateInit = selectedDateHeader!;
      } else {
        dateInit = DateTime.now();
        selectedDateHeader = dateInit;
      }
    });
    showModalBottomSheet(
      isDismissible: false,
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
          child: Container(
            height: size.height * 0.4,
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
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
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
                Expanded(
                  flex: 12,
                  child: Container(
                    margin: EdgeInsets.zero,
                    width: double.infinity,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextAppStyle()
                              .semiBoldTextStyle(),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        itemExtent: 44,
                        backgroundColor: AppColor.transparentColor,
                        onDateTimeChanged: (value) {
                          setState(() {
                            selectedDateHeader = value;
                            formattedDate = DateFormat(
                              'dd/MM/yyyy',
                            ).format(value);
                          });
                        },
                        initialDateTime: dateInit,
                        minimumYear: 1900,
                        maximumYear: 2100,
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
                          width:
                              ((MediaQuery.of(context).size.width > 500
                                      ? Get.width / 1 - 100
                                      : Get.width) -
                                  100) /
                              2,
                          height: 42,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                ButtonConstants.btn_small_primary_inactive,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'cancel'.tr,
                              style: TextAppStyle().normalTextStyle().copyWith(
                                color: AppColor.secondaryColor.withAlpha(
                                  (0.5 * 255).toInt(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            final lunarDate = FullCalender(
                              date: selectedDateHeader!,
                              timeZone: (TimeZone.vietnamese.timezone),
                            );
                            // timeRequest = DateFormat('dd/MM/yyyy')
                            //     .format(selectedDateHeader!);

                            // _selectedDay = selectedDateHeader;
                            //toan
                            _selectedDay = selectedDateHeader;
                            _reGenerateLunarDates(
                              _selectedDay?.year ?? currentYear,
                              _selectedDay?.month ?? 1,
                            );

                            lunarDay = lunarDates[_selectedDay] ?? '';

                            _selectedLunarDate = '${lunarDate.lunarDate.day}';
                            _selectedLunarMonth =
                                '${lunarDate.lunarDate.month}';
                            _selectedLunarYear = '${lunarDate.lunarDate.year}';
                            _selectedLunarZodiacDay = lunarDate
                                .lunarDate
                                .stemBranchOfDay
                                .name(LanguageName.vietNam);
                            _selectedLunarZodiacMonth = lunarDate
                                .lunarDate
                                .stemBranchOfMonth
                                .name(LanguageName.vietNam);
                            _selectedLunarZodiacYear = lunarDate
                                .lunarDate
                                .stemBranchOfYear
                                .name(LanguageName.vietNam);
                            _isZodiacDay = lunarDate.lunarDate.isLuckyDay;

                            displayMonth =
                                selectedDateHeader?.month ??
                                DateTime.now().month;
                            displayYear =
                                selectedDateHeader?.year ?? DateTime.now().year;
                            month =
                                selectedDateHeader?.month ??
                                DateTime.now().month;
                            year =
                                selectedDateHeader?.year ?? DateTime.now().year;
                            String time = DateFormat(
                              'dd/MM/yyyy',
                            ).format(selectedDateHeader ?? DateTime.now());
                            printConsole(time);
                            days = _generateDays(year, month);
                            //toab
                            _reGetCalendar(
                              time,
                              selectedDateHeader?.day ?? 1,
                              year,
                              month,
                            );
                            _getDayDetails(selectedDateHeader?.day ?? 1);
                            // _updateCurrentMonth();
                            // printConsole(displayYear.toString());
                            // printConsole(displayMonth.toString());
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width:
                              ((MediaQuery.of(context).size.width > 500
                                      ? Get.width / 1 - 100
                                      : Get.width) -
                                  100) /
                              2,
                          height: 42,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                ButtonConstants.btn_small_primary_active,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'confirm'.tr,
                              style: custom3DTextStyle(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        );
      },
    );
  }

  Stream<DateTime> clockStream() {
    return Stream<DateTime>.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now(),
    );
  }

  void refreshLunarHour() {
    _isLoading = true;
    _currentHour = DateTime.now();
    _apiTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (DateTime.now().hour != _currentHour?.hour) {
        _currentHour = DateTime.now();
        getLunarHour(
          day: _currentHour?.day ?? 1,
          month: _currentHour?.month ?? 1,
          year: _currentHour?.year ?? currentYear,
        );
      }
    });
    getLunarHour(
      day: _focusedDay.day,
      month: _focusedDay.month,
      year: _focusedDay.year,
    );
  }

  void _capturingAndShareScreenshot() async {
    await EasyLoading.show(maskType: EasyLoadingMaskType.black);

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await screenshotController.captureAndSave(
      directory.path,
      fileName: 'screenshot.png',
    );
    if (imagePath != null) {
      await EasyLoading.dismiss();
      Share.shareXFiles([XFile(imagePath)]);
    } else {
      await EasyLoading.dismiss();
    }
  }
}
