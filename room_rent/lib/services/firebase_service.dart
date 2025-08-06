import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/room_models.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static const String roomsCollection = 'rooms';

  // Storage paths
  static const String roomImagesPath = 'room_images';
  static const String panoramaImagesPath = 'panorama_images';

  // Room operations
  static Future<String> addRoom(RoomItem room) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(roomsCollection)
          .add(room.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add room: $e');
    }
  }

  static Stream<List<RoomItem>> getRoomsStream() {
    return _firestore
        .collection(roomsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RoomItem.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  static Future<void> updateRoom(String roomId, RoomItem room) async {
    try {
      await _firestore
          .collection(roomsCollection)
          .doc(roomId)
          .update(room.toMap());
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
