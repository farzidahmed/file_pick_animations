import 'package:flutter/material.dart';

/// Aiming guidance chip at the bottom of the screen.
class AimingHintBadge extends StatelessWidget {
  final bool isAimedAtBasket;
  final String lockedPrompt;
  final String aimPrompt;
  final Color primaryColor;
  final Color lockedColor;

  const AimingHintBadge({
    super.key,
    required this.isAimedAtBasket,
    this.lockedPrompt = "Target locked! Release or tap to shoot 🏀",
    this.aimPrompt = "Drag the document to aim at the basket",
    this.primaryColor = const Color(0xFFEE5A24),
    this.lockedColor = const Color(0xFF2E7D32),
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isAimedAtBasket ? lockedColor : primaryColor;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
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
              isAimedAtBasket
                  ? Icons.gps_fixed_rounded
                  : Icons.touch_app_rounded,
              size: 18,
              color: statusColor,
            ),
            const SizedBox(width: 8),
            Text(
              isAimedAtBasket ? lockedPrompt : aimPrompt,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isAimedAtBasket ? lockedColor : const Color(0xFF5A6679),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
