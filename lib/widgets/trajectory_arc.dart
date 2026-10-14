import 'package:flutter/material.dart';
import '../utils/trajectory_physics.dart';
import 'painters/trajectory_painter.dart';

/// Trajectory arc with fading progress dots.
class TrajectoryArc extends StatelessWidget {
  final Offset startPos;
  final Offset targetPos;
  final Animation<double> flightAnimation;
  final bool isFlying;

  const TrajectoryArc({
    super.key,
    required this.startPos,
    required this.targetPos,
    required this.flightAnimation,
    required this.isFlying,
  });

  @override
  Widget build(BuildContext context) {
    final p1 = TrajectoryPhysics.getControlPoint(startPos, targetPos);

    if (!isFlying) {
      return CustomPaint(
        painter: TrajectoryPainter(
          p0: startPos,
          p1: p1,
          p2: targetPos,
          dotColor: const Color(0xFFFA8B60),
          activeProgress: 0.0,
        ),
      );
    }

    return AnimatedBuilder(
      animation: flightAnimation,
      builder: (context, _) {
        return CustomPaint(
          painter: TrajectoryPainter(
            p0: startPos,
            p1: p1,
            p2: targetPos,
            dotColor: const Color(0xFFFA8B60),
            activeProgress: flightAnimation.value,
          ),
        );
      },
    );
  }
}
