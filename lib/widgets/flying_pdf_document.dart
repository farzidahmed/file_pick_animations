import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/trajectory_physics.dart';
import 'pdf_document_widget.dart';

/// Flying PDF Document following the Bezier curve smoothly without full-tree rebuilds.
class FlyingPdfDocument extends StatelessWidget {
  final String fileName;
  final Offset startPos;
  final Offset targetPos;
  final Animation<double> flightAnimation;
  final bool isMissed;

  const FlyingPdfDocument({
    super.key,
    required this.fileName,
    required this.startPos,
    required this.targetPos,
    required this.flightAnimation,
    this.isMissed = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flightAnimation,
      builder: (context, child) {
        final double t = isMissed ? 1.0 : flightAnimation.value;
        final p1 = TrajectoryPhysics.getControlPoint(startPos, targetPos);
        final pos = TrajectoryPhysics.evaluateBezier(startPos, p1, targetPos, t);
        final deriv = TrajectoryPhysics.evaluateBezierDerivative(startPos, p1, targetPos, t);
        final angle = math.atan2(deriv.dy, deriv.dx) * 0.35;
        final scale = 1.0 - (0.25 * t);

        return Positioned(
          left: pos.dx - 35,
          top: pos.dy - 45,
          child: RepaintBoundary(
            child: Transform.rotate(
              angle: angle,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            ),
          ),
        );
      },
      child: PdfDocumentWidget(fileName: fileName),
    );
  }
}
