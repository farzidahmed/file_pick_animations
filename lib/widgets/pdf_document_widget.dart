import 'package:flutter/material.dart';
import 'painters/folded_corner_painter.dart';

/// PDF Document representation with folded corner and red badge.
class PdfDocumentWidget extends StatelessWidget {
  final String? fileName;
  const PdfDocumentWidget({super.key, this.fileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
          topRight: Radius.circular(2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Folded corner
            const Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                size: Size(18, 18),
                painter: FoldedCornerPainter(),
              ),
            ),

            // Skeleton document lines
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 18, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSkeletonLine(width: 32),
                  const SizedBox(height: 5),
                  _buildSkeletonLine(width: 44),
                  const SizedBox(height: 5),
                  _buildSkeletonLine(width: 24),
                  const Spacer(),
                  // Red "PDF" Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "PDF",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLine({required double width}) {
    return Container(
      width: width,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFD6DEE7),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
