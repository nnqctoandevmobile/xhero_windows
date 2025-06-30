import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';

class CommonWidget {
  static AppBar appBar(
    BuildContext context,
    String title, {
    void Function()? callback,
    IconData? backIcon,
    Color? color,
    bool? automaticallyImplyLeading,
  }) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      leading: backIcon == null
          ? null
          : IconButton(
              icon: Icon(backIcon, color: color),
              onPressed: () {
                if (callback != null) {
                  callback();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColor.whiteColor,
          fontFamily: 'Rubik',
        ),
      ),
      backgroundColor: Colors.green,
      elevation: 0,
    );
  }

  static SizedBox rowHeight({double height = 30}) {
    return SizedBox(height: height);
  }

  static SizedBox rowWidth({double width = 30}) {
    return SizedBox(width: width);
  }

  static Future<void> snackBar(String error) async {
    Get.snackbar(
      'error'.tr,
      error,
      backgroundColor: AppColor.colorRed,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

Widget onTapWidget({
  required Widget child,
  double radius = 0.0,
  required void Function()? onTap,
}) {
  return InkWell(
    splashColor: AppColor.blackColor.withAlpha((0.05 * 255).toInt()),
    borderRadius: BorderRadius.circular(radius),
    highlightColor: AppColor.grayTextwhiteColor.withAlpha((0.15 * 255).toInt()),
    onTap: onTap,
    child: child,
  );
}
