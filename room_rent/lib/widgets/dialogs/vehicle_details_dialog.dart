import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../widgets/glass_widgets.dart';
import '../../widgets/panorama_room_image.dart';
import 'vehicle_manager_profile_dialog.dart';

class VehicleDetailsDialog extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailsDialog({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: vehicle.title,
      child: Column(
        children: [
          // Vehicle Image with Panorama View
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
              imagePath: vehicle.images.isNotEmpty
                  ? vehicle.images.first
                  : _getDefaultVehicleImage(vehicle.vehicleType),
              roomTitle: vehicle.title,
              height: 200,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // Vehicle Details
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
                          vehicle.location,
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
                        'Rs ${vehicle.price}/Day',
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
                  const SizedBox(height: 16),
                  Text(
                    vehicle.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  const Text(
                    'Choose your preferred manager shift:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
                          text: 'Manager',
                          icon: Icons.phone,
                          color: Colors.green,
                          isPrimary: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showDayManagerProfile(context, vehicle);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassActionButton(
                          text: 'Hotline',
                          icon: Icons.support_agent,
                          color: Colors.red,
                          isPrimary: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showManagerProfile(context, vehicle, 'night');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManagerProfile(
    BuildContext context,
    Vehicle vehicle,
    String shift,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          VehicleManagerProfileDialog(vehicle: vehicle, shift: shift),
    );
  }

  void _showDayManagerProfile(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => VehicleDayManagerProfileDialog(vehicle: vehicle),
    );
  }

  String _getDefaultVehicleImage(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'bike':
      case 'motorcycle':
        return 'assets/images/motorcycle.jpg';
      case 'car':
        return 'assets/images/car.jpg';
      case 'van':
        return 'assets/images/van.jpg';
      case 'lorry':
      case 'truck':
        return 'assets/images/lorry.jpg';
      case 'three_wheel':
        return 'assets/images/three wheel.jpg';
      default:
        return 'assets/images/motorcycle.jpg';
    }
  }
}
