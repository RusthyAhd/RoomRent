import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/room.dart';
import 'firebase_room_adapter.dart';

class FirebaseRoomService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection names
  static const String roomsCollection = 'rooms';

  // Storage paths
  static const String roomImagesPath = 'room_images';
  static const String panoramaImagesPath = 'panorama_images';

  // Room operations using your existing Room model
  static Future<String> addRoom(Room room) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(roomsCollection)
          .add(FirebaseRoomAdapter.roomToFirestore(room));
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add room: $e');
    }
  }

  static Stream<List<Room>> getRoomsStream() {
    return _firestore
        .collection(roomsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    FirebaseRoomAdapter.roomFromFirestore(doc.data(), doc.id),
              )
              .toList(),
        );
  }

  static Future<List<Room>> getRooms() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(roomsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => FirebaseRoomAdapter.roomFromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get rooms: $e');
    }
  }

  static Future<Room?> getRoom(String roomId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(roomsCollection)
          .doc(roomId)
          .get();

      if (doc.exists) {
        return FirebaseRoomAdapter.roomFromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get room: $e');
    }
  }

  static Future<void> updateRoom(String roomId, Room room) async {
    try {
      await _firestore
          .collection(roomsCollection)
          .doc(roomId)
          .update(FirebaseRoomAdapter.roomToFirestore(room));
    } catch (e) {
      throw Exception('Failed to update room: $e');
    }
  }

  static Future<void> deleteRoom(String roomId) async {
    try {
      await _firestore.collection(roomsCollection).doc(roomId).delete();
    } catch (e) {
      throw Exception('Failed to delete room: $e');
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

  // Add a sample room with your existing structure
  static Future<void> addSampleRoom() async {
    final sampleRoom = Room(
      id: '',
      title: 'Beautiful Sea View Villa',
      description:
          'A stunning villa with panoramic ocean views, perfect for a peaceful getaway. Features modern amenities and traditional charm.',
      price: 150.0,
      priceType: 'per_night',
      location: 'Kinniya',
      address: 'Beach Road, Kinniya, Sri Lanka',
      latitude: 8.4877,
      longitude: 81.1837,
      images: [
        'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
        'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
        'https://images.unsplash.com/photo-1576941089067-2de3c901e126?w=800',
      ],
      panoramaImage:
          'https://images.unsplash.com/photo-1600121848594-d8644e57abab?w=1200',
      bedrooms: 3,
      bathrooms: 2,
      area: 120.0,
      amenities: [
        'WiFi',
        'Air Conditioning',
        'Sea View',
        'Kitchen',
        'Parking',
        'Swimming Pool',
        'Beach Access',
      ],
      isAvailable: true,
      availableFrom: DateTime.now(),
      availableTo: null,
      inCharge: RoomInCharge(
        id: 'owner1',
        name: 'Ahmed Hassan',
        email: 'ahmed@kinniyguesthouse.com',
        phone: '+94771234567',
        avatar:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
        role: 'owner',
        rating: 4.8,
        totalReviews: 42,
        isVerified: true,
        bio: 'Experienced host with over 5 years in hospitality',
        languages: ['English', 'Tamil', 'Sinhala'],
      ),
      reviews: [
        Review(
          id: 'review1',
          userId: 'user1',
          userName: 'Sarah Johnson',
          userAvatar:
              'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
          rating: 5.0,
          comment:
              'Amazing place! The sea view was breathtaking and Ahmed was a wonderful host.',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          images: null,
        ),
        Review(
          id: 'review2',
          userId: 'user2',
          userName: 'Mike Chen',
          userAvatar:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          rating: 4.5,
          comment:
              'Great location and very clean. Would definitely stay again!',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          images: null,
        ),
      ],
      rating: 4.8,
      propertyType: 'house',
      additionalInfo: {
        'checkIn': '14:00',
        'checkOut': '11:00',
        'minStay': 2,
        'maxGuests': 6,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await addRoom(sampleRoom);
  }

  // Utility methods
  static Future<bool> testConnection() async {
    try {
      await _firestore.collection('test').limit(1).get();
      return true;
    } catch (e) {
      return false;
    }
  }
}
