import 'package:flutter/material.dart';
import '../../models/room.dart';

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
    return AlertDialog(
      title: const Text('Booking Confirmation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You are about to contact the manager for booking:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room: ${room.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Shift: ${shift.toUpperCase()}'),
                Text('Manager: ${managerInfo['name']}'),
                Text('Phone: ${managerInfo['phone']}'),
                Text('Email: ${managerInfo['email']}'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'The manager will assist you with the booking process and answer any questions about the room.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Contact information saved! You can now call or email ${managerInfo['name']} for booking.',
                ),
                duration: const Duration(seconds: 4),
              ),
            );
          },
          child: const Text('Confirm Contact'),
        ),
      ],
    );
  }
}
