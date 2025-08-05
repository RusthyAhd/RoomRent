import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/room.dart';
import '../../widgets/glass_widgets.dart';

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
        'position': 'Day Shift Manager',
        'phone': '+1234567890',
        'email': 'john.smith@villageguesthouse.com',
        'experience': '8 years',
        'specialization': 'Guest Services & Day Operations',
        'availability': '6:00 AM - 6:00 PM',
        'languages': 'English, Spanish',
        'rating': '4.8',
      },
      'night': {
        'name': 'Maria Rodriguez',
        'position': 'Night Shift Manager',
        'phone': '+1987654321',
        'email': 'maria.rodriguez@villageguesthouse.com',
        'experience': '6 years',
        'specialization': 'Night Security & Guest Assistance',
        'availability': '6:00 PM - 6:00 AM',
        'languages': 'English, French',
        'rating': '4.9',
      },
    };

    final managerInfo = managerData[shift]!;
    final isDay = shift == 'day';

    return GlassDialog(
      child: Column(
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
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/manager.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white70,
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

                  // Position - Clear and Visible
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDay
                            ? [Colors.orange.shade600, Colors.amber.shade500]
                            : [Colors.indigo.shade600, Colors.purple.shade500],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: (isDay ? Colors.orange : Colors.indigo)
                              .withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      managerInfo['position']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rating Section with Proper Margin
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          managerInfo['rating']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '/ 5.0',
                          style: TextStyle(
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Specialization with Better Margins
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDay
                            ? [
                                Colors.orange.withOpacity(0.25),
                                Colors.amber.withOpacity(0.15),
                              ]
                            : [
                                Colors.indigo.withOpacity(0.25),
                                Colors.purple.withOpacity(0.15),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (isDay ? Colors.orange : Colors.indigo)
                            .withOpacity(0.6),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      managerInfo['specialization']!,
                      style: TextStyle(
                        color: isDay
                            ? Colors.orange.shade100
                            : Colors.indigo.shade100,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
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
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                        'Price: \$${room.price}/${room.priceType.replaceAll('per_', '')}',
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Contact Button
                SizedBox(
                  width: double.infinity,
                  child: GlassActionButton(
                    text: 'Contact for Booking',
                    icon: Icons.contact_phone,
                    color: isDay ? Colors.orange : Colors.indigo,
                    isPrimary: true,
                    onPressed: () {
                      _showContactOptions(context, managerInfo, isDay);
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Back Button
                GlassActionButton(
                  text: 'Back to Room Details',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
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
              color: color.withOpacity(0.2),
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
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactOptions(
    BuildContext context,
    Map<String, String> managerInfo,
    bool isDay,
  ) {
    showDialog(
      context: context,
      builder: (context) => GlassDialog(
        title: 'Contact Manager',
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How would you like to contact ${managerInfo['name']}?',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Call Option
              SizedBox(
                width: double.infinity,
                child: GlassActionButton(
                  text: 'Call',
                  icon: Icons.phone,
                  color: Colors.green,
                  isPrimary: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _makePhoneCall(managerInfo['phone']!);
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Message Option
              SizedBox(
                width: double.infinity,
                child: GlassActionButton(
                  text: 'Send Message',
                  icon: Icons.message,
                  color: isDay ? Colors.orange : Colors.indigo,
                  isPrimary: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _sendMessage(managerInfo['phone']!);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Cancel Button
              GlassActionButton(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Handle error - could show a snackbar or dialog
      debugPrint('Could not launch phone call to $phoneNumber');
    }
  }

  Future<void> _sendMessage(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      // Handle error - could show a snackbar or dialog
      debugPrint('Could not launch SMS to $phoneNumber');
    }
  }
}
