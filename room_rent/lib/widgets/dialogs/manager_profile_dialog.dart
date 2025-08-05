import 'package:flutter/material.dart';
import '../../models/room.dart';
import 'contact_confirmation_dialog.dart';

class ManagerProfileDialog extends StatelessWidget {
  final Room room;
  final String shift;

  const ManagerProfileDialog({
    super.key,
    required this.room,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    // Define manager data for day and night shifts
    final Map<String, Map<String, String>> managerData = {
      'day': {
        'name': 'John Smith',
        'phone': '+1234567890',
        'email': 'john.smith@villageguesthouse.com',
        'experience': '8 years',
        'specialization': 'Guest Services & Day Operations',
        'availability': '6:00 AM - 6:00 PM',
        'languages': 'English, Spanish',
      },
      'night': {
        'name': 'Maria Rodriguez',
        'phone': '+1987654321',
        'email': 'maria.rodriguez@villageguesthouse.com',
        'experience': '6 years',
        'specialization': 'Night Security & Guest Assistance',
        'availability': '6:00 PM - 6:00 AM',
        'languages': 'English, French',
      },
    };

    final managerInfo = managerData[shift]!;
    final isDay = shift == 'day';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with shift indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDay
                      ? [
                          Colors.orange.withOpacity(0.8),
                          Colors.amber.withOpacity(0.8),
                        ]
                      : [
                          Colors.indigo.withOpacity(0.8),
                          Colors.purple.withOpacity(0.8),
                        ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isDay ? Icons.wb_sunny : Icons.nightlight_round,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${shift.toUpperCase()} SHIFT MANAGER',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Manager Profile Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Manager Image
                    CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/manager.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[600],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Manager Name
                    Text(
                      managerInfo['name']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Specialization
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDay
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDay ? Colors.orange : Colors.indigo,
                        ),
                      ),
                      child: Text(
                        managerInfo['specialization']!,
                        style: TextStyle(
                          color: isDay ? Colors.orange : Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Manager Details
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildManagerDetailItem(
                              Icons.phone,
                              'Phone',
                              managerInfo['phone']!,
                              isDay ? Colors.orange : Colors.indigo,
                            ),
                            _buildManagerDetailItem(
                              Icons.email,
                              'Email',
                              managerInfo['email']!,
                              isDay ? Colors.orange : Colors.indigo,
                            ),
                            _buildManagerDetailItem(
                              Icons.schedule,
                              'Availability',
                              managerInfo['availability']!,
                              isDay ? Colors.orange : Colors.indigo,
                            ),
                            _buildManagerDetailItem(
                              Icons.work,
                              'Experience',
                              managerInfo['experience']!,
                              isDay ? Colors.orange : Colors.indigo,
                            ),
                            _buildManagerDetailItem(
                              Icons.language,
                              'Languages',
                              managerInfo['languages']!,
                              isDay ? Colors.orange : Colors.indigo,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Room Info Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room: ${room.title}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Price: \$${room.price}/${room.priceType.replaceAll('per_', '')}',
                        ),
                        Text('Shift: ${shift.toUpperCase()}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Contact Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showContactConfirmation(
                          context,
                          room,
                          managerInfo,
                          shift,
                        );
                      },
                      icon: const Icon(Icons.contact_phone),
                      label: const Text('Contact for Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDay ? Colors.orange : Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Back Button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // You might want to import and show RoomDetailsDialog here
                    },
                    child: const Text('Back to Room Details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagerDetailItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactConfirmation(
    BuildContext context,
    Room room,
    Map<String, String> managerInfo,
    String shift,
  ) {
    showDialog(
      context: context,
      builder: (context) => ContactConfirmationDialog(
        room: room,
        managerInfo: managerInfo,
        shift: shift,
      ),
    );
  }
}
