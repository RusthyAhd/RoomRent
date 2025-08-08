import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/traditional_food.dart';
import 'firebase_food_adapter.dart';

class FirebaseFoodService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection names
  static const String foodsCollection = 'traditional_foods';

  // Storage paths
  static const String foodImagesPath = 'food_images';

  // Food operations using your existing TraditionalFood model
  static Future<String> addFood(TraditionalFood food) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(foodsCollection)
          .add(FirebaseFoodAdapter.foodToFirestore(food));
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add food: $e');
    }
  }

  static Stream<List<TraditionalFood>> getFoodsStream() {
    return _firestore
        .collection(foodsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    FirebaseFoodAdapter.foodFromFirestore(doc.data(), doc.id),
              )
              .toList(),
        );
  }

  static Future<List<TraditionalFood>> getFoods() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(foodsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseFoodAdapter.foodFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get foods: $e');
    }
  }

  static Future<TraditionalFood?> getFood(String foodId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(foodsCollection)
          .doc(foodId)
          .get();

      if (doc.exists) {
        return FirebaseFoodAdapter.foodFromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get food: $e');
    }
  }

  static Future<void> updateFood(String foodId, TraditionalFood food) async {
    try {
      await _firestore
          .collection(foodsCollection)
          .doc(foodId)
          .update(FirebaseFoodAdapter.foodToFirestore(food));
    } catch (e) {
      throw Exception('Failed to update food: $e');
    }
  }

  static Future<void> deleteFood(String foodId) async {
    try {
      await _firestore.collection(foodsCollection).doc(foodId).delete();
    } catch (e) {
      throw Exception('Failed to delete food: $e');
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

  // Add sample foods with local assets
  static Future<void> addSampleFoods() async {
    // Clear existing foods first (optional)
    await _clearExistingFoods();

    final now = DateTime.now();

    // Traditional Fish Curry
    final fishCurry = TraditionalFood(
      id: '',
      title: 'Traditional Fish Curry',
      description:
          'Authentic Sri Lankan fish curry prepared with fresh catch and traditional spices.',
      price: 1500.0,
      priceType: 'per_plate',
      location: 'Kinniya',
      address: 'Beach Restaurant, Kinniya, Trincomalee',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/rice_curry.jpg'],
      foodType: 'rice_and_curry',
      variety: 'fish',
      ingredients: [
        'Fresh Fish',
        'Coconut Milk',
        'Curry Leaves',
        'Spices',
        'Tomatoes',
        'Onions',
      ],
      spiceLevel: 'medium',
      preparationTime: '45 minutes',
      dietaryInfo: ['non-vegetarian'],
      isAvailable: true,
      availableFrom: now,
      availableTo: null,
      availableTimes: ['lunch', 'dinner'],
      provider: FoodProvider(
        id: 'chef1',
        name: 'Kamala Fernando',
        email: 'kamala@kinniyadining.com',
        phone: '+94771234567',
        profileImage: 'assets/images/manager.jpg',
        rating: 4.8,
        totalDishes: 15,
        specialties: ['Sri Lankan Cuisine', 'Seafood'],
      ),
      reviews: [
        Review(
          id: 'review_food1',
          userId: 'user1',
          userName: 'John Smith',
          userImage: 'assets/images/user.jpg',
          rating: 5.0,
          comment: 'Absolutely delicious! Best fish curry I\'ve ever tasted.',
          createdAt: now.subtract(const Duration(days: 3)),
        ),
      ],
      rating: 4.8,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );

    // String Hoppers
    final stringHoppers = TraditionalFood(
      id: '',
      title: 'String Hoppers with Curry',
      description:
          'Delicate string hoppers served with coconut sambol and curry.',
      price: 800.0,
      priceType: 'per_plate',
      location: 'Kinniya',
      address: 'Traditional Kitchen, Kinniya',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/rice_curry.jpg'],
      foodType: 'string_hoppers',
      ingredients: [
        'Rice Flour',
        'Coconut',
        'Curry Leaves',
        'Chilies',
        'Onions',
      ],
      spiceLevel: 'mild',
      preparationTime: '30 minutes',
      dietaryInfo: ['vegetarian', 'vegan'],
      isAvailable: true,
      availableFrom: now,
      availableTimes: ['breakfast', 'dinner'],
      provider: FoodProvider(
        id: 'chef2',
        name: 'Sunil Rathnayake',
        email: 'sunil@traditional.lk',
        phone: '+94771234568',
        profileImage: 'assets/images/manager.jpg',
        rating: 4.6,
        totalDishes: 12,
        specialties: ['Traditional Breakfast'],
      ),
      reviews: [],
      rating: 4.6,
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now,
    );

    // Pittu
    final pittu = TraditionalFood(
      id: '',
      title: 'Authentic Pittu',
      description:
          'Traditional steamed dish made with rice flour and coconut, served with curry.',
      price: 650.0,
      priceType: 'per_plate',
      location: 'Kinniya',
      address: 'Village Kitchen, Kinniya',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/puttu.jpg'],
      foodType: 'puttu',
      ingredients: ['Rice Flour', 'Coconut', 'Salt', 'Water'],
      spiceLevel: 'mild',
      preparationTime: '25 minutes',
      dietaryInfo: ['vegetarian', 'vegan', 'gluten-free'],
      isAvailable: true,
      availableFrom: now,
      availableTimes: ['breakfast', 'dinner'],
      provider: FoodProvider(
        id: 'chef3',
        name: 'Nirmala Silva',
        email: 'nirmala@village.lk',
        phone: '+94771234569',
        profileImage: 'assets/images/manager.jpg',
        rating: 4.7,
        totalDishes: 8,
        specialties: ['Village Cuisine'],
      ),
      reviews: [],
      rating: 4.7,
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now,
    );

    // Add all foods
    await addFood(fishCurry);
    await addFood(stringHoppers);
    await addFood(pittu);
  }

  static Future<void> _clearExistingFoods() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(foodsCollection)
          .get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing foods: $e');
    }
  }

  // Get foods by type
  static Future<List<TraditionalFood>> getFoodsByType(String foodType) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(foodsCollection)
          .where('foodType', isEqualTo: foodType)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseFoodAdapter.foodFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get foods by type: $e');
    }
  }

  // Get available foods
  static Future<List<TraditionalFood>> getAvailableFoods() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(foodsCollection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseFoodAdapter.foodFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get available foods: $e');
    }
  }

  // Get rice and curry varieties
  static Future<List<TraditionalFood>> getRiceAndCurryVarieties() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(foodsCollection)
          .where('foodType', isEqualTo: 'rice_and_curry')
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseFoodAdapter.foodFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get rice and curry varieties: $e');
    }
  }
}
