import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/elemental_good.dart';
import 'firebase_goods_adapter.dart';

class FirebaseGoodsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection names
  static const String goodsCollection = 'elemental_goods';

  // Storage paths
  static const String goodsImagesPath = 'goods_images';

  // Goods operations using your existing ElementalGood model
  static Future<String> addGood(ElementalGood good) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(goodsCollection)
          .add(FirebaseGoodsAdapter.goodToFirestore(good));
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add good: $e');
    }
  }

  static Stream<List<ElementalGood>> getGoodsStream() {
    return _firestore
        .collection(goodsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    FirebaseGoodsAdapter.goodFromFirestore(doc.data(), doc.id),
              )
              .toList(),
        );
  }

  static Future<List<ElementalGood>> getGoods() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(goodsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseGoodsAdapter.goodFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get goods: $e');
    }
  }

  static Future<ElementalGood?> getGood(String goodId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(goodsCollection)
          .doc(goodId)
          .get();

      if (doc.exists) {
        return FirebaseGoodsAdapter.goodFromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get good: $e');
    }
  }

  static Future<void> updateGood(String goodId, ElementalGood good) async {
    try {
      await _firestore
          .collection(goodsCollection)
          .doc(goodId)
          .update(FirebaseGoodsAdapter.goodToFirestore(good));
    } catch (e) {
      throw Exception('Failed to update good: $e');
    }
  }

  static Future<void> deleteGood(String goodId) async {
    try {
      await _firestore.collection(goodsCollection).doc(goodId).delete();
    } catch (e) {
      throw Exception('Failed to delete good: $e');
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

  // Add sample goods with local assets
  static Future<void> addSampleGoods() async {
    // Clear existing goods first (optional)
    await _clearExistingGoods();

    final now = DateTime.now();

    // Electric Rice Cooker
    final riceCooker = ElementalGood(
      id: '',
      title: 'Electric Rice Cooker',
      description:
          'High-quality electric rice cooker perfect for cooking rice and steaming.',
      price: 150.0,
      priceType: 'per_day',
      location: 'Kinniya',
      address: 'Appliance Rental, Main Street, Kinniya',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/rice_cooker.jpg'],
      goodType: 'rice_cooker',
      brand: 'Panasonic',
      model: 'SR-WA18',
      condition: 'good',
      specifications: [
        'Capacity: 1.8L',
        'Non-stick inner pot',
        'Keep warm function',
        'Auto shut-off',
        'Steam basket included',
      ],
      powerSource: 'electric',
      requiresDeposit: true,
      depositAmount: 2000.0,
      isAvailable: true,
      availableFrom: now,
      availableTo: null,
      owner: ElementalGoodOwner(
        id: 'owner1',
        name: 'Rajesh Kumar',
        email: 'rajesh@appliances.lk',
        phone: '+94771234567',
        profileImage: 'assets/images/manager.jpg',
        rating: 4.7,
        totalItems: 15,
      ),
      reviews: [
        Review(
          id: 'review_good1',
          userId: 'user1',
          userName: 'Maria Perera',
          userImage: 'assets/images/user.jpg',
          rating: 5.0,
          comment: 'Excellent rice cooker! Works perfectly and very clean.',
          createdAt: now.subtract(const Duration(days: 7)),
        ),
      ],
      rating: 4.7,
      createdAt: now.subtract(const Duration(days: 60)),
      updatedAt: now,
    );

    // Electric Kettle
    final kettle = ElementalGood(
      id: '',
      title: 'Electric Kettle',
      description:
          'Fast-boiling electric kettle with automatic shut-off for safety.',
      price: 75.0,
      priceType: 'per_day',
      location: 'Kinniya',
      address: 'Home Rentals, Beach Road, Kinniya',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/kettle.jpg'],
      goodType: 'kettle',
      brand: 'Philips',
      model: 'HD9350',
      condition: 'like_new',
      specifications: [
        'Capacity: 1.5L',
        'Cordless design',
        'Auto shut-off',
        'Boil-dry protection',
        'Stainless steel body',
      ],
      powerSource: 'electric',
      requiresDeposit: true,
      depositAmount: 1000.0,
      isAvailable: true,
      availableFrom: now,
      owner: ElementalGoodOwner(
        id: 'owner2',
        name: 'Saman Fernando',
        email: 'saman@homerentals.lk',
        phone: '+94771234568',
        profileImage: 'assets/images/manager.jpg',
        rating: 4.8,
        totalItems: 12,
      ),
      reviews: [],
      rating: 4.8,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );

    // Electric Iron
    final iron = ElementalGood(
      id: '',
      title: 'Electric Steam Iron',
      description:
          'Professional steam iron for wrinkle-free clothes and linens.',
      price: 100.0,
      priceType: 'per_day',
      location: 'Kinniya',
      address: 'Utility Rentals, Market Street, Kinniya',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/iron.jpg'],
      goodType: 'iron',
      brand: 'Tefal',
      model: 'FV4980',
      condition: 'good',
      specifications: [
        'Steam output: 40g/min',
        'Anti-drip system',
        'Self-cleaning function',
        'Variable temperature',
        'Non-stick soleplate',
      ],
      powerSource: 'electric',
      requiresDeposit: true,
      depositAmount: 1500.0,
      isAvailable: true,
      availableFrom: now,
      owner: ElementalGoodOwner(
        id: 'owner3',
        name: 'Lakshmi Silva',
        email: 'lakshmi@utility.lk',
        phone: '+94771234569',
        profileImage: 'assets/images/manager.jpg',
        rating: 4.6,
        totalItems: 20,
      ),
      reviews: [],
      rating: 4.6,
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now,
    );

    // Add all goods
    await addGood(riceCooker);
    await addGood(kettle);
    await addGood(iron);
  }

  static Future<void> _clearExistingGoods() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(goodsCollection)
          .get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing goods: $e');
    }
  }

  // Get goods by type
  static Future<List<ElementalGood>> getGoodsByType(String goodType) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(goodsCollection)
          .where('goodType', isEqualTo: goodType)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseGoodsAdapter.goodFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get goods by type: $e');
    }
  }

  // Get available goods
  static Future<List<ElementalGood>> getAvailableGoods() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(goodsCollection)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseGoodsAdapter.goodFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get available goods: $e');
    }
  }
}
