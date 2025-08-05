import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/room.dart';
import '../models/guest_house_manager.dart';

class DataService {
  static const String _guestHouseAssetPath =
      'assets/sample_data/guest_house_data.json';

  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Room>? _cachedRooms;
  GuestHouseManager? _cachedManager;

  // Load guest house data including manager and rooms
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

  // Load guest house manager
  Future<GuestHouseManager> loadManager() async {
    if (_cachedManager != null) return _cachedManager!;

    try {
      final data = await loadGuestHouseData();
      _cachedManager = GuestHouseManager.fromJson(data['guestHouseManager']);
      return _cachedManager!;
    } catch (e) {
      print('Error loading manager: $e');
      return _generateSampleManager();
    }
  }

  // Load sample rooms data
  Future<List<Room>> loadRooms() async {
    if (_cachedRooms != null) return _cachedRooms!;

    try {
      final data = await loadGuestHouseData();
      final List<dynamic> roomsJson = data['rooms'];
      _cachedRooms = roomsJson.map((json) => Room.fromJson(json)).toList();
      return _cachedRooms!;
    } catch (e) {
      print('Error loading rooms: $e');
      return _generateSampleRooms();
    }
  }

  // Generate sample guest house data if file loading fails
  Map<String, dynamic> _generateSampleGuestHouseData() {
    return {
      "guestHouseManager": _generateSampleManager().toJson(),
      "rooms": _generateSampleRooms().map((room) => room.toJson()).toList(),
    };
  }

  // Generate sample manager if file loading fails
  GuestHouseManager _generateSampleManager() {
    return GuestHouseManager(
      id: 'manager_001',
      name: 'Abdul Rahman',
      position: 'Guest House Manager & In-Charge',
      email: 'abdul.rahman@villageguest.house',
      phone: '+91 98765 43210',
      whatsapp: '+91 98765 43210',
      bio:
          'Experienced guest house manager with over 15 years of hospitality experience.',
      guestHouseName: 'Village Heritage Guest House',
      village: 'Harmony Village',
      district: 'Green Valley',
      state: 'Kerala',
      yearsOfExperience: 15,
      languages: ['English', 'Hindi', 'Malayalam', 'Tamil'],
      specialties: [
        'Local Tours',
        'Traditional Cuisine',
        'Cultural Activities',
      ],
      isAvailable: true,
      rating: 4.8,
      totalGuests: 1250,
      certificates: ['Hospitality Management Certificate'],
      reviews: [],
      joinedDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
    );
  }

  // Generate sample rooms if file loading fails
  List<Room> _generateSampleRooms() {
    final now = DateTime.now();

    return [
      Room(
        id: 'room_001',
        title: 'Deluxe Village View Room',
        description:
            'Spacious room with traditional décor and stunning village views. Features comfortable bedding, attached bathroom, and a private balcony.',
        price: 2500.0,
        priceType: 'per_night',
        location: 'Harmony Village, Green Valley',
        address: 'Village Heritage Guest House, Main Road, Harmony Village',
        latitude: 9.9312,
        longitude: 76.2673,
        images: ['assets/images/room1_1.jpg', 'assets/images/room1_2.jpg'],
        bedrooms: 1,
        bathrooms: 1,
        area: 25.0,
        amenities: [
          'Air Conditioning',
          'Private Bathroom',
          'Hot Water',
          'Village View',
          'Balcony',
          'WiFi',
        ],
        isAvailable: true,
        availableFrom: now,
        inCharge: RoomInCharge(
          id: 'manager_001',
          name: 'Abdul Rahman',
          email: 'abdul.rahman@villageguest.house',
          phone: '+91 98765 43210',
          role: 'manager',
          rating: 4.8,
          totalReviews: 42,
          isVerified: true,
          bio: 'Experienced guest house manager',
          languages: ['English', 'Hindi', 'Malayalam', 'Tamil'],
        ),
        reviews: [
          Review(
            id: 'review_001',
            userId: 'user_001',
            userName: 'Priya Sharma',
            rating: 5.0,
            comment:
                'Beautiful room with amazing village views. Very clean and comfortable.',
            createdAt: now.subtract(const Duration(days: 5)),
          ),
        ],
        rating: 4.6,
        propertyType: 'room',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      Room(
        id: 'room_002',
        title: 'Family Heritage Suite',
        description:
            'Spacious family suite perfect for 4-6 guests. Features traditional Kerala architecture with modern amenities.',
        price: 4000.0,
        priceType: 'per_night',
        location: 'Harmony Village, Green Valley',
        address: 'Village Heritage Guest House, Main Road, Harmony Village',
        latitude: 9.9312,
        longitude: 76.2673,
        images: ['assets/images/room2_1.jpg', 'assets/images/room2_2.jpg'],
        bedrooms: 2,
        bathrooms: 1,
        area: 45.0,
        amenities: [
          'Air Conditioning',
          'Living Area',
          'Traditional Architecture',
          'Family Suitable',
          'WiFi',
        ],
        isAvailable: true,
        availableFrom: now.add(const Duration(days: 1)),
        inCharge: RoomInCharge(
          id: 'manager_001',
          name: 'Abdul Rahman',
          email: 'abdul.rahman@villageguest.house',
          phone: '+91 98765 43210',
          role: 'manager',
          rating: 4.8,
          totalReviews: 42,
          isVerified: true,
          bio: 'Experienced guest house manager',
          languages: ['English', 'Hindi', 'Malayalam', 'Tamil'],
        ),
        reviews: [
          Review(
            id: 'review_002',
            userId: 'user_002',
            userName: 'Vikram Patel',
            rating: 5.0,
            comment:
                'Perfect for our family of 5. The suite was spacious and well-maintained.',
            createdAt: now.subtract(const Duration(days: 10)),
          ),
        ],
        rating: 4.7,
        propertyType: 'suite',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
    ];
  }
}
