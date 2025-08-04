import 'package:flutter/material.dart';
import '../models/room.dart';
import '../models/user.dart';
import '../models/booking.dart';
import '../services/data_service.dart';

class RoomProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  List<Room> _rooms = [];
  List<Room> _filteredRooms = [];
  List<Room> _favoriteRooms = [];
  Room? _selectedRoom;
  bool _isLoading = false;
  String _errorMessage = '';

  // Search and filter parameters
  String _searchQuery = '';
  String? _selectedLocation;
  double? _minPrice;
  double? _maxPrice;
  int? _selectedBedrooms;
  List<String> _selectedAmenities = [];
  String? _selectedPropertyType;

  // Getters
  List<Room> get rooms => _rooms;
  List<Room> get filteredRooms => _filteredRooms;
  List<Room> get favoriteRooms => _favoriteRooms;
  Room? get selectedRoom => _selectedRoom;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;
  String? get selectedLocation => _selectedLocation;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  int? get selectedBedrooms => _selectedBedrooms;
  List<String> get selectedAmenities => _selectedAmenities;
  String? get selectedPropertyType => _selectedPropertyType;

  // Load all rooms
  Future<void> loadRooms() async {
    _setLoading(true);
    try {
      _rooms = await _dataService.loadRooms();
      _filteredRooms = List.from(_rooms);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load rooms: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Search rooms
  Future<void> searchRooms({
    String? searchQuery,
    String? location,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    List<String>? amenities,
    String? propertyType,
  }) async {
    _setLoading(true);
    try {
      // Update filter parameters
      _searchQuery = searchQuery ?? '';
      _selectedLocation = location;
      _minPrice = minPrice;
      _maxPrice = maxPrice;
      _selectedBedrooms = bedrooms;
      _selectedAmenities = amenities ?? [];
      _selectedPropertyType = propertyType;

      _filteredRooms = await _dataService.searchRooms(
        searchQuery: searchQuery,
        location: location,
        minPrice: minPrice,
        maxPrice: maxPrice,
        bedrooms: bedrooms,
        amenities: amenities,
        propertyType: propertyType,
      );
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Search failed: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedLocation = null;
    _minPrice = null;
    _maxPrice = null;
    _selectedBedrooms = null;
    _selectedAmenities = [];
    _selectedPropertyType = null;
    _filteredRooms = List.from(_rooms);
    notifyListeners();
  }

  // Select a room
  Future<void> selectRoom(String roomId) async {
    _setLoading(true);
    try {
      _selectedRoom = await _dataService.getRoomById(roomId);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to load room details: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Get room by ID
  Room? getRoomById(String roomId) {
    try {
      return _rooms.firstWhere((room) => room.id == roomId);
    } catch (e) {
      return null;
    }
  }

  // Toggle favorite
  void toggleFavorite(Room room) {
    final index = _favoriteRooms.indexWhere((r) => r.id == room.id);
    if (index >= 0) {
      _favoriteRooms.removeAt(index);
    } else {
      _favoriteRooms.add(room);
    }
    notifyListeners();
  }

  bool isFavorite(Room room) {
    return _favoriteRooms.any((r) => r.id == room.id);
  }

  // Get available options for filters
  Future<List<String>> getAvailableAmenities() async {
    return await _dataService.getAvailableAmenities();
  }

  Future<List<String>> getAvailablePropertyTypes() async {
    return await _dataService.getAvailablePropertyTypes();
  }

  Future<List<String>> getAvailableLocations() async {
    return await _dataService.getAvailableLocations();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

class BookingProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  List<Booking> _bookings = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Create a new booking
  Future<bool> createBooking(Booking booking) async {
    _setLoading(true);
    try {
      final success = await _dataService.createBooking(booking);
      if (success) {
        _bookings.add(booking);
        _errorMessage = '';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to create booking: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Calculate total price for booking
  double calculateTotalPrice(Room room, DateTime checkIn, DateTime checkOut) {
    final days = checkOut.difference(checkIn).inDays;

    switch (room.priceType) {
      case 'per_night':
        return room.price * days;
      case 'per_week':
        final weeks = (days / 7).ceil();
        return room.price * weeks;
      case 'per_month':
        final months = (days / 30).ceil();
        return room.price * months;
      default:
        return room.price * days;
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

class UserProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Load current user (mock implementation)
  void loadCurrentUser() {
    _currentUser = _dataService.getCurrentUser();
    _isLoggedIn = true;
    notifyListeners();
  }

  // Mock login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation
      if (email.isNotEmpty && password.isNotEmpty) {
        _currentUser = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          name: email.split('@').first,
          role: 'customer',
          isVerified: true,
          favoriteRooms: [],
          bookingHistory: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _isLoggedIn = true;
        _errorMessage = '';
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Mock register
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        _currentUser = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          name: name,
          role: 'customer',
          isVerified: false,
          favoriteRooms: [],
          bookingHistory: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _isLoggedIn = true;
        _errorMessage = '';
        return true;
      } else {
        _errorMessage = 'All fields are required';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _errorMessage = '';
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
