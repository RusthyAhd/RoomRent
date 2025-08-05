import 'package:flutter/material.dart';
import '../../models/room.dart';
import '../../widgets/glass_widgets.dart';

class ContactConfirmationDialog extends StatelessWidget {
  final Room room;
  final Map<String, String> managerInfo;
  final String shift;

  const ContactConfirmationDialog({
    super.key,
    required this.room,
    required this.managerInfo,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: 'Booking Confirmation',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You are about to contact the manager for booking:',
              style: TextStyle(
                fontSize: 14,
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.lightBlueAccent.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.lightBlueAccent.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room: ${room.title}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
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
                  Text(
                    'Shift: ${shift.toUpperCase()}',
                    style: const TextStyle(
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
                  Text(
                    'Manager: ${managerInfo['name']}',
                    style: const TextStyle(
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
                  Text(
                    'Phone: ${managerInfo['phone']}',
                    style: const TextStyle(
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
                  Text(
                    'Email: ${managerInfo['email']}',
                    style: const TextStyle(
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
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The manager will assist you with the booking process and answer any questions about the room.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white60,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GlassActionButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassActionButton(
                    text: 'Confirm Contact',
                    isPrimary: true,
                    color: Colors.blue,
                    icon: Icons.check,
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Contact information saved! You can now call or email ${managerInfo['name']} for booking.',
                          ),
                          duration: const Duration(seconds: 4),
                          backgroundColor: Colors.green.withOpacity(0.8),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
