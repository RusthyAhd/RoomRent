import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/firebase_vehicle_service.dart';

class FirebaseVehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Get vehicles by type
  List<Vehicle> getVehiclesByType(String vehicleType) {
    return _vehicles
        .where(
          (vehicle) =>
              vehicle.vehicleType == vehicleType && vehicle.isAvailable,
        )
        .toList();
  }

  // Load vehicles from Firebase (one-time load)
  Future<void> loadVehicles() async {
    _setLoading(true);
    try {
      _vehicles = await FirebaseVehicleService.getVehicles();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load vehicles: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Initialize real-time vehicles stream
  void initializeVehiclesStream() {
    _setLoading(true);
    FirebaseVehicleService.getVehiclesStream().listen(
      (vehiclesList) {
        _vehicles = vehiclesList;
        _errorMessage = '';
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = 'Failed to load vehicles: $error';
        _setLoading(false);
      },
    );
  }

  // Add a new vehicle
  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      _setLoading(true);
      await FirebaseVehicleService.addVehicle(vehicle);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to add vehicle: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing vehicle
  Future<void> updateVehicle(String vehicleId, Vehicle vehicle) async {
    try {
      _setLoading(true);
      await FirebaseVehicleService.updateVehicle(vehicleId, vehicle);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to update vehicle: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Delete a vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      _setLoading(true);
      await FirebaseVehicleService.deleteVehicle(vehicleId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to delete vehicle: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Get a specific vehicle
  Future<Vehicle?> getVehicleById(String vehicleId) async {
    try {
      return await FirebaseVehicleService.getVehicle(vehicleId);
    } catch (e) {
      _errorMessage = 'Failed to get vehicle: $e';
      return null;
    }
  }

  // Get available vehicles
  Future<List<Vehicle>> getAvailableVehicles() async {
    try {
      return await FirebaseVehicleService.getAvailableVehicles();
    } catch (e) {
      _errorMessage = 'Failed to get available vehicles: $e';
      return [];
    }
  }

  // Get vehicles by type from service
  Future<List<Vehicle>> getVehiclesByTypeFromService(String vehicleType) async {
    try {
      return await FirebaseVehicleService.getVehiclesByType(vehicleType);
    } catch (e) {
      _errorMessage = 'Failed to get vehicles by type: $e';
      return [];
    }
  }

  // Add sample vehicles
  Future<void> addSampleVehicles() async {
    try {
      _setLoading(true);
      await FirebaseVehicleService.addSampleVehicles();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to add sample vehicles: $e';
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
