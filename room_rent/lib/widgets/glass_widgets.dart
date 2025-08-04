import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

class GlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool animated;
  final Duration animationDuration;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.animated = false,
    this.animationDuration = const Duration(seconds: 2),
    this.margin,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _controller = AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      );
      _animation = Tween<double>(
        begin: 0.95,
        end: 1.05,
      ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
      _controller!.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget glassContainer = GlassmorphicContainer(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200,
      borderRadius: widget.borderRadius,
      blur: 15,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.1),
          const Color(0xFFFFFFFF).withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.3),
          const Color((0xFFFFFFFF)).withOpacity(0.1),
        ],
      ),
      child: widget.child,
    );

    if (widget.animated && _animation != null) {
      glassContainer = AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation!.value,
            child: glassContainer,
          );
        },
      );
    }

    // Wrap with margin if provided
    if (widget.margin != null) {
      return Container(margin: widget.margin, child: glassContainer);
    }

    return glassContainer;
  }
}

class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final Color particleColor;

  const ParticleBackground({
    super.key,
    this.particleCount = 20,
    this.particleColor = Colors.white,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    particles = List.generate(widget.particleCount, (index) => Particle());
    _controller.repeat();
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
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: particles,
            animationValue: _controller.value,
            color: widget.particleColor,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double size;
  late double speedX;
  late double speedY;
  late double opacity;

  Particle() {
    reset();
  }

  void reset() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble();
    size = math.Random().nextDouble() * 4 + 1;
    speedX = (math.Random().nextDouble() - 0.5) * 0.02;
    speedY = (math.Random().nextDouble() - 0.5) * 0.02;
    opacity = math.Random().nextDouble() * 0.5 + 0.2;
  }

  void update() {
    x += speedX;
    y += speedY;

    if (x < 0 || x > 1 || y < 0 || y > 1) {
      reset();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update();

      final paint = Paint()
        ..color = color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ShimmerText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerText({
    super.key,
    required this.text,
    required this.style,
    this.baseColor = Colors.white70,
    this.highlightColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Text(text, style: style),
    );
  }
}

class FloatingGlassButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const FloatingGlassButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  State<FloatingGlassButton> createState() => _FloatingGlassButtonState();
}

class _FloatingGlassButtonState extends State<FloatingGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onPressed,
            onTapDown: (_) {
              setState(() => _isHovered = true);
              _hoverController.forward();
            },
            onTapUp: (_) {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            onTapCancel: () {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            child: GlassmorphicContainer(
              width: 120,
              height: 45,
              borderRadius: 22.5,
              blur: 10,
              alignment: Alignment.center,
              border: 1,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.isPrimary
                    ? [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ]
                    : [
                        const Color(0xFFffffff).withOpacity(0.1),
                        const Color(0xFFFFFFFF).withOpacity(0.05),
                      ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFffffff).withOpacity(0.3),
                  const Color((0xFFFFFFFF)).withOpacity(0.1),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
