import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_categories.dart';
import '../../providers/traditional_food_provider.dart';
import '../../models/traditional_food.dart';
import '../../utils/app_quotes.dart';
import '../../widgets/glowing_icon_system.dart';
import 'food_booking_dialog.dart';

class FoodTypeDialog extends StatelessWidget {
  final TypeInfo typeInfo;
  final String? variety;

  const FoodTypeDialog({super.key, required this.typeInfo, this.variety});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1E3C72).withOpacity(0.95),
              const Color(0xFF2A5298).withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<TraditionalFoodProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  final foods = _getFoodsByType(provider.foods);

                  if (foods.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${AppQuotes.getRandomMotivationalQuote()}\n\nNo ${_getDisplayTitle().toLowerCase()} available',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      return _buildFoodCard(context, foods[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: _getFoodGradientColors(_getDisplayTitle()),
              ),
              boxShadow: [
                BoxShadow(
                  color: _getFoodGlowColor(_getDisplayTitle()).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: GlowingIcon(
                icon: _getFoodIcon(_getDisplayTitle()),
                size: 30,
                primaryColor: Colors.white,
                glowColor: _getFoodGlowColor(_getDisplayTitle()),
                glowRadius: 6,
                animate: true,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDisplayTitle(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getDisplayDescription(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, TraditionalFood food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (food.images.isNotEmpty)
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(food.images.first),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: food.isAvailable
                                  ? Colors.green.withOpacity(0.8)
                                  : Colors.red.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              food.isAvailable ? 'Available' : 'Sold Out',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (food.dietaryInfo.contains('vegetarian'))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Veg',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              food.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        food.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getSpiceLevelColor(food.spiceLevel),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            food.spiceLevel.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  food.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      food.preparationTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.location_on,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        food.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${food.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'per ${food.priceType.replaceAll('per_', '')}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _showBookingDialog(context, food),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Order Now',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<TraditionalFood> _getFoodsByType(List<TraditionalFood> foods) {
    if (variety != null) {
      return foods
          .where(
            (food) => food.foodType == typeInfo.id && food.variety == variety,
          )
          .toList();
    }

    return foods.where((food) => food.foodType == typeInfo.id).toList();
  }

  String _getDisplayTitle() {
    if (variety != null && RiceCurryVarieties.titles.containsKey(variety)) {
      return RiceCurryVarieties.titles[variety]!;
    }
    return typeInfo.title;
  }

  String _getDisplayDescription() {
    if (variety != null &&
        RiceCurryVarieties.descriptions.containsKey(variety)) {
      return RiceCurryVarieties.descriptions[variety]!;
    }
    return typeInfo.description;
  }

  Color _getSpiceLevelColor(String spiceLevel) {
    switch (spiceLevel.toLowerCase()) {
      case 'mild':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hot':
        return Colors.red;
      case 'extra_hot':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  void _showBookingDialog(BuildContext context, TraditionalFood food) {
    showDialog(
      context: context,
      builder: (context) => FoodBookingDialog(food: food),
    );
  }

  Color _getFoodColor() {
    final typeName = typeInfo.title.toLowerCase();
    switch (typeName) {
      case 'puttu':
      case 'hoppers':
      case 'rice':
        return Colors.amber;
      case 'curry':
        return Colors.orange;
      case 'kottu':
        return Colors.deepOrange;
      case 'noodles':
      case 'pasta':
        return Colors.yellow;
      case 'string hoppers':
      case 'bread':
        return Colors.brown;
      case 'soup':
        return Colors.red;
      case 'dessert':
      case 'sweet':
        return Colors.pink;
      case 'beverage':
      case 'drink':
      case 'juice':
        return Colors.lightBlue;
      case 'salad':
        return Colors.green;
      case 'seafood':
      case 'fish':
        return Colors.teal;
      default:
        return Colors.orange;
    }
  }

  List<Color> _getFoodGradientColors([String? type]) {
    final typeName = (type ?? typeInfo.title).toLowerCase();
    switch (typeName) {
      case 'puttu':
      case 'hoppers':
      case 'rice':
        return [Colors.amber.shade300, Colors.amber.shade600];
      case 'curry':
        return [Colors.orange.shade300, Colors.orange.shade600];
      case 'kottu':
        return [Colors.deepOrange.shade300, Colors.deepOrange.shade600];
      case 'noodles':
      case 'pasta':
        return [Colors.yellow.shade300, Colors.yellow.shade600];
      case 'string hoppers':
      case 'bread':
        return [Colors.brown.shade300, Colors.brown.shade600];
      case 'soup':
        return [Colors.red.shade300, Colors.red.shade600];
      case 'dessert':
      case 'sweet':
        return [Colors.pink.shade300, Colors.pink.shade600];
      case 'beverage':
      case 'drink':
      case 'juice':
        return [Colors.lightBlue.shade300, Colors.lightBlue.shade600];
      case 'salad':
        return [Colors.green.shade300, Colors.green.shade600];
      case 'seafood':
      case 'fish':
        return [Colors.teal.shade300, Colors.teal.shade600];
      default:
        return [Colors.orange.shade300, Colors.orange.shade600];
    }
  }

  Color _getFoodGlowColor([String? type]) {
    final typeName = (type ?? typeInfo.title).toLowerCase();
    switch (typeName) {
      case 'puttu':
      case 'hoppers':
      case 'rice':
        return Colors.amber;
      case 'curry':
        return Colors.orange;
      case 'kottu':
        return Colors.deepOrange;
      case 'noodles':
      case 'pasta':
        return Colors.yellow;
      case 'string hoppers':
      case 'bread':
        return Colors.brown;
      case 'soup':
        return Colors.red;
      case 'dessert':
      case 'sweet':
        return Colors.pink;
      case 'beverage':
      case 'drink':
      case 'juice':
        return Colors.lightBlue;
      case 'salad':
        return Colors.green;
      case 'seafood':
      case 'fish':
        return Colors.teal;
      default:
        return Colors.orange;
    }
  }

  IconData _getFoodIcon([String? type]) {
    final typeName = (type ?? typeInfo.title).toLowerCase();
    switch (typeName) {
      case 'puttu':
      case 'hoppers':
      case 'rice':
        return Icons.grain;
      case 'curry':
        return Icons.restaurant;
      case 'kottu':
        return Icons.local_dining;
      case 'noodles':
      case 'pasta':
        return Icons.ramen_dining;
      case 'string hoppers':
      case 'bread':
        return Icons.bakery_dining;
      case 'soup':
        return Icons.soup_kitchen;
      case 'dessert':
      case 'sweet':
        return Icons.cake;
      case 'beverage':
      case 'drink':
      case 'juice':
        return Icons.local_cafe;
      case 'salad':
        return Icons.eco;
      case 'seafood':
      case 'fish':
        return Icons.set_meal;
      default:
        return Icons.restaurant;
    }
  }
}
