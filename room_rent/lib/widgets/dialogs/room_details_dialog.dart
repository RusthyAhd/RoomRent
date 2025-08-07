import 'package:flutter/material.dart';
import '../../models/room.dart';
import '../../widgets/glass_widgets.dart';
import '../../widgets/panorama_room_image.dart';
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
          // Room Image with Panorama View
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: PanoramaRoomImage(
              imagePath: room.images.isNotEmpty
                  ? room.images.first
                  : 'assets/images/ac room.jpg',
              roomTitle: room.title,
              height: 200,
              borderRadius: BorderRadius.circular(16),
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
                  'Choose Your Preferred Time:',
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
                        text: 'Morning',
                        icon: Icons.wb_sunny,
                        color: Colors.orange,
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
                        text: 'Night',
                        icon: Icons.nightlight_round,
                        color: Colors.indigo,
                        isPrimary: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showManagerProfile(context, room, 'night');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GlassActionButton(
                  text: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
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
}
