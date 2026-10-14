import 'package:flutter/material.dart';

/// Folded Corner Dog-Ear Painter.
class FoldedCornerPainter extends CustomPainter {
  const FoldedCornerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = const Color(0xFFF1F4F9)
      ..style = PaintingStyle.fill;

    final cornerPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(cornerPath, backgroundPaint);

    final flapPaint = Paint()
      ..color = const Color(0xFFE2E7EE)
      ..style = PaintingStyle.fill;

    final flapPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(flapPath, flapPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
