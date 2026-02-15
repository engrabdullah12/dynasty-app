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
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
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
        // Dark Base
        Container(color: AppTheme.backgroundDark),
        
        // Animated Gradient Orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: BackgroundPainter(_controller.value),
              size: Size.infinite,
            );
          },
        ),
        
        // Glass Overlay (optional strict blur, using backdrop filter in content instead usually)
        // But here we just provide background.
        
        widget.child,
      ],
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    // Orb 1: Primary Purple
    final offset1 = Offset(
      size.width * 0.2 + (50 * sin(animationValue * 2 * pi)),
      size.height * 0.3 + (30 * cos(animationValue * 2 * pi)),
    );
    paint.color = AppTheme.primary.withOpacity(0.4);
    canvas.drawCircle(offset1, 200, paint);

    // Orb 2: Cyan/Secondary
    final offset2 = Offset(
      size.width * 0.8 - (40 * cos(animationValue * 2 * pi)),
      size.height * 0.7 - (60 * sin(animationValue * 2 * pi)),
    );
    paint.color = AppTheme.accentCyan.withOpacity(0.3);
    canvas.drawCircle(offset2, 180, paint);

    // Orb 3: Another Purple
    final offset3 = Offset(
      size.width * 0.5 + (60 * cos(animationValue * pi)),
      size.height * 0.5 + (40 * sin(animationValue * pi)),
    );
    paint.color = const Color(0xFF6A4CFF).withOpacity(0.2); // Lighter purple
    canvas.drawCircle(offset3, 250, paint);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
