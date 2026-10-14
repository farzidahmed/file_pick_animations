import 'package:flutter/material.dart';
import 'painters/hoop_rim_painter.dart';

/// Basketball hoop rim arc.
class HoopRim extends StatelessWidget {
  final double width;
  final double height;
  final bool frontOnly;

  const HoopRim({
    super.key,
    required this.width,
    required this.height,
    required this.frontOnly,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: HoopRimPainter(
        rimColor: const Color(0xFFEE5A24),
        frontOnly: frontOnly,
      ),
    );
  }
}
