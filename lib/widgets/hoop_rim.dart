import 'package:flutter/material.dart';
import 'painters/hoop_rim_painter.dart';

/// Basketball hoop rim arc.
class HoopRim extends StatelessWidget {
  final double width;
  final double height;
  final bool frontOnly;
  final Color rimColor;

  const HoopRim({
    super.key,
    required this.width,
    required this.height,
    required this.frontOnly,
    this.rimColor = const Color(0xFFEE5A24),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: HoopRimPainter(
        rimColor: rimColor,
        frontOnly: frontOnly,
      ),
    );
  }
}
