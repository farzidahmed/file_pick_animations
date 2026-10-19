import 'package:flutter/material.dart';

/// Aiming guidance chip at the bottom of the screen.
class AimingHintBadge extends StatelessWidget {
  final bool isAimedAtBasket;
  final bool isIdle;
  final String lockedPrompt;
  final String aimPrompt;
  final String selectPrompt;
  final Color primaryColor;
  final Color lockedColor;

  const AimingHintBadge({
    super.key,
    required this.isAimedAtBasket,
    this.isIdle = false,
    this.lockedPrompt = "Target locked! Release or tap to shoot 🏀",
    this.aimPrompt = "Drag the document to aim at the basket",
    this.selectPrompt = "Tap to choose a file from device 📁",
    this.primaryColor = const Color(0xFFEE5A24),
    this.lockedColor = const Color(0xFF2E7D32),
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isIdle
        ? primaryColor
        : (isAimedAtBasket ? lockedColor : primaryColor);

    final displayPrompt = isIdle
        ? selectPrompt
        : (isAimedAtBasket ? lockedPrompt : aimPrompt);

    final displayIcon = isIdle
        ? Icons.file_upload_outlined
        : (isAimedAtBasket ? Icons.gps_fixed_rounded : Icons.touch_app_rounded);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              displayIcon,
              size: 17,
              color: statusColor,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                displayPrompt,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isIdle
                      ? const Color(0xFF5A6679)
                      : (isAimedAtBasket ? lockedColor : const Color(0xFF5A6679)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
