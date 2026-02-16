import 'package:flutter/material.dart';

/// Staggered fade-slide-in animation for list items
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delayBase;
  final Duration duration;
  final Offset beginOffset;
  final Curve curve;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.delayBase = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 600),
    this.beginOffset = const Offset(0, 30),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacity = CurvedAnimation(parent: _controller, curve: widget.curve);
    _offset = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    Future.delayed(widget.delayBase * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: _offset.value,
        child: Opacity(
          opacity: _opacity.value,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Scale-bounce animation on tap for cards
class ScaleTapCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;

  const ScaleTapCard({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.97,
  });

  @override
  State<ScaleTapCard> createState() => _ScaleTapCardState();
}

class _ScaleTapCardState extends State<ScaleTapCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(begin: 1.0, end: widget.scaleDown)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Shimmer glow effect for premium elements
class ShimmerGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double glowRadius;

  const ShimmerGlow({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFF8B5CF6),
    this.glowRadius = 20,
  });

  @override
  State<ShimmerGlow> createState() => _ShimmerGlowState();
}

class _ShimmerGlowState extends State<ShimmerGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withValues(alpha: _glow.value * 0.3),
              blurRadius: widget.glowRadius,
              spreadRadius: 0,
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

/// Animated counter for stats
class AnimatedCount extends StatefulWidget {
  final String end;
  final Duration duration;
  final TextStyle? style;

  const AnimatedCount({
    super.key,
    required this.end,
    this.duration = const Duration(milliseconds: 1500),
    this.style,
  });

  @override
  State<AnimatedCount> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends State<AnimatedCount>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Start animation after a brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extract numeric part and suffix
    final numStr = widget.end.replaceAll(RegExp(r'[^0-9]'), '');
    final suffix = widget.end.replaceAll(RegExp(r'[0-9]'), '');
    final num = int.tryParse(numStr) ?? 0;

    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      builder: (context, child) {
        final current = (num * _controller.value).round();
        return Text(
          '$current$suffix',
          style: widget.style,
        );
      },
    );
  }
}
