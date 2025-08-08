import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/room.dart';
import '../../widgets/glass_widgets.dart';

class DayManagerProfileDialog extends StatelessWidget {
  final Room room;

  const DayManagerProfileDialog({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    // Day shift manager data
    const managerInfo = {
      'name': 'Sinah Rajhi',
      'position': 'Manager',
      'phone': '+94757791779',
      'experience': '2 years',
      'availability': '6.00 AM-6.00 PM',
      'languages': 'English, Tamil and Sinhala',
      'rating': '4.7',
    };

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
                            'assets/images/day-manager.jpeg',
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

                    // Position Badge
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade600,
                            Colors.amber.shade500,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.4),
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
                          fontSize: 13,
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

                    // Rating Section
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
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

                    // Manager Details with better spacing
                    Column(
                      children: [
                        _buildManagerDetailItem(
                          Icons.phone,
                          'Phone',
                          managerInfo['phone']!,
                          Colors.orange,
                        ),
                        const SizedBox(height: 14),
                        _buildManagerDetailItem(
                          Icons.schedule,
                          'Availability',
                          managerInfo['availability']!,
                          Colors.orange,
                        ),
                        const SizedBox(height: 14),
                        _buildManagerDetailItem(
                          Icons.work,
                          'Experience',
                          managerInfo['experience']!,
                          Colors.orange,
                        ),
                        const SizedBox(height: 14),
                        _buildManagerDetailItem(
                          Icons.language,
                          'Languages',
                          managerInfo['languages']!,
                          Colors.orange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Action Buttons with better spacing
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Center(
                child: GlassActionButton(
                  text: 'Contact for Booking',
                  icon: Icons.contact_phone,
                  onPressed: () {
                    _showContactOptions(context, managerInfo);
                  },
                ),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
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
                  text: 'Manager',
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
                  color: Colors.orange,
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
