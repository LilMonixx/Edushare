import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class RadialItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double angle;
  final double radius;
  final bool isMenuOpen;
  final AnimationController controller;
  final int index;

  /// ⭐ THÊM ONTAP
  final VoidCallback onTap;

  const RadialItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.angle,
    required this.isMenuOpen,
    required this.controller,
    required this.index,
    required this.onTap,
    this.radius = 120,
  });

  @override
  Widget build(BuildContext context) {
    final rad = angle * pi / 180;

    final start = (index * 0.1).clamp(0.0, 0.9);

    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        start,
        1.0,
        curve: Curves.easeOutBack,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value.clamp(0.0, 1.0);

        final dx = radius * cos(rad) * progress;
        final dy = radius * sin(rad) * progress;

        return Positioned(
          bottom: 100 + dy,
          left: MediaQuery.of(context).size.width / 2 - 35 + dx,
          child: Opacity(
            opacity: progress,
            child: Transform.scale(
              scale: 0.6 + (0.4 * progress),
              child: child,
            ),
          ),
        );
      },

      /// ⭐ WRAP GestureDetector để click được
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.9),
                    color.withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.6),
                    blurRadius: 25,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Container(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  Icon(icon, color: Colors.white, size: 26),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}