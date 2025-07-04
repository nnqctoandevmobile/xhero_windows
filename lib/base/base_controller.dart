// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

class BaseController extends GetxController with WidgetsBindingObserver{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription? _connectivitySubscription;
  RxString chooseAddress = ''.obs;
  RxInt isSelectedPayment = 0.obs;
  Timer? _reviewTimer;
  final int reviewTimeLimit = 20;

  // Preference keys
  static const String _keyHasRated = 'has_rated_app';
  static const String _keyLastReviewPrompt = 'last_review_prompt';
  static const int _minimumDaysBetweenPrompts = 1; // Show popup once per day

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    // resetReviewPromptForTesting();
  }
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _reviewTimer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }

  void onResumed() {}

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  Future<void> callDialogErrorNetwork() async {
    Get.snackbar('not_connection'.tr, 'network_error'.tr,
        backgroundColor: AppColor.colorRedBold,
        colorText: AppColor.secondaryColor,
        margin: const EdgeInsets.only(left: 24, right: 24),
        snackPosition: SnackPosition.TOP);
    return;
  }


  Future<void> callDialogNetworkRecovery() async {
    Get.snackbar('connection_recovery'.tr, 'connection_recovery_note'.tr,
        backgroundColor: AppColor.colorGreenDark,
        colorText: AppColor.secondaryColor,
        margin: const EdgeInsets.only(left: 24, right: 24),
        snackPosition: SnackPosition.TOP);
    return;
  }
}
