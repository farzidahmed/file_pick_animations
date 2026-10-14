import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Basketball Hoop Rim Painter (Oval ring with 3D thickness).
class HoopRimPainter extends CustomPainter {
  final Color rimColor;
  final bool frontOnly;

  HoopRimPainter({required this.rimColor, required this.frontOnly});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = rimColor
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    if (frontOnly) {
      canvas.drawArc(rect, 0, math.pi, false, paint);
    } else {
      canvas.drawArc(rect, math.pi, math.pi, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HoopRimPainter oldDelegate) {
    return oldDelegate.rimColor != rimColor || oldDelegate.frontOnly != frontOnly;
  }
}
