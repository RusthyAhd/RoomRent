import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/elemental_good.dart';

class FirebaseElementalGoodProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ElementalGood> _goods = [];
  bool _isLoading = false;
  String? _error;

  List<ElementalGood> get goods => _goods;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get goods by type
  List<ElementalGood> getGoodsByType(String goodType) {
    return _goods
        .where((good) => good.goodType == goodType && good.isAvailable)
        .toList();
  }

  Future<void> loadElementalGoods() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('elemental_goods')
          .orderBy('createdAt', descending: true)
          .get();

      _goods = snapshot.docs
          .map(
            (doc) => ElementalGood.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      _error = 'Failed to load elemental goods: $e';
      print('Error loading elemental goods: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addElementalGood(ElementalGood good) async {
    try {
      await _firestore
          .collection('elemental_goods')
          .doc(good.id)
          .set(good.toJson());
      _goods.add(good);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add elemental good: $e';
      print('Error adding elemental good: $e');
    }
  }

  Future<void> updateElementalGood(ElementalGood good) async {
    try {
      await _firestore
          .collection('elemental_goods')
          .doc(good.id)
          .update(good.toJson());
      final index = _goods.indexWhere((g) => g.id == good.id);
      if (index != -1) {
        _goods[index] = good;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update elemental good: $e';
      print('Error updating elemental good: $e');
    }
  }

  Future<void> deleteElementalGood(String goodId) async {
    try {
      await _firestore.collection('elemental_goods').doc(goodId).delete();
      _goods.removeWhere((good) => good.id == goodId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete elemental good: $e';
      print('Error deleting elemental good: $e');
    }
  }

  Future<ElementalGood?> getElementalGoodById(String goodId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('elemental_goods')
          .doc(goodId)
          .get();

      if (doc.exists) {
        return ElementalGood.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      _error = 'Failed to get elemental good: $e';
      print('Error getting elemental good: $e');
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
