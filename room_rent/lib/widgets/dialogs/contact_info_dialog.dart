import 'package:flutter/material.dart';
import '../../models/room.dart';
import '../../models/guest_house_manager.dart';
import '../../widgets/glass_widgets.dart';

class ContactInfoDialog extends StatelessWidget {
  final Room? room;
  final GuestHouseManager? manager;

  const ContactInfoDialog({super.key, this.room, this.manager});

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: room != null ? 'Contact for ${room!.title}' : 'Contact Manager',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (room != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.3),
                      Colors.greenAccent.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.greenAccent.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room: ${room!.title}',
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
                      'Price: \$${room!.price}/${room!.priceType.replaceAll('per_', '')}',
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
            ],
            const Text(
              'Contact Information:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (manager != null) ...[
                    _buildContactItem('Manager:', manager!.name),
                    _buildContactItem('Phone:', manager!.phone),
                    _buildContactItem('Email:', manager!.email),
                  ] else ...[
                    _buildContactItem('Manager:', 'Village Guest House'),
                    _buildContactItem('Phone:', '+1234567890'),
                    _buildContactItem('Email:', 'info@villageguesthouse.com'),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Available 24/7 for bookings and inquiries',
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
                    text: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassActionButton(
                    text: 'Contact Now',
                    isPrimary: true,
                    color: Colors.blue,
                    icon: Icons.contact_phone,
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Contact information copied! Call or email to book.',
                          ),
                          backgroundColor: Colors.green,
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

  Widget _buildContactItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
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
    );
  }
}
