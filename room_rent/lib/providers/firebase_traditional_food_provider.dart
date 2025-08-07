import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/traditional_food.dart';

class FirebaseTraditionalFoodProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TraditionalFood> _foods = [];
  bool _isLoading = false;
  String? _error;

  List<TraditionalFood> get foods => _foods;
  bool get isLoading => _isLoading;
  String? get error => _error;

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

  Future<void> loadTraditionalFoods() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('traditional_foods')
          .orderBy('createdAt', descending: true)
          .get();

      _foods = snapshot.docs
          .map(
            (doc) => TraditionalFood.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      _error = 'Failed to load traditional foods: $e';
      print('Error loading traditional foods: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTraditionalFood(TraditionalFood food) async {
    try {
      await _firestore
          .collection('traditional_foods')
          .doc(food.id)
          .set(food.toJson());
      _foods.add(food);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add traditional food: $e';
      print('Error adding traditional food: $e');
    }
  }

  Future<void> updateTraditionalFood(TraditionalFood food) async {
    try {
      await _firestore
          .collection('traditional_foods')
          .doc(food.id)
          .update(food.toJson());
      final index = _foods.indexWhere((f) => f.id == food.id);
      if (index != -1) {
        _foods[index] = food;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update traditional food: $e';
      print('Error updating traditional food: $e');
    }
  }

  Future<void> deleteTraditionalFood(String foodId) async {
    try {
      await _firestore.collection('traditional_foods').doc(foodId).delete();
      _foods.removeWhere((food) => food.id == foodId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete traditional food: $e';
      print('Error deleting traditional food: $e');
    }
  }

  Future<TraditionalFood?> getTraditionalFoodById(String foodId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('traditional_foods')
          .doc(foodId)
          .get();

      if (doc.exists) {
        return TraditionalFood.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      _error = 'Failed to get traditional food: $e';
      print('Error getting traditional food: $e');
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
