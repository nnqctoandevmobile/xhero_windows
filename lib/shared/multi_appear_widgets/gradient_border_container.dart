import 'package:flutter/material.dart';

import '../../constants/common.dart';

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Alignment? begin;
  final Alignment? end;
  final List<Color> lstColor;

  const GradientBorderContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.radius,
    this.begin,
    this.end,
    this.lstColor = CommonConstants.gradientsLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: height ?? 0, minWidth: width ?? 0),
      padding: padding ?? const EdgeInsets.all(2),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 4),
        gradient: LinearGradient(
          colors: lstColor,
          begin: begin ?? Alignment.centerLeft,
          end: end ?? Alignment.centerRight,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: child,
      ),
    );
  }
}
