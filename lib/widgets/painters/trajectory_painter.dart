import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Dotted Trajectory Arc Painter.
class TrajectoryPainter extends CustomPainter {
  final Offset p0;
  final Offset p1;
  final Offset p2;
  final Color dotColor;
  final double activeProgress;

  TrajectoryPainter({
    required this.p0,
    required this.p1,
    required this.p2,
    required this.dotColor,
    required this.activeProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const int dotCount = 13;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i <= dotCount; i++) {
      final double t = i / dotCount;
      final double u = 1 - t;
      final double x = u * u * p0.dx + 2 * u * t * p1.dx + t * t * p2.dx;
      final double y = u * u * p0.dy + 2 * u * t * p1.dy + t * t * p2.dy;
      final double radius = 3.8 + (1.2 * math.sin(t * math.pi));

      // Fade dots passed during flight
      if (activeProgress > 0 && t < activeProgress) {
        paint.color = dotColor.withValues(alpha: 0.2);
      } else {
        paint.color = dotColor;
      }

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TrajectoryPainter oldDelegate) {
    return oldDelegate.p0 != p0 ||
        oldDelegate.p1 != p1 ||
        oldDelegate.p2 != p2 ||
        oldDelegate.activeProgress != activeProgress ||
        oldDelegate.dotColor != dotColor;
  }
}
