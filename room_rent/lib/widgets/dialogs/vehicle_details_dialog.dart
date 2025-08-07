import 'package:flutter/material.dart';
import '../../models/vehicle.dart';

class VehicleDetailsDialog extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailsDialog({super.key, required this.vehicle});

  @override
  State<VehicleDetailsDialog> createState() => _VehicleDetailsDialogState();
}

class _VehicleDetailsDialogState extends State<VehicleDetailsDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                      Color(0xFF667eea),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.withOpacity(0.3),
                                  Colors.orange.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getVehicleIcon(widget.vehicle.vehicleType),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.vehicle.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${widget.vehicle.make} ${widget.vehicle.model}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Vehicle Images
                            if (widget.vehicle.images.isNotEmpty)
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      widget.vehicle.images.first,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 24),

                            // Price Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.withOpacity(0.2),
                                    Colors.orange.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rs ${widget.vehicle.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '/${widget.vehicle.priceType.replaceAll('per_', '')}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Vehicle Details
                            _buildDetailSection('Vehicle Information', [
                              _buildDetailItem(
                                Icons.directions_car,
                                'Type',
                                _getVehicleTypeName(widget.vehicle.vehicleType),
                              ),
                              _buildDetailItem(
                                Icons.calendar_today,
                                'Year',
                                widget.vehicle.year,
                              ),
                              _buildDetailItem(
                                Icons.local_gas_station,
                                'Fuel Type',
                                widget.vehicle.fuelType,
                              ),
                              _buildDetailItem(
                                Icons.people,
                                'Seating Capacity',
                                '${widget.vehicle.seatingCapacity} persons',
                              ),
                              _buildDetailItem(
                                Icons.settings,
                                'Transmission',
                                widget.vehicle.transmissionType,
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Features
                            if (widget.vehicle.features.isNotEmpty)
                              _buildDetailSection(
                                'Features',
                                widget.vehicle.features
                                    .map(
                                      (feature) => _buildFeatureChip(feature),
                                    )
                                    .toList(),
                              ),

                            const SizedBox(height: 20),

                            // Description
                            _buildDetailSection('Description', [
                              Text(
                                widget.vehicle.description,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Location
                            _buildDetailSection('Location', [
                              _buildDetailItem(
                                Icons.location_on,
                                'Address',
                                widget.vehicle.address,
                              ),
                              _buildDetailItem(
                                Icons.place,
                                'Area',
                                widget.vehicle.location,
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Owner Information
                            _buildDetailSection('Owner Information', [
                              _buildDetailItem(
                                Icons.person,
                                'Name',
                                widget.vehicle.owner.name,
                              ),
                              _buildDetailItem(
                                Icons.phone,
                                'Phone',
                                widget.vehicle.owner.phone,
                              ),
                              _buildDetailItem(
                                Icons.email,
                                'Email',
                                widget.vehicle.owner.email,
                              ),
                              _buildDetailItem(
                                Icons.star,
                                'Rating',
                                '${widget.vehicle.owner.rating.toStringAsFixed(1)}/5.0',
                              ),
                            ]),

                            const SizedBox(height: 32),

                            // Book Now Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _showBookingDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Book Now',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white70, size: 16),
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String feature) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1),
      ),
      child: Text(
        feature,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'motorcycle':
        return Icons.motorcycle;
      case 'three_wheel':
        return Icons.electric_rickshaw;
      case 'car':
        return Icons.directions_car;
      case 'van':
        return Icons.airport_shuttle;
      case 'lorry':
        return Icons.local_shipping;
      default:
        return Icons.directions_car;
    }
  }

  String _getVehicleTypeName(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'motorcycle':
        return 'Motor Cycle';
      case 'three_wheel':
        return 'Three Wheeler';
      case 'car':
        return 'Car';
      case 'van':
        return 'Van';
      case 'lorry':
        return 'Lorry';
      default:
        return vehicleType;
    }
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => VehicleBookingDialog(vehicle: widget.vehicle),
    );
  }
}

class VehicleBookingDialog extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleBookingDialog({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Booking Request Sent!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your booking request for ${vehicle.title} has been sent to the owner.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
