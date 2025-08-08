import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/vehicle.dart';
import 'firebase_vehicle_adapter.dart';

class FirebaseVehicleService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection names
  static const String vehiclesCollection = 'vehicles';

  // Storage paths
  static const String vehicleImagesPath = 'vehicle_images';

  // Vehicle operations using your existing Vehicle model
  static Future<String> addVehicle(Vehicle vehicle) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(vehiclesCollection)
          .add(FirebaseVehicleAdapter.vehicleToFirestore(vehicle));
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add vehicle: $e');
    }
  }

  static Stream<List<Vehicle>> getVehiclesStream() {
    return _firestore
        .collection(vehiclesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => FirebaseVehicleAdapter.vehicleFromFirestore(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  static Future<List<Vehicle>> getVehicles() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(vehiclesCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseVehicleAdapter.vehicleFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get vehicles: $e');
    }
  }

  static Future<Vehicle?> getVehicle(String vehicleId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(vehiclesCollection)
          .doc(vehicleId)
          .get();

      if (doc.exists) {
        return FirebaseVehicleAdapter.vehicleFromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get vehicle: $e');
    }
  }

  static Future<void> updateVehicle(String vehicleId, Vehicle vehicle) async {
    try {
      await _firestore
          .collection(vehiclesCollection)
          .doc(vehicleId)
          .update(FirebaseVehicleAdapter.vehicleToFirestore(vehicle));
    } catch (e) {
      throw Exception('Failed to update vehicle: $e');
    }
  }

  static Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _firestore.collection(vehiclesCollection).doc(vehicleId).delete();
    } catch (e) {
      throw Exception('Failed to delete vehicle: $e');
    }
  }

  // Storage operations
  static Future<String> uploadImage(
    Uint8List imageData,
    String fileName,
    String folder,
  ) async {
    try {
      final ref = _storage.ref().child('$folder/$fileName');
      final uploadTask = ref.putData(imageData);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  static Future<List<String>> uploadMultipleImages(
    List<Uint8List> imagesData,
    String folder,
  ) async {
    List<String> downloadUrls = [];

    for (int i = 0; i < imagesData.length; i++) {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      String url = await uploadImage(imagesData[i], fileName, folder);
      downloadUrls.add(url);
    }

    return downloadUrls;
  }

  static Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Add sample vehicles with local assets
  static Future<void> addSampleVehicles() async {
    // Clear existing vehicles first (optional)
    await _clearExistingVehicles();

    final now = DateTime.now();

    // Toyota Hiace Van
    final hiaceVan = Vehicle(
      id: '',
      title: 'Van',
      description:
          'Comfortable 12-seater van perfect for group transportation. Air conditioned with experienced driver.',
      price: 5000.0,
      priceType: 'per_day',
      location: 'Kinniya',
      address: 'Main Road, Kinniya, Trincomalee',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/van.jpg', 'assets/images/car.jpg'],
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
      availableTo: null,
      owner: VehicleOwner(
        id: 'driver1',
        name: 'Mohamed Ali',
        email: 'ali@transport.lk',
        phone: '+94771234567',
        profileImage: 'assets/images/manager.jpg',
        rating: 4.9,
        totalVehicles: 3,
      ),
      reviews: [
        Review(
          id: 'review_van1',
          userId: 'user1',
          userName: 'Sarah Johnson',
          userImage: 'assets/images/user.jpg',
          rating: 5.0,
          comment: 'Excellent van! Very comfortable for our group tour.',
          createdAt: now.subtract(const Duration(days: 5)),
        ),
      ],
      rating: 4.9,
      createdAt: now.subtract(const Duration(days: 90)),
      updatedAt: now,
    );

    // Honda CRV
    final hondaCrv = Vehicle(
      id: '',
      title: 'Car',
      description:
          'Luxury SUV for comfortable family trips. Perfect for exploring the beautiful areas around Trincomalee.',
      price: 3500.0,
      priceType: 'per_day',
      location: 'Kinniya',
      address: 'Beach Road, Kinniya, Trincomalee',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/car.jpg'],
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
    );

    // Yamaha FZ Bike
    final yamahaFz = Vehicle(
      id: '',
      title: 'Bike',
      description:
          'Fuel-efficient motorcycle for quick local transportation. Perfect for solo travelers and short trips.',
      price: 1500.0,
      priceType: 'per_day',
      location: 'Kinniya',
      address: 'Station Road, Kinniya, Trincomalee',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/motorcycle.jpg'],
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
    );

    // Tata 1613 Lorry
    final tataLorry = Vehicle(
      id: '',
      title: 'Lorry',
      description:
          'Heavy-duty truck for cargo and goods transportation. Perfect for moving furniture, construction materials, and large items.',
      price: 8000.0,
      priceType: 'per_day',
      location: 'Kinniya',
      address: 'Industrial Area, Kinniya, Trincomalee',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/lorry.jpg'],
      vehicleType: 'lorry',
      make: 'Tata',
      model: '1613',
      year: '2019',
      fuelType: 'diesel',
      seatingCapacity: 3,
      transmissionType: 'manual',
      features: [
        'Heavy Load Capacity',
        'Experienced Driver',
        'GPS Tracking',
        'Loading Assistance',
        'Insurance Coverage',
        'Tarpaulin Cover',
      ],
      isAvailable: true,
      availableFrom: now,
      owner: VehicleOwner(
        id: 'driver5',
        name: 'Sunil Fernando',
        email: 'sunil@transport.lk',
        phone: '+94771234571',
        profileImage: 'assets/images/manager.jpg',
        rating: 4.5,
        totalVehicles: 2,
      ),
      reviews: [],
      rating: 4.5,
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now,
    );

    // Add all vehicles
    await addVehicle(hiaceVan);
    await addVehicle(hondaCrv);
    await addVehicle(yamahaFz);
    await addVehicle(tataLorry);
  }

  static Future<void> _clearExistingVehicles() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(vehiclesCollection)
          .get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing vehicles: $e');
    }
  }

  // Get vehicles by type
  static Future<List<Vehicle>> getVehiclesByType(String vehicleType) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(vehiclesCollection)
          .where('vehicleType', isEqualTo: vehicleType)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseVehicleAdapter.vehicleFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get vehicles by type: $e');
    }
  }

  // Get available vehicles
  static Future<List<Vehicle>> getAvailableVehicles() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(vehiclesCollection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseVehicleAdapter.vehicleFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get available vehicles: $e');
    }
  }
}
