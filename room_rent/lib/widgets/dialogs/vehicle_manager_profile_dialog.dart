import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../widgets/glass_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class VehicleManagerProfileDialog extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleManagerProfileDialog({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final owner = vehicle.owner;

    return GlassDialog(
      title: 'OWNER Profile',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
                image: owner.profileImage != null
                    ? DecorationImage(
                        image: AssetImage(owner.profileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: owner.profileImage == null
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),

            const SizedBox(height: 20),

            // Name
            Text(
              owner.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Owner Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'VEHICLE OWNER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${owner.rating.toStringAsFixed(1)} (${owner.totalVehicles} vehicles)',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Contact Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.white70, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          owner.email,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.white70, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          owner.phone,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact Buttons
            Row(
              children: [
                Expanded(
                  child: GlassActionButton(
                    onPressed: () async {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: owner.email,
                        queryParameters: {
                          'subject': 'Vehicle Inquiry: ${vehicle.title}',
                        },
                      );
                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri);
                      }
                    },
                    icon: Icons.email,
                    text: 'Email',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassActionButton(
                    onPressed: () async {
                      final Uri phoneUri = Uri(
                        scheme: 'tel',
                        path: owner.phone,
                      );
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      }
                    },
                    icon: Icons.phone,
                    text: 'Call',
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
