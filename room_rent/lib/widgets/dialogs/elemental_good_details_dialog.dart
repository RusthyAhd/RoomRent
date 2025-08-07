import 'package:flutter/material.dart';
import '../../models/elemental_good.dart';

class ElementalGoodDetailsDialog extends StatefulWidget {
  final ElementalGood good;

  const ElementalGoodDetailsDialog({super.key, required this.good});

  @override
  State<ElementalGoodDetailsDialog> createState() =>
      _ElementalGoodDetailsDialogState();
}

class _ElementalGoodDetailsDialogState extends State<ElementalGoodDetailsDialog>
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
                                  Colors.purple.withOpacity(0.3),
                                  Colors.purple.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getGoodIcon(widget.good.goodType),
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
                                  widget.good.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${widget.good.brand} ${widget.good.model}',
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
                            // Good Images
                            if (widget.good.images.isNotEmpty)
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: AssetImage(widget.good.images.first),
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
                                    Colors.purple.withOpacity(0.2),
                                    Colors.purple.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.purple.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.price_change,
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
                                              'Rs ${widget.good.price.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '/${widget.good.priceType.replaceAll('per_', '')}',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getConditionColor(
                                            widget.good.condition,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          widget.good.condition.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (widget.good.requiresDeposit &&
                                      widget.good.depositAmount != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.orange.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.security,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Security Deposit: Rs ${widget.good.depositAmount!.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Good Details
                            _buildDetailSection('Item Information', [
                              _buildDetailItem(
                                Icons.category,
                                'Type',
                                _getGoodTypeName(widget.good.goodType),
                              ),
                              _buildDetailItem(
                                Icons.business,
                                'Brand',
                                widget.good.brand,
                              ),
                              _buildDetailItem(
                                Icons.model_training,
                                'Model',
                                widget.good.model,
                              ),
                              _buildDetailItem(
                                Icons.info,
                                'Condition',
                                widget.good.condition.toUpperCase(),
                              ),
                              _buildDetailItem(
                                Icons.power,
                                'Power Source',
                                widget.good.powerSource,
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Specifications
                            if (widget.good.specifications.isNotEmpty)
                              _buildDetailSection(
                                'Specifications',
                                widget.good.specifications
                                    .map(
                                      (spec) => _buildSpecificationChip(spec),
                                    )
                                    .toList(),
                              ),

                            const SizedBox(height: 20),

                            // Description
                            _buildDetailSection('Description', [
                              Text(
                                widget.good.description,
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
                                widget.good.address,
                              ),
                              _buildDetailItem(
                                Icons.place,
                                'Area',
                                widget.good.location,
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Owner Information
                            _buildDetailSection('Owner Information', [
                              _buildDetailItem(
                                Icons.person,
                                'Name',
                                widget.good.owner.name,
                              ),
                              _buildDetailItem(
                                Icons.phone,
                                'Phone',
                                widget.good.owner.phone,
                              ),
                              _buildDetailItem(
                                Icons.email,
                                'Email',
                                widget.good.owner.email,
                              ),
                              _buildDetailItem(
                                Icons.star,
                                'Rating',
                                '${widget.good.owner.rating.toStringAsFixed(1)}/5.0',
                              ),
                            ]),

                            const SizedBox(height: 32),

                            // Rent Now Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _showRentDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Rent Now',
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
          if (children.length == 1 && children.first is Wrap)
            children.first
          else
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

  Widget _buildSpecificationChip(String spec) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
      ),
      child: Text(
        spec,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
        return Colors.green.withOpacity(0.3);
      case 'like_new':
        return Colors.blue.withOpacity(0.3);
      case 'good':
        return Colors.orange.withOpacity(0.3);
      case 'fair':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  IconData _getGoodIcon(String goodType) {
    switch (goodType.toLowerCase()) {
      case 'iron':
        return Icons.iron;
      case 'kettle':
        return Icons.coffee_maker;
      case 'rice_cooker':
        return Icons.rice_bowl;
      case 'bbq_rack':
        return Icons.outdoor_grill;
      case 'gas_cooker_with_cylinder':
        return Icons.local_fire_department;
      default:
        return Icons.kitchen;
    }
  }

  String _getGoodTypeName(String goodType) {
    switch (goodType.toLowerCase()) {
      case 'iron':
        return 'Iron';
      case 'kettle':
        return 'Kettle';
      case 'rice_cooker':
        return 'Rice Cooker';
      case 'bbq_rack':
        return 'BBQ Rack';
      case 'gas_cooker_with_cylinder':
        return 'Gas Cooker with Cylinder';
      default:
        return goodType;
    }
  }

  void _showRentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ElementalGoodRentDialog(good: widget.good),
    );
  }
}

class ElementalGoodRentDialog extends StatelessWidget {
  final ElementalGood good;

  const ElementalGoodRentDialog({super.key, required this.good});

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
              'Rental Request Sent!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your rental request for ${good.title} has been sent to the owner.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            if (good.requiresDeposit && good.depositAmount != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Note: Security deposit of Rs ${good.depositAmount!.toStringAsFixed(0)} will be required.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
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
