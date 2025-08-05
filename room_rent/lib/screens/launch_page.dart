import 'dart:math';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _textController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Text morphing variables
  final String _text = 'Kinniya Guest House';
  late List<AnimationController> _letterControllers;
  late List<Animation<double>> _letterScaleAnimations;
  late List<Animation<double>> _letterOpacityAnimations;
  late List<Animation<double>> _letterRotationAnimations;
  late List<Animation<Color?>> _letterColorAnimations;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _initializeMorphingAnimations();
    _startLaunchSequence();
  }

  void _initializeMorphingAnimations() {
    _letterControllers = [];
    _letterScaleAnimations = [];
    _letterOpacityAnimations = [];
    _letterRotationAnimations = [];
    _letterColorAnimations = [];

    for (int i = 0; i < _text.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );
      _letterControllers.add(controller);

      // Scale morphing animation
      final scaleAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));
      _letterScaleAnimations.add(scaleAnimation);

      // Opacity fade-in animation
      final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
        ),
      );
      _letterOpacityAnimations.add(opacityAnimation);

      // Rotation animation
      final rotationAnimation = Tween<double>(begin: pi, end: 0.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
        ),
      );
      _letterRotationAnimations.add(rotationAnimation);

      // Color morphing animation
      final colorAnimation =
          ColorTween(begin: Colors.transparent, end: Colors.white).animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
            ),
          );
      _letterColorAnimations.add(colorAnimation);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _textController.dispose();
    for (var controller in _letterControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startLaunchSequence() async {
    _fadeController.forward();
    _scaleController.forward();

    // Start letter morphing animations with delay
    await Future.delayed(const Duration(milliseconds: 1200));
    _startMorphingAnimations();

    // Wait for animation to complete and then navigate to home
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _startMorphingAnimations() {
    for (int i = 0; i < _letterControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) {
          _letterControllers[i].forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF667eea)],
          ),
        ),
        child: SafeArea(child: _buildLaunchContent()),
      ),
    );
  }

  Widget _buildLaunchContent() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home_work_rounded,
                  size: 70,
                  color: Color(0xFF667eea),
                ),
              ),

              const SizedBox(height: 40),

              // App Name with morphing animation
              _buildMorphingText(),

              const SizedBox(height: 12),

              // Tagline
              const Text(
                'Comfortable • Authentic • Welcoming',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 60),

              // Loading indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),

              const SizedBox(height: 20),

              // Loading text
              const Text(
                'Preparing your perfect stay...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMorphingText() {
    return SizedBox(
      height: 60,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: _text.split('').asMap().entries.map((entry) {
          int index = entry.key;
          String letter = entry.value;

          return AnimatedBuilder(
            animation: _letterControllers[index],
            builder: (context, child) {
              return Transform.rotate(
                angle: _letterRotationAnimations[index].value,
                child: Transform.scale(
                  scale: _letterScaleAnimations[index].value,
                  child: AnimatedBuilder(
                    animation: _letterColorAnimations[index],
                    builder: (context, child) {
                      return Opacity(
                        opacity: _letterOpacityAnimations[index].value,
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize:
                                32 * _letterScaleAnimations[index].value +
                                10 *
                                    sin(_letterRotationAnimations[index].value),
                            fontWeight: FontWeight.bold,
                            color: _letterColorAnimations[index].value,
                            letterSpacing: letter == ' ' ? 0 : 1.5,
                            shadows: [
                              Shadow(
                                blurRadius:
                                    10 +
                                    5 * _letterScaleAnimations[index].value,
                                color: Colors.black26,
                                offset: Offset(
                                  sin(_letterRotationAnimations[index].value) *
                                      2,
                                  3 +
                                      cos(
                                            _letterRotationAnimations[index]
                                                .value,
                                          ) *
                                          2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
