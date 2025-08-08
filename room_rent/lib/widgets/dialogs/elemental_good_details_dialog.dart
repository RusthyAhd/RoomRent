import 'package:flutter/material.dart';
import '../../models/elemental_good.dart';
import '../../widgets/glass_widgets.dart';
import '../../widgets/glowing_icon_system.dart';
import 'elemental_good_manager_profile_dialog.dart';

class ElementalGoodDetailsDialog extends StatelessWidget {
  final ElementalGood good;

  const ElementalGoodDetailsDialog({super.key, required this.good});

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
                    // Good Icon with Glowing Effect
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _getGoodGradientColors(good.goodType),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getGoodGlowColor(
                              good.goodType,
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
                          icon: _getGoodIcon(good.goodType),
                          size: 80,
                          primaryColor: Colors.white,
                          glowColor: _getGoodGlowColor(good.goodType),
                          glowRadius: 15,
                          animate: true,
                          showPulse: true,
                        ),
                      ),
                    ),

                    // Good Title
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        good.title,
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
                        '${good.price} LKR per unit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[300],
                        ),
                      ),
                    ),

                    // Description
                    if (good.description.isNotEmpty) ...[
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
                          good.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],

                    // Category
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              good.goodType,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Availability Badge
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: good.isAvailable
                              ? [Colors.green, Colors.green.shade700]
                              : [Colors.red, Colors.red.shade700],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (good.isAvailable ? Colors.green : Colors.red)
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
                            good.isAvailable
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            good.isAvailable
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
                        builder: (context) => ElementalGoodManagerProfileDialog(
                          good: good,
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

  // Helper methods for goods icons and colors
  IconData _getGoodIcon(String goodType) {
    switch (goodType.toLowerCase()) {
      case 'iron':
        return Icons.iron_rounded;
      case 'kettle':
        return Icons.coffee_maker_rounded;
      case 'rice_cooker':
        return Icons.kitchen_rounded;
      case 'bbq_rack':
        return Icons.outdoor_grill_rounded;
      case 'gas_cooker_with_cylinder':
      case 'gas_cooker':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  Color _getGoodGlowColor(String goodType) {
    switch (goodType.toLowerCase()) {
      case 'iron':
        return const Color(0xFF9E9E9E);
      case 'kettle':
        return const Color(0xFF607D8B);
      case 'rice_cooker':
        return const Color(0xFF009688);
      case 'bbq_rack':
        return const Color(0xFF673AB7);
      case 'gas_cooker_with_cylinder':
      case 'gas_cooker':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9C27B0);
    }
  }

  List<Color> _getGoodGradientColors(String goodType) {
    switch (goodType.toLowerCase()) {
      case 'iron':
        return [
          const Color(0xFF9E9E9E).withOpacity(0.8),
          const Color(0xFF616161).withOpacity(0.9),
          const Color(0xFF212121),
        ];
      case 'kettle':
        return [
          const Color(0xFF607D8B).withOpacity(0.8),
          const Color(0xFF455A64).withOpacity(0.9),
          const Color(0xFF263238),
        ];
      case 'rice_cooker':
        return [
          const Color(0xFF009688).withOpacity(0.8),
          const Color(0xFF00695C).withOpacity(0.9),
          const Color(0xFF004D40),
        ];
      case 'bbq_rack':
        return [
          const Color(0xFF673AB7).withOpacity(0.8),
          const Color(0xFF512DA8).withOpacity(0.9),
          const Color(0xFF311B92),
        ];
      case 'gas_cooker_with_cylinder':
      case 'gas_cooker':
        return [
          const Color(0xFFF44336).withOpacity(0.8),
          const Color(0xFFD32F2F).withOpacity(0.9),
          const Color(0xFFB71C1C),
        ];
      default:
        return [
          const Color(0xFF9C27B0).withOpacity(0.8),
          const Color(0xFF7B1FA2).withOpacity(0.9),
          const Color(0xFF4A148C),
        ];
    }
  }
}
