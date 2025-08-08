import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/traditional_food.dart';
import '../../widgets/glass_widgets.dart';

class TraditionalFoodManagerProfileDialog extends StatelessWidget {
  final TraditionalFood food;
  final String shift;

  const TraditionalFoodManagerProfileDialog({
    super.key,
    required this.food,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    // Define manager data for day and night shifts - SAME AS ROOMS
    final Map<String, Map<String, String>> managerData = {
      'day': {
        'name': 'Sinah Rajhi',
        'position': 'Manager',
        'phone': '+94757791779',
        'email': 'john.smith@villageguesthouse.com',
        'experience': '8 years',
        'specialization': 'Guest Services & Day Operations',
        'availability': '6:00 AM - 6:00 PM',
        'languages': 'English, Tamil and Sinhala',
        'rating': '4.8',
      },
      'night': {
        'name': 'Mohamed Riyal',
        'position': 'Proprietor',
        'phone': '+94750353394',
        'email': 'maria.rodriguez@villageguesthouse.com',
        'experience': '6 years',
        'specialization': 'Night Security & Guest Assistance',
        'availability': '6:00 PM - 6:00 AM',
        'languages': 'English, Tamil and Sinhala',
        'rating': '4.9',
      },
    };

    final managerInfo = managerData[shift]!;
    final isDay = shift == 'day';

    return GlassDialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Manager Profile Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Column(
                  children: [
                    // Manager Image
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: ClipOval(
                          child: Image.asset(
                            isDay
                                ? 'assets/images/day-manager.jpeg'
                                : 'assets/images/night-manager.jpeg',
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 45,
                                color: Colors.white70,
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Manager Name
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Text(
                        managerInfo['name']!,
                        style: const TextStyle(
                          fontSize: 22,
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
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Position
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDay
                              ? [Colors.orange, Colors.orange.shade700]
                              : [Colors.indigo, Colors.indigo.shade700],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (isDay ? Colors.orange : Colors.indigo)
                                .withOpacity(0.4),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        managerInfo['position']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Rating Section - positioned right after title
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber.shade400,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            managerInfo['rating']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
                              fontSize: 13,
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

                    // Contact Info Cards
                    _buildInfoCard(
                      icon: Icons.phone,
                      title: 'Phone',
                      content: managerInfo['phone']!,
                      color: Colors.green,
                    ),
                    _buildInfoCard(
                      icon: Icons.schedule,
                      title: 'Available',
                      content: managerInfo['availability']!,
                      color: Colors.purple,
                    ),
                    _buildInfoCard(
                      icon: Icons.language,
                      title: 'Languages',
                      content: managerInfo['languages']!,
                      color: Colors.teal,
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
                  // Contact Options Row
                  Row(
                    children: [
                      // Call Option
                      Expanded(
                        child: GlassActionButton(
                          text: 'Manager',
                          icon: Icons.phone,
                          color: Colors.green,
                          isPrimary: true,
                          onPressed: () {
                            _makePhoneCall(managerInfo['phone']!);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Message Option
                      Expanded(
                        child: GlassActionButton(
                          text: 'Message',
                          icon: Icons.sms,
                          color: Colors.blue,
                          isPrimary: true,
                          onPressed: () {
                            _sendMessage(managerInfo['phone']!);
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
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
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
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendMessage(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }
}
