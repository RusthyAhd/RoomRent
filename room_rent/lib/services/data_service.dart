import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/room.dart';

class DataService {
  static const String _guestHouseAssetPath =
      'assets/sample_data/guest_house_data.json';

  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Room>? _cachedRooms;

  // Load sample rooms data
  Future<List<Room>> loadRooms() async {
    if (_cachedRooms != null) return _cachedRooms!;

    try {
      final data = await loadGuestHouseData();
      final List<dynamic> roomsData = data['rooms'] ?? [];
      _cachedRooms = roomsData
          .map((roomJson) => Room.fromJson(roomJson))
          .toList();
      return _cachedRooms!;
    } catch (e) {
      print('Error loading rooms: $e');
      return _generateSampleRooms();
    }
  }

  // Load guest house data from JSON
  Future<Map<String, dynamic>> loadGuestHouseData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        _guestHouseAssetPath,
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return jsonData;
    } catch (e) {
      print('Error loading guest house data: $e');
      return _generateSampleGuestHouseData();
    }
  }

  // Generate sample guest house data if file loading fails
  Map<String, dynamic> _generateSampleGuestHouseData() {
    return {
      "rooms": _generateSampleRooms().map((room) => room.toJson()).toList(),
    };
  }

  // Generate sample rooms if file loading fails
  List<Room> _generateSampleRooms() {
    final now = DateTime.now();
    return [
      Room(
        id: '1',
        title: 'Deluxe Ocean View Suite',
        description:
            'Spacious suite with panoramic ocean views, modern amenities, and a private balcony.',
        price: 120.0,
        priceType: 'per_night',
        location: 'Kinniya Beach',
        address: '123 Ocean Drive, Kinniya, Trincomalee',
        latitude: 8.5874,
        longitude: 81.1810,
        images: ['assets/images/room.png'],
        bedrooms: 1,
        bathrooms: 1,
        area: 45.0,
        amenities: [
          'Ocean View',
          'Air Conditioning',
          'Free WiFi',
          'Mini Bar',
          'Balcony',
          'Room Service',
        ],
        isAvailable: true,
        availableFrom: now,
        inCharge: RoomInCharge(
          id: 'mgr1',
          name: 'John Smith',
          phone: '+94771234567',
          email: 'john@kinniiyaguesthouse.com',
          role: 'manager',
          rating: 4.8,
          totalReviews: 156,
          isVerified: true,
          languages: ['English', 'Sinhala'],
        ),
        reviews: [],
        rating: 4.8,
        propertyType: 'room',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      Room(
        id: '2',
        title: 'Standard Garden Room',
        description:
            'Comfortable room overlooking beautiful gardens with essential amenities.',
        price: 80.0,
        priceType: 'per_night',
        location: 'Kinniya Beach',
        address: '124 Garden View, Kinniya, Trincomalee',
        latitude: 8.5875,
        longitude: 81.1811,
        images: ['assets/images/room.png'],
        bedrooms: 1,
        bathrooms: 1,
        area: 30.0,
        amenities: [
          'Garden View',
          'Air Conditioning',
          'Free WiFi',
          'Desk',
          'Tea/Coffee Making',
        ],
        isAvailable: true,
        availableFrom: now,
        inCharge: RoomInCharge(
          id: 'mgr2',
          name: 'Maria Rodriguez',
          phone: '+94771234568',
          email: 'maria@kinniiyaguesthouse.com',
          role: 'manager',
          rating: 4.9,
          totalReviews: 132,
          isVerified: true,
          languages: ['English', 'Spanish'],
        ),
        reviews: [],
        rating: 4.6,
        propertyType: 'room',
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now,
      ),
    ];
  }
}
