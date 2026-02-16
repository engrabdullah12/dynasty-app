import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep dark base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF06080F),
                Color(0xFF0B0F1A),
                Color(0xFF100A20),
                Color(0xFF06080F),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),
        // Animated orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _OrbPainter(_controller.value),
              size: Size.infinite,
            );
          },
        ),
        // Noise/grain overlay for premium feel
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.transparent,
                AppTheme.backgroundDark.withValues(alpha: 0.4),
              ],
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double progress;
  _OrbPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      _Orb(
        color: AppTheme.primary.withValues(alpha: 0.12),
        radius: size.width * 0.5,
        center: Offset(
          size.width * 0.2 + sin(progress * 2 * pi) * size.width * 0.1,
          size.height * 0.3 + cos(progress * 2 * pi) * size.height * 0.08,
        ),
      ),
      _Orb(
        color: AppTheme.accentMagenta.withValues(alpha: 0.08),
        radius: size.width * 0.45,
        center: Offset(
          size.width * 0.8 + cos(progress * 2 * pi + 1) * size.width * 0.12,
          size.height * 0.6 + sin(progress * 2 * pi + 1) * size.height * 0.1,
        ),
      ),
      _Orb(
        color: AppTheme.accentCyan.withValues(alpha: 0.06),
        radius: size.width * 0.35,
        center: Offset(
          size.width * 0.5 + sin(progress * 2 * pi + 2) * size.width * 0.15,
          size.height * 0.15 + cos(progress * 2 * pi + 2) * size.height * 0.05,
        ),
      ),
    ];

    for (final orb in orbs) {
      final paint = Paint()
        ..color = orb.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, orb.radius * 0.6);
      canvas.drawCircle(orb.center, orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Orb {
  final Color color;
  final double radius;
  final Offset center;
  const _Orb({required this.color, required this.radius, required this.center});
}
