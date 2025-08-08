import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class GlowingIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color primaryColor;
  final Color glowColor;
  final double glowRadius;
  final bool animate;
  final Duration animationDuration;
  final Color? backgroundColor;
  final double backgroundRadius;
  final bool showPulse;
  final List<Color>? gradientColors;

  const GlowingIcon({
    super.key,
    required this.icon,
    this.size = 48,
    this.primaryColor = Colors.white,
    this.glowColor = Colors.blue,
    this.glowRadius = 10,
    this.animate = true,
    this.animationDuration = const Duration(seconds: 2),
    this.backgroundColor,
    this.backgroundRadius = 25,
    this.showPulse = false,
    this.gradientColors,
  });

  @override
  State<GlowingIcon> createState() => _GlowingIconState();
}

class _GlowingIconState extends State<GlowingIcon>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _rotationController.repeat();
    }

    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.showPulse ? _pulseAnimation.value : 1.0,
          child: Container(
            width: widget.backgroundRadius * 2,
            height: widget.backgroundRadius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: widget.gradientColors != null
                  ? RadialGradient(
                      colors: widget.gradientColors!,
                      stops: const [0.3, 0.7, 1.0],
                    )
                  : null,
              color: widget.backgroundColor,
              boxShadow: [
                // Multiple layers of glow
                BoxShadow(
                  color: widget.glowColor.withOpacity(0.4),
                  blurRadius: widget.glowRadius,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: widget.glowColor.withOpacity(0.2),
                  blurRadius: widget.glowRadius * 2,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: widget.glowColor.withOpacity(0.1),
                  blurRadius: widget.glowRadius * 3,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.backgroundRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Transform.rotate(
                    angle: widget.animate ? _rotationAnimation.value : 0,
                    child: Icon(
                      widget.icon,
                      size: widget.size,
                      color: widget.primaryColor,
                      shadows: [
                        Shadow(
                          color: widget.glowColor.withOpacity(0.8),
                          blurRadius: 8,
                        ),
                        Shadow(
                          color: widget.glowColor.withOpacity(0.4),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryIconData {
  final IconData icon;
  final Color primaryColor;
  final Color glowColor;
  final List<Color>? gradientColors;
  final bool animate;
  final bool showPulse;

  const CategoryIconData({
    required this.icon,
    this.primaryColor = Colors.white,
    this.glowColor = Colors.blue,
    this.gradientColors,
    this.animate = false,
    this.showPulse = false,
  });
}

class CategoryIcons {
  // Room category icons
  static const Map<String, CategoryIconData> roomIcons = {
    'ac_room': CategoryIconData(
      icon: Icons.ac_unit_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.cyan,
      gradientColors: [
        Color(0xFF00BCD4),
        Color(0xFF0097A7),
        Color(0xFF006064),
      ],
      animate: true,
    ),
    'non_ac_room': CategoryIconData(
      icon: Icons.bed_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.orange,
      gradientColors: [
        Color(0xFFFF9800),
        Color(0xFFE65100),
        Color(0xFFBF360C),
      ],
    ),
    'conference_hall': CategoryIconData(
      icon: Icons.meeting_room_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.purple,
      gradientColors: [
        Color(0xFF9C27B0),
        Color(0xFF7B1FA2),
        Color(0xFF4A148C),
      ],
      showPulse: true,
    ),
  };

  // Vehicle category icons
  static const Map<String, CategoryIconData> vehicleIcons = {
    'bike': CategoryIconData(
      icon: Icons.two_wheeler_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.green,
      gradientColors: [
        Color(0xFF4CAF50),
        Color(0xFF388E3C),
        Color(0xFF1B5E20),
      ],
      animate: true,
    ),
    'car': CategoryIconData(
      icon: Icons.directions_car_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.blue,
      gradientColors: [
        Color(0xFF2196F3),
        Color(0xFF1976D2),
        Color(0xFF0D47A1),
      ],
    ),
    'van': CategoryIconData(
      icon: Icons.airport_shuttle_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.indigo,
      gradientColors: [
        Color(0xFF3F51B5),
        Color(0xFF303F9F),
        Color(0xFF1A237E),
      ],
    ),
    'lorry': CategoryIconData(
      icon: Icons.local_shipping_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.red,
      gradientColors: [
        Color(0xFFF44336),
        Color(0xFFD32F2F),
        Color(0xFFB71C1C),
      ],
      showPulse: true,
    ),
    'three_wheel': CategoryIconData(
      icon: Icons.electric_rickshaw_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.yellow,
      gradientColors: [
        Color(0xFFFFEB3B),
        Color(0xFFFBC02D),
        Color(0xFFE65100),
      ],
    ),
  };

  // Food category icons
  static const Map<String, CategoryIconData> foodIcons = {
    'string_hoppers': CategoryIconData(
      icon: Icons.ramen_dining_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.brown,
      gradientColors: [
        Color(0xFF8D6E63),
        Color(0xFF5D4037),
        Color(0xFF3E2723),
      ],
      animate: true,
    ),
    'milk_hoppers': CategoryIconData(
      icon: Icons.local_dining_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.pink,
      gradientColors: [
        Color(0xFFE91E63),
        Color(0xFFC2185B),
        Color(0xFF880E4F),
      ],
    ),
    'puttu': CategoryIconData(
      icon: Icons.cake_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.deepOrange,
      gradientColors: [
        Color(0xFFFF5722),
        Color(0xFFE64A19),
        Color(0xFFBF360C),
      ],
    ),
    'rice_and_curry': CategoryIconData(
      icon: Icons.rice_bowl_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.amber,
      gradientColors: [
        Color(0xFFFFC107),
        Color(0xFFFF8F00),
        Color(0xFFE65100),
      ],
      showPulse: true,
    ),
  };

  // Goods category icons
  static const Map<String, CategoryIconData> goodsIcons = {
    'iron': CategoryIconData(
      icon: Icons.iron_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.grey,
      gradientColors: [
        Color(0xFF9E9E9E),
        Color(0xFF616161),
        Color(0xFF212121),
      ],
    ),
    'kettle': CategoryIconData(
      icon: Icons.coffee_maker_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.blueGrey,
      gradientColors: [
        Color(0xFF607D8B),
        Color(0xFF455A64),
        Color(0xFF263238),
      ],
    ),
    'rice_cooker': CategoryIconData(
      icon: Icons.kitchen_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.teal,
      gradientColors: [
        Color(0xFF009688),
        Color(0xFF00695C),
        Color(0xFF004D40),
      ],
      animate: true,
    ),
    'bbq_rack': CategoryIconData(
      icon: Icons.outdoor_grill_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.deepPurple,
      gradientColors: [
        Color(0xFF673AB7),
        Color(0xFF512DA8),
        Color(0xFF311B92),
      ],
    ),
    'gas_cooker': CategoryIconData(
      icon: Icons.local_fire_department_rounded,
      primaryColor: Colors.white,
      glowColor: Colors.red,
      gradientColors: [
        Color(0xFFF44336),
        Color(0xFFD32F2F),
        Color(0xFFB71C1C),
      ],
      showPulse: true,
    ),
  };

  // Get icon data for category and type
  static CategoryIconData? getIconData(String category, String type) {
    switch (category.toLowerCase()) {
      case 'rooms':
        return roomIcons[type.toLowerCase().replaceAll(' ', '_')];
      case 'vehicles':
        return vehicleIcons[type.toLowerCase().replaceAll(' ', '_')];
      case 'food':
        return foodIcons[type.toLowerCase().replaceAll(' ', '_')];
      case 'goods':
        return goodsIcons[type.toLowerCase().replaceAll(' ', '_')];
      default:
        return null;
    }
  }

  // Default fallback icons
  static const CategoryIconData defaultRoomIcon = CategoryIconData(
    icon: Icons.hotel_rounded,
    primaryColor: Colors.white,
    glowColor: Colors.blue,
    gradientColors: [Color(0xFF2196F3), Color(0xFF1976D2), Color(0xFF0D47A1)],
  );

  static const CategoryIconData defaultVehicleIcon = CategoryIconData(
    icon: Icons.directions_car_rounded,
    primaryColor: Colors.white,
    glowColor: Colors.green,
    gradientColors: [Color(0xFF4CAF50), Color(0xFF388E3C), Color(0xFF1B5E20)],
  );

  static const CategoryIconData defaultFoodIcon = CategoryIconData(
    icon: Icons.restaurant_rounded,
    primaryColor: Colors.white,
    glowColor: Colors.orange,
    gradientColors: [Color(0xFFFF9800), Color(0xFFE65100), Color(0xFFBF360C)],
  );

  static const CategoryIconData defaultGoodsIcon = CategoryIconData(
    icon: Icons.inventory_2_rounded,
    primaryColor: Colors.white,
    glowColor: Colors.purple,
    gradientColors: [Color(0xFF9C27B0), Color(0xFF7B1FA2), Color(0xFF4A148C)],
  );
}

// Enhanced Glowing Card Widget
class GlowingCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double glowRadius;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const GlowingCard({
    super.key,
    required this.child,
    this.glowColor = Colors.blue,
    this.glowRadius = 10,
    this.backgroundColor,
    this.borderRadius,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.3),
            blurRadius: glowRadius,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: glowColor.withOpacity(0.1),
            blurRadius: glowRadius * 2,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white.withOpacity(0.1),
                borderRadius: borderRadius ?? BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
