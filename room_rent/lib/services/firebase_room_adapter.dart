import '../models/room.dart';

class FirebaseRoomAdapter {
  // Convert your existing Room model to Firebase-compatible format
  static Map<String, dynamic> roomToFirestore(Room room) {
    return {
      'title': room.title,
      'description': room.description,
      'price': room.price,
      'priceType': room.priceType,
      'location': room.location,
      'address': room.address,
      'latitude': room.latitude,
      'longitude': room.longitude,
      'images': room.images,
      'panoramaImage': room.panoramaImage,
      'bedrooms': room.bedrooms,
      'bathrooms': room.bathrooms,
      'area': room.area,
      'amenities': room.amenities,
      'isAvailable': room.isAvailable,
      'availableFrom': room.availableFrom.millisecondsSinceEpoch,
      'availableTo': room.availableTo?.millisecondsSinceEpoch,
      'inCharge': {
        'id': room.inCharge.id,
        'name': room.inCharge.name,
        'phone': room.inCharge.phone,
        'email': room.inCharge.email,
        'avatar': room.inCharge.avatar,
        'role': room.inCharge.role,
        'rating': room.inCharge.rating,
        'totalReviews': room.inCharge.totalReviews,
        'isVerified': room.inCharge.isVerified,
        'bio': room.inCharge.bio,
        'languages': room.inCharge.languages,
      },
      'reviews': room.reviews
          .map(
            (review) => {
              'id': review.id,
              'userId': review.userId,
              'userName': review.userName,
              'userAvatar': review.userAvatar,
              'rating': review.rating,
              'comment': review.comment,
              'createdAt': review.createdAt.millisecondsSinceEpoch,
              'images': review.images,
            },
          )
          .toList(),
      'rating': room.rating,
      'propertyType': room.propertyType,
      'additionalInfo': room.additionalInfo,
      'createdAt': room.createdAt.millisecondsSinceEpoch,
      'updatedAt': room.updatedAt.millisecondsSinceEpoch,
    };
  }

  // Convert Firebase data to your existing Room model
  static Room roomFromFirestore(Map<String, dynamic> data, String documentId) {
    final inChargeData = data['inCharge'] as Map<String, dynamic>? ?? {};
    final reviewsData = data['reviews'] as List<dynamic>? ?? [];

    return Room(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      priceType: data['priceType'] ?? 'per_night',
      location: data['location'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      panoramaImage: data['panoramaImage'],
      bedrooms: data['bedrooms'] ?? 1,
      bathrooms: data['bathrooms'] ?? 1,
      area: (data['area'] ?? 0.0).toDouble(),
      amenities: List<String>.from(data['amenities'] ?? []),
      isAvailable: data['isAvailable'] ?? true,
      availableFrom: DateTime.fromMillisecondsSinceEpoch(
        data['availableFrom'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      availableTo: data['availableTo'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['availableTo'])
          : null,
      inCharge: RoomInCharge(
        id: inChargeData['id'] ?? '',
        name: inChargeData['name'] ?? '',
        email: inChargeData['email'] ?? '',
        phone: inChargeData['phone'] ?? '',
        avatar: inChargeData['avatar'],
        role: inChargeData['role'] ?? 'owner',
        rating: (inChargeData['rating'] ?? 0.0).toDouble(),
        totalReviews: inChargeData['totalReviews'] ?? 0,
        isVerified: inChargeData['isVerified'] ?? false,
        bio: inChargeData['bio'],
        languages: List<String>.from(inChargeData['languages'] ?? []),
      ),
      reviews: reviewsData
          .map(
            (reviewData) => Review(
              id: reviewData['id'] ?? '',
              userId: reviewData['userId'] ?? '',
              userName: reviewData['userName'] ?? '',
              userAvatar: reviewData['userAvatar'],
              rating: (reviewData['rating'] ?? 0.0).toDouble(),
              comment: reviewData['comment'] ?? '',
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                reviewData['createdAt'] ??
                    DateTime.now().millisecondsSinceEpoch,
              ),
              images: reviewData['images'] != null
                  ? List<String>.from(reviewData['images'])
                  : null,
            ),
          )
          .toList(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      propertyType: data['propertyType'] ?? 'room',
      additionalInfo: data['additionalInfo'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        data['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
