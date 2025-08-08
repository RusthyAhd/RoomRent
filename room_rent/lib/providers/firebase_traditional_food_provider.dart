import 'package:flutter/material.dart';
import '../models/traditional_food.dart';
import '../services/firebase_food_service.dart';

class FirebaseTraditionalFoodProvider with ChangeNotifier {
  List<TraditionalFood> _foods = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<TraditionalFood> get foods => _foods;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Get foods by type
  List<TraditionalFood> getFoodsByType(String foodType) {
    return _foods
        .where((food) => food.foodType == foodType && food.isAvailable)
        .toList();
  }

  // Get rice and curry varieties
  List<TraditionalFood> getRiceAndCurryVarieties() {
    return _foods
        .where((food) => food.foodType == 'rice_and_curry' && food.isAvailable)
        .toList();
  }

  // Load foods from Firebase (one-time load)
  Future<void> loadTraditionalFoods() async {
    _setLoading(true);
    try {
      _foods = await FirebaseFoodService.getFoods();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load foods: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Initialize real-time foods stream
  void initializeFoodsStream() {
    _setLoading(true);
    FirebaseFoodService.getFoodsStream().listen(
      (foodsList) {
        _foods = foodsList;
        _errorMessage = '';
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = 'Failed to load foods: $error';
        _setLoading(false);
      },
    );
  }

  // Add a new food
  Future<void> addTraditionalFood(TraditionalFood food) async {
    try {
      _setLoading(true);
      await FirebaseFoodService.addFood(food);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to add food: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing food
  Future<void> updateTraditionalFood(
    String foodId,
    TraditionalFood food,
  ) async {
    try {
      _setLoading(true);
      await FirebaseFoodService.updateFood(foodId, food);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to update food: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Delete a food
  Future<void> deleteTraditionalFood(String foodId) async {
    try {
      _setLoading(true);
      await FirebaseFoodService.deleteFood(foodId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to delete food: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Get a specific food
  Future<TraditionalFood?> getTraditionalFoodById(String foodId) async {
    try {
      return await FirebaseFoodService.getFood(foodId);
    } catch (e) {
      _errorMessage = 'Failed to get food: $e';
      return null;
    }
  }

  // Get available foods
  Future<List<TraditionalFood>> getAvailableFoods() async {
    try {
      return await FirebaseFoodService.getAvailableFoods();
    } catch (e) {
      _errorMessage = 'Failed to get available foods: $e';
      return [];
    }
  }

  // Get foods by type from service
  Future<List<TraditionalFood>> getFoodsByTypeFromService(
    String foodType,
  ) async {
    try {
      return await FirebaseFoodService.getFoodsByType(foodType);
    } catch (e) {
      _errorMessage = 'Failed to get foods by type: $e';
      return [];
    }
  }

  // Get rice and curry varieties from service
  Future<List<TraditionalFood>> getRiceAndCurryVarietiesFromService() async {
    try {
      return await FirebaseFoodService.getRiceAndCurryVarieties();
    } catch (e) {
      _errorMessage = 'Failed to get rice and curry varieties: $e';
      return [];
    }
  }

  // Add sample foods
  Future<void> addSampleFoods() async {
    try {
      _setLoading(true);
      await FirebaseFoodService.addSampleFoods();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to add sample foods: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Private helper method
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
