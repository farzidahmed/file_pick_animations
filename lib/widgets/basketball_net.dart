import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'painters/basketball_net_painter.dart';

/// Swishing basketball net widget.
class BasketballNet extends StatelessWidget {
  final AnimationController netController;

  const BasketballNet({super.key, required this.netController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: netController,
      builder: (context, _) {
        final wiggle = math.sin(netController.value * math.pi * 4) *
            (1.0 - netController.value) *
            8.0;
        return CustomPaint(
          size: const Size(80, 68),
          painter: BasketballNetPainter(wiggle: wiggle),
        );
      },
    );
  }
}
