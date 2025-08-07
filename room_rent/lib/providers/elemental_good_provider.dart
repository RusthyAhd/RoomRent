import 'package:flutter/material.dart';
import '../models/elemental_good.dart';

class ElementalGoodProvider extends ChangeNotifier {
  List<ElementalGood> _goods = [];
  bool _isLoading = false;
  String _error = '';

  List<ElementalGood> get goods => _goods;
  bool get isLoading => _isLoading;
  String get error => _error;

  List<ElementalGood> getGoodsByType(String type) {
    return _goods.where((good) => good.goodType == type).toList();
  }

  Future<void> loadGoods() async {
    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate loading

      final now = DateTime.now();

      _goods = [
        ElementalGood(
          id: '1',
          title: 'Electric Rice Cooker',
          description:
              'High-quality electric rice cooker perfect for cooking rice and steaming.',
          price: 150.0,
          priceType: 'per_day',
          location: 'Kinniya',
          address: 'Kitchen Rentals, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          goodType: 'rice_cooker',
          brand: 'Panasonic',
          model: 'SR-G06',
          condition: 'good',
          specifications: [
            'Capacity: 1.5L',
            'Power: 400W',
            'Non-stick coating',
            'Auto shut-off',
            'Keep warm function',
          ],
          powerSource: 'electric',
          requiresDeposit: true,
          depositAmount: 2000.0,
          isAvailable: true,
          availableFrom: now,
          owner: ElementalGoodOwner(
            id: 'owner1',
            name: 'Kitchen Rentals',
            email: 'info@kitchenrentals.lk',
            phone: '+94771234567',
            profileImage: 'assets/images/manager.jpg',
            rating: 4.8,
            totalItems: 25,
          ),
          reviews: [],
          rating: 4.8,
          createdAt: now.subtract(const Duration(days: 90)),
          updatedAt: now,
        ),
        ElementalGood(
          id: '2',
          title: 'Gas Cooker with Cylinder',
          description:
              'Complete gas cooking setup with cylinder for outdoor or indoor cooking.',
          price: 300.0,
          priceType: 'per_day',
          location: 'Kinniya',
          address: 'Gas Rentals, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          goodType: 'gas_cooker_with_cylinder',
          brand: 'Singer',
          model: 'GC-2000',
          condition: 'good',
          specifications: [
            'Cylinder: 12.5kg',
            'Burners: 2',
            'Auto ignition',
            'Safety valve',
            'Portable design',
          ],
          powerSource: 'gas',
          requiresDeposit: true,
          depositAmount: 5000.0,
          isAvailable: true,
          availableFrom: now,
          owner: ElementalGoodOwner(
            id: 'owner2',
            name: 'Gas Equipment Rentals',
            email: 'info@gasequipment.lk',
            phone: '+94771234568',
            profileImage: 'assets/images/user.jpg',
            rating: 4.7,
            totalItems: 15,
          ),
          reviews: [],
          rating: 4.7,
          createdAt: now.subtract(const Duration(days: 60)),
          updatedAt: now,
        ),
        ElementalGood(
          id: '3',
          title: 'Electric BBQ Rack',
          description:
              'Electric BBQ rack for indoor grilling and outdoor events.',
          price: 200.0,
          priceType: 'per_day',
          location: 'Kinniya',
          address: 'Party Rentals, Kinniya, Trincomalee',
          latitude: 8.4877,
          longitude: 81.1837,
          images: ['assets/images/user.jpg'],
          goodType: 'bbq_rack',
          brand: 'Philips',
          model: 'HD6371',
          condition: 'like_new',
          specifications: [
            'Power: 2000W',
            'Non-stick surface',
            'Adjustable temperature',
            'Easy cleaning',
            'Safety features',
          ],
          powerSource: 'electric',
          requiresDeposit: true,
          depositAmount: 3000.0,
          isAvailable: true,
          availableFrom: now,
          owner: ElementalGoodOwner(
            id: 'owner3',
            name: 'Party Equipment Rentals',
            email: 'info@partyrentals.lk',
            phone: '+94771234569',
            profileImage: 'assets/images/manager.jpg',
            rating: 4.6,
            totalItems: 30,
          ),
          reviews: [],
          rating: 4.6,
          createdAt: now.subtract(const Duration(days: 30)),
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

  Future<void> refreshGoods() async {
    await loadGoods();
  }
}
