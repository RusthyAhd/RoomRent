import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';

class FirebaseVehicleProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get vehicles by type
  List<Vehicle> getVehiclesByType(String vehicleType) {
    return _vehicles
        .where(
          (vehicle) =>
              vehicle.vehicleType == vehicleType && vehicle.isAvailable,
        )
        .toList();
  }

  Future<void> loadVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('vehicles')
          .orderBy('createdAt', descending: true)
          .get();

      _vehicles = snapshot.docs
          .map(
            (doc) => Vehicle.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }),
          )
          .toList();
    } catch (e) {
      _error = 'Failed to load vehicles: $e';
      print('Error loading vehicles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await _firestore
          .collection('vehicles')
          .doc(vehicle.id)
          .set(vehicle.toJson());
      _vehicles.add(vehicle);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add vehicle: $e';
      print('Error adding vehicle: $e');
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _firestore
          .collection('vehicles')
          .doc(vehicle.id)
          .update(vehicle.toJson());
      final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
      if (index != -1) {
        _vehicles[index] = vehicle;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update vehicle: $e';
      print('Error updating vehicle: $e');
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _firestore.collection('vehicles').doc(vehicleId).delete();
      _vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete vehicle: $e';
      print('Error deleting vehicle: $e');
    }
  }

  Future<Vehicle?> getVehicleById(String vehicleId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('vehicles')
          .doc(vehicleId)
          .get();

      if (doc.exists) {
        return Vehicle.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }
      return null;
    } catch (e) {
      _error = 'Failed to get vehicle: $e';
      print('Error getting vehicle: $e');
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
