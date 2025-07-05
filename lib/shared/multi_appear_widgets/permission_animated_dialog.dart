import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../resource/assets_constant/images_constants.dart';
import '../../constants/colors.dart';
import '../../constants/common.dart';
import '../../utils/logic/xhero_common_logics.dart';
import '../../utils/permission_util.dart';
import '../text_style.dart';
import 'gradient_text_menu_stroke_gradient.dart';

class PermissionAnimatedDialog extends StatefulWidget {
  final IconData icon;
  final String title;
  final String content;
  final Permission permission;

  const PermissionAnimatedDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.permission,
  });

  @override
  State<PermissionAnimatedDialog> createState() =>
      _PermissionAnimatedDialogState();
}

class _PermissionAnimatedDialogState extends State<PermissionAnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.sandColor,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(color: AppColor.colorRed, width: 8),
          top: BorderSide(color: AppColor.colorRed, width: 1),
          left: BorderSide(color: AppColor.colorRed, width: 1),
          right: BorderSide(color: AppColor.colorRed, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
                bottom: -40,
                right: -20,
                child: Image.asset(
                  ImageConstants.img_watermask_xhero,
                  width: 320,
                )),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.sandColor,
                        border: Border.all(width: 4, color: AppColor.colorRed)),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.colorRed,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final double angle = 0.2 *
                                  math.sin(_controller.value * 2 * math.pi);
                              return Transform.rotate(
                                angle: angle,
                                child: child,
                              );
                            },
                            child: Icon(widget.icon,
                                size: 60, color: AppColor.sandColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox( height: 12),
                  Center(
                    child: GradientTextWithStrokeMenu(
                      text: (widget.title.toUpperCase()),
                      strokeWidth: 0.5,
                      fontSize: optimizedSize(
                          phone: 20, zfold: 2224, tablet: 24, context: context),
                      textGradient: LinearGradient(
                        transform:
                            const GradientRotation(75.75 * (math.pi / 180)),
                        colors: [
                          AppColor.colorRed,
                          AppColor.colorRed,
                          AppColor.colorRed,
                        ],
                      ),
                      strokeGradient: LinearGradient(
                        colors: CommonConstants.strokeCategoryGradient,
                        stops: CommonConstants.stopsStrokeCategoryGradient,
                      ),
                      style: TextStyle(
                        inherit: true,
                        letterSpacing: 0.2,
                        height: 1.25,
                        fontFamily: 'SVN-Utopia-Bold',
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                              offset: const Offset(-0.6, 0.5),
                              color: AppColor.colorRed,
                              blurRadius: 2),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14159),
                        child: Icon(
                          Icons.format_quote,
                          color: AppColor.colorRed,
                        ),
                      ),
                      const SizedBox( width: 4),
                      Container(
                        width: Get.width / 3,
                        height: 0.5,
                        decoration: BoxDecoration(
                          color: AppColor.colorRed,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.content,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: optimizedSize(
                          phone: 15, zfold: 17, tablet: 20, context: context),
                      color: AppColor.colorRed,
                      fontFamily: 'SVN-Utopia-Regular',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: Get.width / 3,
                        height: 0.5,
                        decoration: BoxDecoration(
                          color: AppColor.colorRed,
                        ),
                      ),
                      const SizedBox( width: 4),
                      Icon(
                        Icons.format_quote,
                        color: AppColor.colorRed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          textStyle: TextAppStyle().normalTextStyle().copyWith(
                                fontSize: optimizedSize(
                                    phone: 14,
                                    zfold: 16,
                                    tablet: 18,
                                    context: context),
                              ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "cancle".tr,
                          style: TextAppStyle().normalTextStyle().copyWith(
                                fontSize: optimizedSize(
                                    phone: 16,
                                    zfold: 18,
                                    tablet: 20,
                                    context: context),
                                color: AppColor.grayTextwhiteColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SVN-Utopia-Bold',
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          foregroundColor: AppColor.newPrimaryColor2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)
                              .copyWith(left: 12),
                          textStyle: TextAppStyle().normalTextStyle().copyWith(
                                fontSize: optimizedSize(
                                    phone: 18,
                                    zfold: 20,
                                    tablet: 22,
                                    context: context),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SVN-Utopia-Bold',
                              ),
                          shadowColor: Colors.amberAccent.shade100,
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final result = await openAppSettings();
                          if (result) {
                            var newStatus = await widget.permission.status;
                            hasPermissions.value =
                                (newStatus == PermissionStatus.granted);
                            printConsole(
                                'Permission status updated: $newStatus');
                          } else {
                            printConsole('Failed to open app settings');
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.gear_solid,
                              size: 28,
                              color: AppColor.newPrimaryColor2,
                            ),
                            const SizedBox( width: 6),
                            Text("open_app_settings".tr),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
