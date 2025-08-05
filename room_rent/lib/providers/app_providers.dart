import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/data_service.dart';

class RoomProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  List<Room> _rooms = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Load all rooms
  Future<void> loadRooms() async {
    _setLoading(true);
    try {
      _rooms = await _dataService.loadRooms();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load rooms: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
