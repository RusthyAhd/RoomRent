import 'package:flutter/material.dart';
import '../../models/room.dart';
import '../../widgets/glass_widgets.dart';
import '../../widgets/glowing_icon_system.dart';
import 'manager_profile_dialog.dart';
import 'day_manager_profile_dialog.dart';

class RoomDetailsDialog extends StatelessWidget {
  final Room room;

  const RoomDetailsDialog({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: room.title,
      child: Column(
        children: [
          // Room Icon with Glowing Effect
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getRoomGradientColors(room.propertyType),
              ),
              boxShadow: [
                BoxShadow(
                  color: _getRoomGlowColor(room.propertyType).withOpacity(0.3),
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
                icon: _getRoomIcon(room.propertyType),
                size: 80,
                primaryColor: Colors.white,
                glowColor: _getRoomGlowColor(room.propertyType),
                glowRadius: 15,
                animate: true,
                showPulse: true,
              ),
            ),
          ),

          // Room Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          room.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.greenAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Rs ${room.price}/Day',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        room.description,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.white70,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: room.amenities.contains('Air Conditioning')
                            ? [
                                Colors.blue.withOpacity(0.3),
                                Colors.lightBlueAccent.withOpacity(0.2),
                              ]
                            : [
                                Colors.green.withOpacity(0.3),
                                Colors.greenAccent.withOpacity(0.2),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: room.amenities.contains('Air Conditioning')
                            ? Colors.lightBlueAccent
                            : Colors.greenAccent,
                      ),
                    ),
                    child: Text(
                      room.amenities.contains('Air Conditioning')
                          ? 'AC Room'
                          : 'Non-AC Room',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: room.amenities.contains('Air Conditioning')
                            ? Colors.lightBlueAccent
                            : Colors.greenAccent,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Shift Selection Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Choose Your Preferred:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GlassActionButton(
                        text: 'Manager',
                        icon: Icons.phone,
                        color: Colors.green,
                        isPrimary: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showDayManagerProfile(context, room);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassActionButton(
                        text: 'Hotline',
                        icon: Icons.support_agent,
                        color: Colors.red,
                        isPrimary: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showManagerProfile(context, room, 'night');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showManagerProfile(BuildContext context, Room room, String shift) {
    showDialog(
      context: context,
      builder: (context) => ManagerProfileDialog(room: room, shift: shift),
    );
  }

  void _showDayManagerProfile(BuildContext context, Room room) {
    showDialog(
      context: context,
      builder: (context) => DayManagerProfileDialog(room: room),
    );
  }

  // Helper methods for room icons and colors
  IconData _getRoomIcon(String propertyType) {
    switch (propertyType.toLowerCase()) {
      case 'apartment':
        return Icons.apartment_rounded;
      case 'house':
        return Icons.house_rounded;
      case 'room':
        return Icons.bedroom_parent_rounded;
      case 'studio':
        return Icons.home_work_rounded;
      case 'villa':
        return Icons.villa_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  Color _getRoomGlowColor(String propertyType) {
    switch (propertyType.toLowerCase()) {
      case 'apartment':
        return const Color(0xFF2196F3);
      case 'house':
        return const Color(0xFF4CAF50);
      case 'room':
        return const Color(0xFFFF9800);
      case 'studio':
        return const Color(0xFF9C27B0);
      case 'villa':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF2196F3);
    }
  }

  List<Color> _getRoomGradientColors(String propertyType) {
    switch (propertyType.toLowerCase()) {
      case 'apartment':
        return [
          const Color(0xFF2196F3).withOpacity(0.8),
          const Color(0xFF1976D2).withOpacity(0.9),
          const Color(0xFF0D47A1),
        ];
      case 'house':
        return [
          const Color(0xFF4CAF50).withOpacity(0.8),
          const Color(0xFF388E3C).withOpacity(0.9),
          const Color(0xFF1B5E20),
        ];
      case 'room':
        return [
          const Color(0xFFFF9800).withOpacity(0.8),
          const Color(0xFFE65100).withOpacity(0.9),
          const Color(0xFFBF360C),
        ];
      case 'studio':
        return [
          const Color(0xFF9C27B0).withOpacity(0.8),
          const Color(0xFF7B1FA2).withOpacity(0.9),
          const Color(0xFF4A148C),
        ];
      case 'villa':
        return [
          const Color(0xFFF44336).withOpacity(0.8),
          const Color(0xFFD32F2F).withOpacity(0.9),
          const Color(0xFFB71C1C),
        ];
      default:
        return [
          const Color(0xFF2196F3).withOpacity(0.8),
          const Color(0xFF1976D2).withOpacity(0.9),
          const Color(0xFF0D47A1),
        ];
    }
  }
}
