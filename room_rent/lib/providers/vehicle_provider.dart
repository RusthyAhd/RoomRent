import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Sample vehicle data
  Future<void> loadVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 1));

      final now = DateTime.now();

      _vehicles = [
        Vehicle(
          id: '1',
          title: 'Toyota Hiace Van',
          description:
              'Comfortable 12-seater van perfect for group transportation. Air conditioned with experienced driver.',
          price: 5000.0,
          priceType: 'per_day',
          location: 'Kinniya',
          address: 'Main Road, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          vehicleType: 'van',
          make: 'Toyota',
          model: 'Hiace',
          year: '2020',
          fuelType: 'diesel',
          seatingCapacity: 12,
          transmissionType: 'manual',
          features: [
            'Air Conditioning',
            'GPS Navigation',
            'Music System',
            'USB Charging',
            'Comfortable Seats',
            'Experienced Driver',
          ],
          isAvailable: true,
          availableFrom: now,
          owner: VehicleOwner(
            id: 'driver1',
            name: 'Mohamed Ali',
            email: 'ali@transport.lk',
            phone: '+94771234567',
            profileImage: 'assets/images/manager.jpg',
            rating: 4.9,
            totalVehicles: 3,
          ),
          reviews: [],
          rating: 4.9,
          createdAt: now.subtract(const Duration(days: 90)),
          updatedAt: now,
        ),
        Vehicle(
          id: '2',
          title: 'Honda CRV',
          description:
              'Luxury SUV for comfortable family trips. Perfect for exploring the beautiful areas around Trincomalee.',
          price: 3500.0,
          priceType: 'per_day',
          location: 'Kinniya',
          address: 'Beach Road, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          vehicleType: 'car',
          make: 'Honda',
          model: 'CRV',
          year: '2021',
          fuelType: 'petrol',
          seatingCapacity: 5,
          transmissionType: 'automatic',
          features: [
            'Air Conditioning',
            'GPS Navigation',
            'Bluetooth',
            'Leather Seats',
            'Automatic',
            'Sunroof',
          ],
          isAvailable: true,
          availableFrom: now,
          owner: VehicleOwner(
            id: 'driver2',
            name: 'Kamal Perera',
            email: 'kamal@transport.lk',
            phone: '+94771234568',
            profileImage: 'assets/images/manager.jpg',
            rating: 4.8,
            totalVehicles: 1,
          ),
          reviews: [],
          rating: 4.8,
          createdAt: now.subtract(const Duration(days: 60)),
          updatedAt: now,
        ),
        Vehicle(
          id: '3',
          title: 'Yamaha FZ Bike',
          description:
              'Fuel-efficient motorcycle for quick local transportation. Perfect for solo travelers and short trips.',
          price: 1500.0,
          priceType: 'per_day',
          location: 'Kinniya',
          address: 'Station Road, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          vehicleType: 'bike',
          make: 'Yamaha',
          model: 'FZ',
          year: '2022',
          fuelType: 'petrol',
          seatingCapacity: 2,
          transmissionType: 'manual',
          features: [
            'Fuel Efficient',
            'Easy Handling',
            'Storage Box',
            'Digital Display',
            'LED Lights',
          ],
          isAvailable: true,
          availableFrom: now,
          owner: VehicleOwner(
            id: 'driver3',
            name: 'Ravi Kumar',
            email: 'ravi@transport.lk',
            phone: '+94771234569',
            profileImage: 'assets/images/manager.jpg',
            rating: 4.7,
            totalVehicles: 2,
          ),
          reviews: [],
          rating: 4.7,
          createdAt: now.subtract(const Duration(days: 30)),
          updatedAt: now,
        ),
        Vehicle(
          id: '4',
          title: 'TVS Jupiter Scooter',
          description:
              'Easy-to-ride scooter ideal for city exploration. Automatic transmission makes it perfect for beginners.',
          price: 1200.0,
          priceType: 'per_day',
          location: 'Kinniya',
          address: 'Market Street, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          vehicleType: 'scooter',
          make: 'TVS',
          model: 'Jupiter',
          year: '2023',
          fuelType: 'petrol',
          seatingCapacity: 2,
          transmissionType: 'automatic',
          features: [
            'Automatic',
            'Fuel Efficient',
            'Under Seat Storage',
            'Mobile Charger',
            'Comfortable Seat',
          ],
          isAvailable: true,
          availableFrom: now,
          owner: VehicleOwner(
            id: 'driver4',
            name: 'Priya Singh',
            email: 'priya@transport.lk',
            phone: '+94771234570',
            profileImage: 'assets/images/manager.jpg',
            rating: 4.6,
            totalVehicles: 1,
          ),
          reviews: [],
          rating: 4.6,
          createdAt: now.subtract(const Duration(days: 15)),
          updatedAt: now,
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshVehicles() async {
    await loadVehicles();
  }
}
