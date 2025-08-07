import 'package:flutter/material.dart';
import '../../models/traditional_food.dart';

class TraditionalFoodDetailsDialog extends StatefulWidget {
  final TraditionalFood food;

  const TraditionalFoodDetailsDialog({super.key, required this.food});

  @override
  State<TraditionalFoodDetailsDialog> createState() =>
      _TraditionalFoodDetailsDialogState();
}

class _TraditionalFoodDetailsDialogState
    extends State<TraditionalFoodDetailsDialog>
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
                                  Colors.green.withOpacity(0.3),
                                  Colors.green.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getFoodIcon(widget.food.foodType),
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
                                  widget.food.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (widget.food.variety != null)
                                  Text(
                                    _getVarietyName(widget.food.variety!),
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
                            // Food Images
                            if (widget.food.images.isNotEmpty)
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: AssetImage(widget.food.images.first),
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
                                    Colors.green.withOpacity(0.2),
                                    Colors.green.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.restaurant,
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
                                          'Rs ${widget.food.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '/${widget.food.priceType.replaceAll('per_', '')}',
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
                                      color: _getSpiceLevelColor(
                                        widget.food.spiceLevel,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      widget.food.spiceLevel.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Food Details
                            _buildDetailSection('Food Information', [
                              _buildDetailItem(
                                Icons.restaurant_menu,
                                'Type',
                                _getFoodTypeName(widget.food.foodType),
                              ),
                              _buildDetailItem(
                                Icons.timer,
                                'Preparation Time',
                                widget.food.preparationTime,
                              ),
                              _buildDetailItem(
                                Icons.local_fire_department,
                                'Spice Level',
                                widget.food.spiceLevel.toUpperCase(),
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Available Times
                            if (widget.food.availableTimes.isNotEmpty)
                              _buildDetailSection(
                                'Available Times',
                                widget.food.availableTimes
                                    .map((time) => _buildTimeChip(time))
                                    .toList(),
                              ),

                            const SizedBox(height: 20),

                            // Dietary Info
                            if (widget.food.dietaryInfo.isNotEmpty)
                              _buildDetailSection(
                                'Dietary Information',
                                widget.food.dietaryInfo
                                    .map((info) => _buildDietaryChip(info))
                                    .toList(),
                              ),

                            const SizedBox(height: 20),

                            // Ingredients
                            if (widget.food.ingredients.isNotEmpty)
                              _buildDetailSection('Ingredients', [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: widget.food.ingredients
                                      .map(
                                        (ingredient) =>
                                            _buildIngredientChip(ingredient),
                                      )
                                      .toList(),
                                ),
                              ]),

                            const SizedBox(height: 20),

                            // Description
                            _buildDetailSection('Description', [
                              Text(
                                widget.food.description,
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
                                widget.food.address,
                              ),
                              _buildDetailItem(
                                Icons.place,
                                'Area',
                                widget.food.location,
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Provider Information
                            _buildDetailSection('Provider Information', [
                              _buildDetailItem(
                                Icons.person,
                                'Name',
                                widget.food.provider.name,
                              ),
                              _buildDetailItem(
                                Icons.phone,
                                'Phone',
                                widget.food.provider.phone,
                              ),
                              _buildDetailItem(
                                Icons.email,
                                'Email',
                                widget.food.provider.email,
                              ),
                              _buildDetailItem(
                                Icons.star,
                                'Rating',
                                '${widget.food.provider.rating.toStringAsFixed(1)}/5.0',
                              ),
                            ]),

                            const SizedBox(height: 32),

                            // Order Now Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _showOrderDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Order Now',
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

  Widget _buildTimeChip(String time) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Text(
        time.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDietaryChip(String dietary) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
      ),
      child: Text(
        dietary.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildIngredientChip(String ingredient) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
      ),
      child: Text(
        ingredient,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getSpiceLevelColor(String spiceLevel) {
    switch (spiceLevel.toLowerCase()) {
      case 'mild':
        return Colors.green.withOpacity(0.3);
      case 'medium':
        return Colors.orange.withOpacity(0.3);
      case 'hot':
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  IconData _getFoodIcon(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'string_hoppers':
        return Icons.ramen_dining;
      case 'milk_hoppers':
        return Icons.breakfast_dining;
      case 'puttu':
        return Icons.rice_bowl;
      case 'rice_and_curry':
        return Icons.restaurant;
      default:
        return Icons.restaurant_menu;
    }
  }

  String _getFoodTypeName(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'string_hoppers':
        return 'String Hoppers';
      case 'milk_hoppers':
        return 'Milk Hoppers';
      case 'puttu':
        return 'Puttu';
      case 'rice_and_curry':
        return 'Rice & Curry';
      default:
        return foodType;
    }
  }

  String _getVarietyName(String variety) {
    switch (variety.toLowerCase()) {
      case 'chicken':
        return 'Chicken Curry';
      case 'fish':
        return 'Fish Curry';
      case 'beef':
        return 'Beef Curry';
      case 'sea_foods':
        return 'Sea Food Curry';
      default:
        return variety;
    }
  }

  void _showOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TraditionalFoodOrderDialog(food: widget.food),
    );
  }
}

class TraditionalFoodOrderDialog extends StatelessWidget {
  final TraditionalFood food;

  const TraditionalFoodOrderDialog({super.key, required this.food});

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
              'Order Placed!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order for ${food.title} has been sent to the provider.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
