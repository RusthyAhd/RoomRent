import 'package:flutter/material.dart';
import '../../models/traditional_food.dart';
import '../../widgets/glass_widgets.dart';
import '../../widgets/glowing_icon_system.dart';
import 'traditional_food_manager_profile_dialog.dart';

class TraditionalFoodDetailsDialog extends StatelessWidget {
  final TraditionalFood food;

  const TraditionalFoodDetailsDialog({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final currentHour = DateTime.now().hour;
    final isDay = currentHour >= 6 && currentHour < 18;
    final managerShift = isDay ? 'Day Manager' : 'Night Manager';
    final managerName = isDay ? 'Sinah Rajhi' : 'Mohamed Riyal';

    return GlassDialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food Icon with Glowing Effect
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _getFoodGradientColors(food.foodType),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getFoodGlowColor(
                              food.foodType,
                            ).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: GlowingIcon(
                          icon: _getFoodIcon(food.foodType),
                          size: 80,
                          primaryColor: Colors.white,
                          glowColor: _getFoodGlowColor(food.foodType),
                          glowRadius: 15,
                          animate: true,
                          showPulse: true,
                        ),
                      ),
                    ),

                    // Food Title
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        food.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Price
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        '${food.price} LKR per serving',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[300],
                        ),
                      ),
                    ),

                    // Description
                    if (food.description.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          food.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],

                    // Ingredients
                    if (food.ingredients.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: food.ingredients.map((ingredient) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    ingredient,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Availability Badge
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: food.isAvailable
                              ? [Colors.green, Colors.green.shade700]
                              : [Colors.red, Colors.red.shade700],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (food.isAvailable ? Colors.green : Colors.red)
                                    .withOpacity(0.4),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            food.isAvailable
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            food.isAvailable
                                ? 'Available'
                                : 'Currently Unavailable',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Manager Info Section
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isDay ? Icons.wb_sunny : Icons.nights_stay,
                                color: isDay ? Colors.orange : Colors.indigo,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Current $managerShift',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            managerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isDay ? '6:00 AM - 6:00 PM' : '6:00 PM - 6:00 AM',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Manager Profile Button
                  GlassActionButton(
                    text: 'Manager',
                    icon: Icons.person,
                    color: isDay ? Colors.orange : Colors.indigo,
                    isPrimary: true,
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) =>
                            TraditionalFoodManagerProfileDialog(
                              food: food,
                              shift: isDay ? 'day' : 'night',
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for food icons and colors
  IconData _getFoodIcon(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'string_hoppers':
        return Icons.soup_kitchen_rounded; // More authentic for string hoppers
      case 'milk_hoppers':
        return Icons.breakfast_dining_rounded; // Better for milk hoppers  
      case 'puttu':
        return Icons.grain_rounded; // More authentic for puttu (grain/rice based)
      case 'rice_and_curry':
        return Icons.rice_bowl_rounded; // Perfect for rice and curry
      default:
        return Icons.restaurant_rounded;
    }
  }

  Color _getFoodGlowColor(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'string_hoppers':
        return const Color(0xFF8D6E63);
      case 'milk_hoppers':
        return const Color(0xFFE91E63);
      case 'puttu':
        return const Color(0xFFFF5722);
      case 'rice_and_curry':
        return const Color(0xFFFFC107);
      default:
        return const Color(0xFFFF9800);
    }
  }

  List<Color> _getFoodGradientColors(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'string_hoppers':
        return [
          const Color(0xFF8D6E63).withOpacity(0.8),
          const Color(0xFF5D4037).withOpacity(0.9),
          const Color(0xFF3E2723),
        ];
      case 'milk_hoppers':
        return [
          const Color(0xFFE91E63).withOpacity(0.8),
          const Color(0xFFC2185B).withOpacity(0.9),
          const Color(0xFF880E4F),
        ];
      case 'puttu':
        return [
          const Color(0xFFFF5722).withOpacity(0.8),
          const Color(0xFFE64A19).withOpacity(0.9),
          const Color(0xFFBF360C),
        ];
      case 'rice_and_curry':
        return [
          const Color(0xFFFFC107).withOpacity(0.8),
          const Color(0xFFFF8F00).withOpacity(0.9),
          const Color(0xFFE65100),
        ];
      default:
        return [
          const Color(0xFFFF9800).withOpacity(0.8),
          const Color(0xFFE65100).withOpacity(0.9),
          const Color(0xFFBF360C),
        ];
    }
  }
}
