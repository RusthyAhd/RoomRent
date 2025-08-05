import 'package:flutter/material.dart';
import '../../models/room.dart';
import '../../models/guest_house_manager.dart';

class ContactInfoDialog extends StatelessWidget {
  final Room? room;
  final GuestHouseManager? manager;

  const ContactInfoDialog({super.key, this.room, this.manager});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        room != null ? 'Contact for ${room!.title}' : 'Contact Manager',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (room != null) ...[
            Text('Room: ${room!.title}'),
            Text(
              'Price: \$${room!.price}/${room!.priceType.replaceAll('per_', '')}',
            ),
            const SizedBox(height: 16),
          ],
          const Text(
            'Contact Information:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (manager != null) ...[
            Text('Manager: ${manager!.name}'),
            Text('Phone: ${manager!.phone}'),
            Text('Email: ${manager!.email}'),
          ] else ...[
            const Text('Manager: Village Guest House'),
            const Text('Phone: +1234567890'),
            const Text('Email: info@villageguesthouse.com'),
          ],
          const SizedBox(height: 8),
          const Text(
            'Available 24/7 for bookings and inquiries',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Here you could implement actual calling or messaging functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Contact information copied! Call or email to book.',
                ),
              ),
            );
          },
          child: const Text('Contact Now'),
        ),
      ],
    );
  }
}
