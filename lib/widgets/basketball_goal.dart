import 'package:flutter/material.dart';
import 'basketball_net.dart';
import 'hoop_rim.dart';

/// Basketball Goal (Backboard, connector, net, and back rim).
class BasketballGoal extends StatelessWidget {
  final AnimationController netController;
  final double hoopWidth;
  final double hoopHeight;

  const BasketballGoal({
    super.key,
    required this.netController,
    required this.hoopWidth,
    required this.hoopHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Backboard
        Positioned(
          top: 0,
          child: Container(
            width: 100,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color(0xFFEE5A24),
                width: 3.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),

        // Connector neck
        Positioned(
          top: 56,
          child: Container(
            width: 16,
            height: 8,
            color: const Color(0xFFEE5A24),
          ),
        ),

        // Animated Net
        Positioned(
          top: 64,
          child: BasketballNet(netController: netController),
        ),

        // Basket Rim (Back half)
        Positioned(
          top: 55,
          child: HoopRim(
            width: hoopWidth,
            height: hoopHeight,
            frontOnly: false,
          ),
        ),
      ],
    );
  }
}
