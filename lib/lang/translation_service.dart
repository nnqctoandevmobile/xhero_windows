import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'translations/en_US.dart';
import 'translations/vi_VN.dart';
import 'translations/zh_CN.dart';

class TranslationService extends Translations {
  // ✅ Dùng tiếng Việt làm mặc định
  static const locale = Locale('vi', 'VN');

  // ✅ Nếu không khớp locale nào, dùng fallback
  static const fallbackLocale = Locale('vi', 'VN');

  @override
  Map<String, Map<String, String>> get keys => {
    'vi_VN': vi_VN,
    'en_US': en_US,
    'zh_CN': zh_CN,
  };
}
