import 'package:flutter/material.dart';

class GradientTextWithStrokeMenu extends StatelessWidget {
  final String text;
  final LinearGradient textGradient; // Gradient cho văn bản
  final LinearGradient strokeGradient; // Gradient cho đường viền
  final TextStyle style;
  final double strokeWidth;
  final double fontSize;
  final int maxline;

  const GradientTextWithStrokeMenu({
    super.key,
    required this.text,
    required this.textGradient,
    required this.strokeGradient,
    required this.style,
    this.strokeWidth = 3.0,
    this.fontSize = 16.0,
    this.maxline = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Đường viền
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: maxline,
          overflow: TextOverflow.ellipsis,
          style: style.copyWith(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..shader = strokeGradient.createShader(
                const Rect.fromLTWH(0, 0, 200, 70),
              ),
          ),
        ),
        // Văn bản gradient
        ShaderMask(
          shaderCallback: (bounds) {
            return textGradient.createShader(bounds);
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: maxline,
            overflow: TextOverflow.ellipsis,
            style: style.copyWith(
              fontSize: fontSize,
              color: Colors.white, // Bị che bởi ShaderMask
            ),
          ),
        ),
      ],
    );
  }
}
