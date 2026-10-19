import 'package:flutter/material.dart';
import 'basketball_goal.dart';
import 'painters/dashed_rect_painter.dart';

/// Top Drop Zone container featuring dashed outline and basketball goal.
class TopDropZone extends StatelessWidget {
  final bool isAimed;
  final AnimationController netController;
  final double hoopWidth;
  final double hoopHeight;
  final VoidCallback onPickPdf;
  final Color primaryColor;
  final String title;
  final String subtitle;
  final String badgeText;

  const TopDropZone({
    super.key,
    required this.isAimed,
    required this.netController,
    required this.hoopWidth,
    required this.hoopHeight,
    required this.onPickPdf,
    this.primaryColor = const Color(0xFFEE5A24),
    this.title = "Drop files here",
    this.subtitle = "or take the shot",
    this.badgeText = "Tap to Pick",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(24),
      ),
      child: CustomPaint(
        painter: DashedRectPainter(
          color: isAimed ? primaryColor : const Color(0xFFCAD3DF),
          strokeWidth: 2.0,
          dashWidth: 7.0,
          dashSpace: 5.0,
          radius: 24.0,
        ),
        child: Column(
          children: [
            // Clickable header area
            InkWell(
              onTap: onPickPdf,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.file_upload_outlined,
                        size: 32,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E232A),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A94A6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Basketball Goal Assembly
            Expanded(
              child: BasketballGoal(
                netController: netController,
                hoopWidth: hoopWidth,
                hoopHeight: hoopHeight,
                primaryColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
