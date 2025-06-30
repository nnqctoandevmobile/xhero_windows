import 'package:flutter/material.dart';

class GradientTextWithStroke extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final TextStyle style;

  const GradientTextWithStroke({
    super.key,
    required this.text,
    required this.colors,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = style.fontSize != null ? style.fontSize! / 15 : 3
              ..color = Colors
                  .black, // You can update this to accept a color parameter
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            text,
            textAlign: TextAlign.center,

            style: style.copyWith(
                color:
                    Colors.white), // Text color is white because of ShaderMask
          ),
        ),
      ],
    );
  }
}
