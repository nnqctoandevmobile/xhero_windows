import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/common.dart';
import '../../../shared/multi_appear_widgets/gradient_border_container.dart';
import '../../../shared/text_style.dart';
import '../../../utils/logic/common_widget.dart';

class SearchLocation extends StatefulWidget {
  final TextEditingController searchTEC;
  final bool hasText;
  final VoidCallback handleSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onTextChanged;
  const SearchLocation({
    super.key,
    required this.searchTEC,
    required this.hasText,
    required this.handleSearch,
    required this.onTextChanged,
    required this.onClear,
  });

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GradientBorderContainer(
            lstColor: CommonConstants.button,
            padding: const EdgeInsets.all(1),
            radius: 9,
            margin: EdgeInsets.zero,
            child: Container(
              width: Get.width - 48,
              height: 39,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.9 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: TextField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  controller: widget.searchTEC,
                  cursorColor: AppColor.secondaryColor,
                  cursorHeight: 24,
                  keyboardType: TextInputType.text,
                  style: TextAppStyle().normalTextStyleLight(),
                  decoration: InputDecoration(
                    suffixIconConstraints: const BoxConstraints(
                      maxWidth: 80,
                      maxHeight: 40,
                    ),
                    suffixIcon: onTapWidget(
                      onTap: () async {
                        widget.handleSearch;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.hasText
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    size: 20,
                                    color: AppColor.grayTextwhiteColor,
                                  ),
                                  onPressed: widget.onClear,
                                )
                              : const SizedBox(),
                          if (widget.hasText)
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColor.sandColor,
                                ),
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: CommonConstants.gradientBrownBtn,
                                ),
                              ),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  AppColor.borderYellow,
                                  BlendMode.srcATop,
                                ),
                                child: Icon(
                                  Icons.search,
                                  size: 24,
                                  color: AppColor.sandColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(
                      top: 5,
                      bottom: 8,
                      left: 0,
                    ),
                    isDense: true,
                    hintText:
                        '${'type_to_search'.tr} ${'location'.tr.toLowerCase()}',
                    hintStyle: TextAppStyle().thinTextStyle().copyWith(
                      fontSize: 14,
                      color: AppColor.grayTextwhiteColor,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: widget.onTextChanged,
                  onSubmitted: (value) async {},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
