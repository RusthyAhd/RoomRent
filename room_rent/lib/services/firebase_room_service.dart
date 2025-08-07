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

  // Add sample rooms with local assets
  static Future<void> addSampleRoom() async {
    // Clear existing rooms first (optional)
    await _clearExistingRooms();

    // AC Room
    final acRoom = Room(
      id: '',
      title: 'Premium AC Room',
      description:
          'Comfortable air-conditioned room perfect for a relaxing stay. Features modern amenities, comfortable bedding, and climate control for your comfort.',
      price: 75.0,
      priceType: 'per_night',
      location: 'Kinniya',
      address: 'Main Street, Kinniya, Sri Lanka',
      latitude: 8.4877,
      longitude: 81.1837,
      images: ['assets/images/ac room.jpg', 'assets/images/user.jpg'],
      panoramaImage: 'assets/images/ac room.jpg',
      bedrooms: 1,
      bathrooms: 1,
      area: 25.0,
      amenities: [
        'Air Conditioning',
        'WiFi',
        'Private Bathroom',
        'Hot Water',
        'Comfortable Bed',
        'TV',
        'Room Service',
      ],
      isAvailable: true,
      availableFrom: DateTime.now(),
      availableTo: null,
      inCharge: RoomInCharge(
        id: 'manager1',
        name: 'Priya Sharma',
        email: 'priya@kinniyguesthouse.com',
        phone: '+94771234567',
        avatar: 'assets/images/manager.jpg',
        role: 'manager',
        rating: 4.7,
        totalReviews: 35,
        isVerified: true,
        bio: 'Professional hotel manager with 8 years experience',
        languages: ['English', 'Tamil', 'Sinhala'],
      ),
      reviews: [
        Review(
          id: 'review_ac1',
          userId: 'user1',
          userName: 'David Wilson',
          userAvatar: 'assets/images/user.jpg',
          rating: 5.0,
          comment:
              'Excellent AC room! Very clean and comfortable. The air conditioning worked perfectly.',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          images: null,
        ),
      ],
      rating: 4.7,
      propertyType: 'room',
      additionalInfo: {
        'checkIn': '14:00',
        'checkOut': '11:00',
        'minStay': 1,
        'maxGuests': 2,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Non-AC Room
    final nonAcRoom = Room(
      id: '',
      title: 'Cozy Non-AC Room',
      description:
          'Budget-friendly room with natural ventilation and ceiling fan. Perfect for travelers who prefer a more authentic experience with all essential amenities.',
      price: 45.0,
      priceType: 'per_night',
      location: 'Kinniya',
      address: 'Garden Lane, Kinniya, Sri Lanka',
      latitude: 8.4880,
      longitude: 81.1840,
      images: ['assets/images/non-ac room.jpg', 'assets/images/user.jpg'],
      panoramaImage: 'assets/images/non-ac room.jpg',
      bedrooms: 1,
      bathrooms: 1,
      area: 20.0,
      amenities: [
        'Ceiling Fan',
        'WiFi',
        'Private Bathroom',
        'Hot Water',
        'Comfortable Bed',
        'Natural Ventilation',
        'Room Service',
      ],
      isAvailable: true,
      availableFrom: DateTime.now(),
      availableTo: null,
      inCharge: RoomInCharge(
        id: 'manager2',
        name: 'Rajesh Kumar',
        email: 'rajesh@kinniyguesthouse.com',
        phone: '+94771234568',
        avatar: 'assets/images/manager.jpg',
        role: 'manager',
        rating: 4.5,
        totalReviews: 28,
        isVerified: true,
        bio: 'Friendly manager dedicated to guest comfort',
        languages: ['English', 'Tamil', 'Hindi'],
      ),
      reviews: [
        Review(
          id: 'review_nonac1',
          userId: 'user2',
          userName: 'Lisa Chen',
          userAvatar: 'assets/images/user.jpg',
          rating: 4.5,
          comment:
              'Great value for money! Clean and comfortable room with good natural ventilation.',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          images: null,
        ),
      ],
      rating: 4.5,
      propertyType: 'room',
      additionalInfo: {
        'checkIn': '14:00',
        'checkOut': '11:00',
        'minStay': 1,
        'maxGuests': 2,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Conference Hall
    final conferenceHall = Room(
      id: '',
      title: 'Modern Conference Hall',
      description:
          'Spacious conference hall perfect for meetings, seminars, and events. Equipped with modern audio-visual equipment and comfortable seating arrangements.',
      price: 200.0,
      priceType: 'per_day',
      location: 'Kinniya',
      address: 'Business District, Kinniya, Sri Lanka',
      latitude: 8.4885,
      longitude: 81.1845,
      images: ['assets/images/confrence hall.jpg', 'assets/images/manager.jpg'],
      panoramaImage: 'assets/images/confrence hall.jpg',
      bedrooms: 0,
      bathrooms: 2,
      area: 150.0,
      amenities: [
        'Air Conditioning',
        'Projector',
        'Sound System',
        'WiFi',
        'Whiteboard',
        'Conference Table',
        'Comfortable Seating',
        'Parking',
        'Catering Service',
      ],
      isAvailable: true,
      availableFrom: DateTime.now(),
      availableTo: null,
      inCharge: RoomInCharge(
        id: 'manager3',
        name: 'Anil Fernando',
        email: 'anil@kinniyguesthouse.com',
        phone: '+94771234569',
        avatar: 'assets/images/manager.jpg',
        role: 'events_manager',
        rating: 4.9,
        totalReviews: 45,
        isVerified: true,
        bio: 'Expert events manager specializing in corporate functions',
        languages: ['English', 'Sinhala', 'Tamil'],
      ),
      reviews: [
        Review(
          id: 'review_conf1',
          userId: 'user3',
          userName: 'Ahmed Ali',
          userAvatar: 'assets/images/user.jpg',
          rating: 5.0,
          comment:
              'Perfect venue for our business meeting. Excellent facilities and professional service.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          images: null,
        ),
      ],
      rating: 4.9,
      propertyType: 'conference',
      additionalInfo: {
        'checkIn': '08:00',
        'checkOut': '18:00',
        'minStay': 1,
        'maxGuests': 50,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Add all rooms
    await addRoom(acRoom);
    await addRoom(nonAcRoom);
    await addRoom(conferenceHall);
  }

  // Helper method to clear existing rooms (optional)
  static Future<void> _clearExistingRooms() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(roomsCollection)
          .get();
      WriteBatch batch = _firestore.batch();

      for (DocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error clearing existing rooms: $e');
    }
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
