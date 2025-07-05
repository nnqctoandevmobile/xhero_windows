import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../constants/colors.dart';
import '../../constants/common.dart';
import '../../resource/assets_constant/icon_constants.dart';
import '../text_style.dart';

class CustomTextFieldDark extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function()? onTap;
  final TextEditingController controller;
  final bool boldHintText;
  final bool isEnable;
  final bool errorBorder;
  final bool isPhoneType;
  final int? maxLines; // Thêm tham số maxLines

  const CustomTextFieldDark({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onTap,
    required this.controller,
    this.boldHintText = false,
    this.isEnable = true,
    this.errorBorder = false,
    this.isPhoneType = false,
    this.maxLines, // Thêm maxLines vào constructor
  });

  @override
  _CustomTextFieldDarkState createState() => _CustomTextFieldDarkState();
}

class _CustomTextFieldDarkState extends State<CustomTextFieldDark> {
  late bool isEditing;

  @override
  void initState() {
    super.initState();
    isEditing = widget.controller.text.isNotEmpty;
    widget.controller.addListener(updateEditingState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateEditingState);
    super.dispose();
  }

  void updateEditingState() {
    setState(() {
      isEditing = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: Get.width - 48 - 24,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: AppColor.blackColor.withAlpha((0.9 * 255).toInt()),
          borderRadius: BorderRadius.circular(8),
          border: const GradientBoxBorder(
              gradient: LinearGradient(colors: CommonConstants.name),
              width: 0.75)),
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor:
                  AppColor.actionTextYellow, // Customize the selection color
              cursorColor: const Color(0xffF2DF7B), // Cursor color
            ),
          ),
          child: TextField(
            textDirection: TextDirection.ltr,
            enabled: widget.isEnable,
            controller: widget.controller,
            cursorColor: const Color(0xffF2DF7B),
            cursorHeight: 24,
            inputFormatters: widget.isPhoneType
                ? [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.digitsOnly,
                  ] // Giới hạn 11 ký tự cho số điện thoại
                : [],
            keyboardType:
                widget.isPhoneType ? TextInputType.phone : TextInputType.text,
            style: TextAppStyle()
                .normalTextStyleLight()
                .copyWith(color: const Color(0xffF2DF7B)),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 9, bottom: 12),
              isDense: true,
              hintText: widget.hintText,
              hintStyle: widget.boldHintText
                  ? TextAppStyle().normalTextStyle()
                  : TextAppStyle().hintTextGrey().copyWith(fontSize: 14),
              border: InputBorder.none,
              suffixIconConstraints:
                  const BoxConstraints(maxWidth: 32, maxHeight: 32),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          // 🔹 Cập nhật lại UI ngay khi xóa
                          widget.controller.clear();
                        });
                        widget.onChanged(
                            ''); // Update the onChanged callback if necessary
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Image.asset(
                            IconConstants.ic_close_gradient,
                            width: 24,
                          )),
                    )
                  : const SizedBox(),
            ),
            onChanged: widget.onChanged,
            maxLines: widget.maxLines ?? 1,
          ),
        ),
      ),
    );
  }
}
