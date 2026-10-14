import 'package:flutter/material.dart';

/// Aiming guidance chip at the bottom of the screen.
class AimingHintBadge extends StatelessWidget {
  final bool isAimedAtBasket;

  const AimingHintBadge({super.key, required this.isAimedAtBasket});

  @override
  Widget build(BuildContext context) {
    final statusColor = isAimedAtBasket
        ? const Color(0xFF2E7D32)
        : const Color(0xFFEE5A24);

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
              isAimedAtBasket
                  ? "Target locked! Release or tap to shoot 🏀"
                  : "Drag the PDF to aim at the basket",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isAimedAtBasket
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF5A6679),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
