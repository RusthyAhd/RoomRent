import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../widgets/glass_widgets.dart';
import '../../widgets/glowing_icon_system.dart';
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
          // Vehicle Icon with Glowing Effect
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getVehicleGradientColors(vehicle.vehicleType),
              ),
              boxShadow: [
                BoxShadow(
                  color: _getVehicleGlowColor(
                    vehicle.vehicleType,
                  ).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: GlowingIcon(
                icon: _getVehicleIcon(vehicle.vehicleType),
                size: 80,
                primaryColor: Colors.white,
                glowColor: _getVehicleGlowColor(vehicle.vehicleType),
                glowRadius: 15,
                animate: true,
                showPulse: true,
              ),
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

  // Helper methods for vehicle icons and colors
  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'bike':
      case 'motorcycle':
        return Icons.two_wheeler_rounded;
      case 'car':
        return Icons.directions_car_rounded;
      case 'van':
        return Icons.airport_shuttle_rounded;
      case 'lorry':
      case 'truck':
        return Icons.local_shipping_rounded;
      case 'three_wheel':
        return Icons.electric_rickshaw_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }

  Color _getVehicleGlowColor(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'bike':
      case 'motorcycle':
        return const Color(0xFF4CAF50);
      case 'car':
        return const Color(0xFF2196F3);
      case 'van':
        return const Color(0xFF3F51B5);
      case 'lorry':
      case 'truck':
        return const Color(0xFFF44336);
      case 'three_wheel':
        return const Color(0xFFFFEB3B);
      default:
        return const Color(0xFF2196F3);
    }
  }

  List<Color> _getVehicleGradientColors(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'bike':
      case 'motorcycle':
        return [
          const Color(0xFF4CAF50).withOpacity(0.8),
          const Color(0xFF388E3C).withOpacity(0.9),
          const Color(0xFF1B5E20),
        ];
      case 'car':
        return [
          const Color(0xFF2196F3).withOpacity(0.8),
          const Color(0xFF1976D2).withOpacity(0.9),
          const Color(0xFF0D47A1),
        ];
      case 'van':
        return [
          const Color(0xFF3F51B5).withOpacity(0.8),
          const Color(0xFF303F9F).withOpacity(0.9),
          const Color(0xFF1A237E),
        ];
      case 'lorry':
      case 'truck':
        return [
          const Color(0xFFF44336).withOpacity(0.8),
          const Color(0xFFD32F2F).withOpacity(0.9),
          const Color(0xFFB71C1C),
        ];
      case 'three_wheel':
        return [
          const Color(0xFFFFEB3B).withOpacity(0.8),
          const Color(0xFFFBC02D).withOpacity(0.9),
          const Color(0xFFE65100),
        ];
      default:
        return [
          const Color(0xFF2196F3).withOpacity(0.8),
          const Color(0xFF1976D2).withOpacity(0.9),
          const Color(0xFF0D47A1),
        ];
    }
  }
}
