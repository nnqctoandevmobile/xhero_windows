import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/colors.dart';
import 'permission_animated_dialog.dart';

void showPopuppermissinHandle(
    {required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    required Permission permission}) {
  showDialog(
    context: context,
    barrierColor: AppColor.blackColor.withAlpha(200),
    builder: (BuildContext dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: PermissionAnimatedDialog(
        icon: icon,
        title: title,
        content: content,
        permission: permission,
      ),
    ),
  );
}
