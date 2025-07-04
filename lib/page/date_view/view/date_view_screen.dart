import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xhero_windows_app/utils/logic/common_widget.dart';

import '../../../setup_url/url.dart';
import '../../../utils/logic/xhero_common_logics.dart';

class DateViewScreen extends StatefulWidget {
  const DateViewScreen({super.key});

  @override
  State<DateViewScreen> createState() => _DateViewScreenState();
}

class _DateViewScreenState extends State<DateViewScreen> {
  @override
  void initState() {
    super.initState();
    getLunarHour(day: 04, month: 07, year: 2025);
  }

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

    final response = await http.get(url);
    printConsole('Status code: ${response.statusCode}');
    printConsole('Raw response body: ${response.body}');
    printConsole('URL: $url');

    if (response.statusCode == 200) {
      try {
        final bodyJson = json.decode(response.body);
        printConsole('Parsed JSON: $bodyJson');
      } catch (e) {
        printConsole('JSON decode error: $e');
      }
    } else {
      printConsole('Lỗi API: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return frameCommonWidget(
      background: 'background.png',
      body: Column(children: [
  
],
    ),
      titleAppbar: "Xem ngày",
    );
  }
}
