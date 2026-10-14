import 'package:flutter/material.dart';

/// Basketball Net Painter (Criss-cross diamond mesh tapering downwards).
class BasketballNetPainter extends CustomPainter {
  final double wiggle;

  BasketballNetPainter({this.wiggle = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBAC5D4)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    const int strings = 7;
    final double topWidth = size.width;
    final double bottomWidth = size.width * 0.55;
    final double topStep = topWidth / (strings - 1);
    final double bottomStep = bottomWidth / (strings - 1);
    final double bottomOffset = (topWidth - bottomWidth) / 2;

    final List<Offset> topPoints = [];
    final List<Offset> bottomPoints = [];

    for (int i = 0; i < strings; i++) {
      topPoints.add(Offset(i * topStep, 0));
      bottomPoints.add(
        Offset(bottomOffset + (i * bottomStep) + wiggle, size.height),
      );
    }

    for (int i = 0; i < strings; i++) {
      canvas.drawLine(topPoints[i], bottomPoints[strings - 1 - i], paint);
      canvas.drawLine(topPoints[i], bottomPoints[i], paint);
    }

    final double yStep = size.height / 3.5;
    for (int row = 1; row <= 3; row++) {
      final double y = row * yStep;
      final double rowFactor = row / 3.5;
      final double currentWidth = topWidth - (topWidth - bottomWidth) * rowFactor;
      final double xOffset = (topWidth - currentWidth) / 2 + (wiggle * rowFactor);

      canvas.drawLine(
        Offset(xOffset, y),
        Offset(xOffset + currentWidth, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BasketballNetPainter oldDelegate) {
    return oldDelegate.wiggle != wiggle;
  }
}
