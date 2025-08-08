import 'package:flutter/material.dart';
import '../models/elemental_good.dart';
import '../services/firebase_goods_service.dart';

class FirebaseElementalGoodProvider with ChangeNotifier {
  List<ElementalGood> _goods = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<ElementalGood> get goods => _goods;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Get goods by type
  List<ElementalGood> getGoodsByType(String goodType) {
    return _goods
        .where((good) => good.goodType == goodType && good.isAvailable)
        .toList();
  }

  // Load goods from Firebase (one-time load)
  Future<void> loadElementalGoods() async {
    _setLoading(true);
    try {
      _goods = await FirebaseGoodsService.getGoods();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load goods: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Initialize real-time goods stream
  void initializeGoodsStream() {
    _setLoading(true);
    FirebaseGoodsService.getGoodsStream().listen(
      (goodsList) {
        _goods = goodsList;
        _errorMessage = '';
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = 'Failed to load goods: $error';
        _setLoading(false);
      },
    );
  }

  // Add a new good
  Future<void> addElementalGood(ElementalGood good) async {
    try {
      _setLoading(true);
      await FirebaseGoodsService.addGood(good);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to add good: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing good
  Future<void> updateElementalGood(String goodId, ElementalGood good) async {
    try {
      _setLoading(true);
      await FirebaseGoodsService.updateGood(goodId, good);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to update good: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Delete a good
  Future<void> deleteElementalGood(String goodId) async {
    try {
      _setLoading(true);
      await FirebaseGoodsService.deleteGood(goodId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to delete good: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Get a specific good
  Future<ElementalGood?> getElementalGoodById(String goodId) async {
    try {
      return await FirebaseGoodsService.getGood(goodId);
    } catch (e) {
      _errorMessage = 'Failed to get good: $e';
      return null;
    }
  }

  // Get available goods
  Future<List<ElementalGood>> getAvailableGoods() async {
    try {
      return await FirebaseGoodsService.getAvailableGoods();
    } catch (e) {
      _errorMessage = 'Failed to get available goods: $e';
      return [];
    }
  }

  // Get goods by type from service
  Future<List<ElementalGood>> getGoodsByTypeFromService(String goodType) async {
    try {
      return await FirebaseGoodsService.getGoodsByType(goodType);
    } catch (e) {
      _errorMessage = 'Failed to get goods by type: $e';
      return [];
    }
  }

  // Add sample goods
  Future<void> addSampleGoods() async {
    try {
      _setLoading(true);
      await FirebaseGoodsService.addSampleGoods();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to add sample goods: $e';
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
