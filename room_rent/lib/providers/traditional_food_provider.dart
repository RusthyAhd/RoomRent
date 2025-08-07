import 'package:flutter/material.dart';
import '../models/traditional_food.dart';

class TraditionalFoodProvider extends ChangeNotifier {
  List<TraditionalFood> _foods = [];
  bool _isLoading = false;
  String _error = '';

  List<TraditionalFood> get foods => _foods;
  bool get isLoading => _isLoading;
  String get error => _error;

  List<TraditionalFood> getFoodsByType(String type) {
    return _foods.where((food) => food.foodType == type).toList();
  }

  Future<void> loadFoods() async {
    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate loading

      final now = DateTime.now();

      _foods = [
        TraditionalFood(
          id: '1',
          title: 'Traditional Fish Curry',
          description:
              'Authentic Sri Lankan fish curry prepared with fresh catch and traditional spices.',
          price: 1500.0,
          priceType: 'per_plate',
          location: 'Kinniya',
          address: 'Beach Road, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          foodType: 'rice_and_curry',
          variety: 'fish',
          ingredients: [
            'Fresh Fish',
            'Coconut Milk',
            'Curry Leaves',
            'Turmeric',
            'Red Chilies',
            'Onions',
            'Garlic',
            'Ginger',
          ],
          spiceLevel: 'medium',
          preparationTime: '45 minutes',
          dietaryInfo: ['non-vegetarian', 'gluten-free'],
          isAvailable: true,
          availableFrom: now,
          availableTimes: ['lunch', 'dinner'],
          provider: FoodProvider(
            id: 'provider1',
            name: 'Kamala Devi',
            email: 'kamala@traditionalfoods.lk',
            phone: '+94771234567',
            profileImage: 'assets/images/manager.jpg',
            rating: 4.9,
            totalDishes: 15,
            specialties: ['Fish Curry', 'Traditional Sri Lankan'],
          ),
          reviews: [],
          rating: 4.9,
          createdAt: now.subtract(const Duration(days: 90)),
          updatedAt: now,
        ),
        TraditionalFood(
          id: '2',
          title: 'String Hoppers',
          description:
              'Fresh string hoppers served with coconut sambol and curry.',
          price: 800.0,
          priceType: 'per_portion',
          location: 'Kinniya',
          address: 'Village Road, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          foodType: 'string_hoppers',
          ingredients: [
            'Rice Flour',
            'Coconut',
            'Red Chilies',
            'Onions',
            'Lime',
          ],
          spiceLevel: 'mild',
          preparationTime: '30 minutes',
          dietaryInfo: ['vegetarian', 'gluten-free'],
          isAvailable: true,
          availableFrom: now,
          availableTimes: ['breakfast', 'dinner'],
          provider: FoodProvider(
            id: 'provider2',
            name: 'Priya Fernando',
            email: 'priya@traditionalfoods.lk',
            phone: '+94771234568',
            profileImage: 'assets/images/user.jpg',
            rating: 4.7,
            totalDishes: 8,
            specialties: ['String Hoppers', 'Breakfast Items'],
          ),
          reviews: [],
          rating: 4.7,
          createdAt: now.subtract(const Duration(days: 60)),
          updatedAt: now,
        ),
        TraditionalFood(
          id: '3',
          title: 'Puttu with Coconut',
          description:
              'Traditional puttu served with fresh coconut and jaggery.',
          price: 500.0,
          priceType: 'per_portion',
          location: 'Kinniya',
          address: 'Temple Street, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          foodType: 'puttu',
          ingredients: ['Rice Flour', 'Fresh Coconut', 'Jaggery', 'Salt'],
          spiceLevel: 'mild',
          preparationTime: '25 minutes',
          dietaryInfo: ['vegetarian', 'vegan', 'gluten-free'],
          isAvailable: true,
          availableFrom: now,
          availableTimes: ['breakfast'],
          provider: FoodProvider(
            id: 'provider3',
            name: 'Saman Kumara',
            email: 'saman@traditionalfoods.lk',
            phone: '+94771234569',
            profileImage: 'assets/images/manager.jpg',
            rating: 4.8,
            totalDishes: 10,
            specialties: ['Puttu', 'Traditional Breakfast'],
          ),
          reviews: [],
          rating: 4.8,
          createdAt: now.subtract(const Duration(days: 30)),
          updatedAt: now,
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshFoods() async {
    await loadFoods();
  }
}
