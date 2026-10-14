import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Pure mathematical functions for parabolic Bezier arc calculations.
class TrajectoryPhysics {
  const TrajectoryPhysics._();

  /// Calculate Bezier control point for arc apex above both endpoints.
  static Offset getControlPoint(Offset start, Offset end) {
    final double midX = (start.dx + end.dx) / 2;
    final double minY = math.min(start.dy, end.dy);
    const double arcHeight = 140.0;
    return Offset(midX, minY - arcHeight);
  }

  /// Quadratic Bezier: B(t) = (1-t)^2*P0 + 2*(1-t)*t*P1 + t^2*P2
  static Offset evaluateBezier(Offset p0, Offset p1, Offset p2, double t) {
    final double u = 1 - t;
    final double tt = t * t;
    final double uu = u * u;
    final double x = uu * p0.dx + 2 * u * t * p1.dx + tt * p2.dx;
    final double y = uu * p0.dy + 2 * u * t * p1.dy + tt * p2.dy;
    return Offset(x, y);
  }

  /// Quadratic Bezier Derivative for realistic flight angle: B'(t)
  static Offset evaluateBezierDerivative(Offset p0, Offset p1, Offset p2, double t) {
    final double dx = 2 * (1 - t) * (p1.dx - p0.dx) + 2 * t * (p2.dx - p1.dx);
    final double dy = 2 * (1 - t) * (p1.dy - p0.dy) + 2 * t * (p2.dy - p1.dy);
    return Offset(dx, dy);
  }
}
