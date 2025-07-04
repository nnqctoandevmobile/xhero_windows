import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../shared/multi_appear_widgets/permission_animated_dialog.dart';
import 'logic/xhero_common_logics.dart';

final hasPermissions = ValueNotifier<bool>(false);

Future<void> checkAndRequestPermission({
  required BuildContext context,
  required Permission permission,
  required String title,
  required String content,
  required IconData icon,
}) async {
  var status = await permission.status;

  if (status.isGranted) {
    hasPermissions.value = true;
    printConsole('Permission already granted');
  } else if (status.isPermanentlyDenied) {
    if (context.mounted) {
      showDialog(
        context: context,
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
  } else if (status.isDenied || status.isLimited) {
    var newStatus = await permission.request();
    if (newStatus.isGranted) {
      hasPermissions.value = true;
      printConsole('Permission granted');
    } else {
      printConsole('Permission denied');
    }
  }
}
