import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/firebase_room_service.dart';

class FirebaseRoomProvider with ChangeNotifier {
  List<Room> _rooms = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Load rooms from Firebase (one-time load)
  Future<void> loadRooms() async {
    _setLoading(true);
    try {
      _rooms = await FirebaseRoomService.getRooms();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load rooms: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Initialize real-time rooms stream
  void initializeRoomsStream() {
    _setLoading(true);
    FirebaseRoomService.getRoomsStream().listen(
      (roomsList) {
        _rooms = roomsList;
        _errorMessage = '';
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = 'Failed to load rooms: $error';
        _setLoading(false);
      },
    );
  }

  // Add a new room
  Future<void> addRoom(Room room) async {
    try {
      _setLoading(true);
      await FirebaseRoomService.addRoom(room);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to add room: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Update a room
  Future<void> updateRoom(String roomId, Room room) async {
    try {
      _setLoading(true);
      await FirebaseRoomService.updateRoom(roomId, room);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to update room: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Delete a room
  Future<void> deleteRoom(String roomId) async {
    try {
      _setLoading(true);
      await FirebaseRoomService.deleteRoom(roomId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to delete room: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Add sample room for testing
  Future<void> addSampleRoom() async {
    try {
      _setLoading(true);
      await FirebaseRoomService.addSampleRoom();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to add sample room: $e';
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
