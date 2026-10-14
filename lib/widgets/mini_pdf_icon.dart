import 'package:flutter/material.dart';
import 'painters/folded_corner_painter.dart';

/// Mini PDF icon used inside status bar.
class MiniPdfIcon extends StatelessWidget {
  const MiniPdfIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFFE0E5EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              size: Size(10, 10),
              painter: FoldedCornerPainter(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMiniLine(14),
                const SizedBox(height: 3),
                _buildMiniLine(20),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    "PDF",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 6.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniLine(double width) {
    return Container(
      width: width,
      height: 2.5,
      decoration: BoxDecoration(
        color: const Color(0xFFD6DEE7),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
