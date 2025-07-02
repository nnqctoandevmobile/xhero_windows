import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ZoomableImage extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;

  const ZoomableImage({
    super.key,
    required this.child,
    this.minScale = 0.5,
    this.maxScale = 3.0,
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          setState(() {
            _scale += event.scrollDelta.dy > 0 ? -0.05 : 0.05;
            _scale = _scale.clamp(widget.minScale, widget.maxScale);
          });
        }
      },
      child: GestureDetector(
        onPanStart: (_) => _dragging = true,
        onPanUpdate: (details) {
          if (_dragging) {
            setState(() {
              _offset += details.delta;
            });
          }
        },
        onPanEnd: (_) => _dragging = false,
        child: Transform.translate(
          offset: _offset,
          child: Transform.scale(
            scale: _scale,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
