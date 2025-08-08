import '../models/elemental_good.dart';

class FirebaseGoodsAdapter {
  // Convert your existing ElementalGood model to Firebase-compatible format
  static Map<String, dynamic> goodToFirestore(ElementalGood good) {
    return {
      'title': good.title,
      'description': good.description,
      'price': good.price,
      'priceType': good.priceType,
      'location': good.location,
      'address': good.address,
      'latitude': good.latitude,
      'longitude': good.longitude,
      'images': good.images,
      'goodType': good.goodType,
      'brand': good.brand,
      'model': good.model,
      'condition': good.condition,
      'specifications': good.specifications,
      'powerSource': good.powerSource,
      'requiresDeposit': good.requiresDeposit,
      'depositAmount': good.depositAmount,
      'isAvailable': good.isAvailable,
      'availableFrom': good.availableFrom.millisecondsSinceEpoch,
      'availableTo': good.availableTo?.millisecondsSinceEpoch,
      'owner': {
        'id': good.owner.id,
        'name': good.owner.name,
        'phone': good.owner.phone,
        'email': good.owner.email,
        'profileImage': good.owner.profileImage,
        'rating': good.owner.rating,
        'totalItems': good.owner.totalItems,
      },
      'reviews': good.reviews
          .map(
            (review) => {
              'id': review.id,
              'userId': review.userId,
              'userName': review.userName,
              'userImage': review.userImage,
              'rating': review.rating,
              'comment': review.comment,
              'createdAt': review.createdAt.millisecondsSinceEpoch,
            },
          )
          .toList(),
      'rating': good.rating,
      'additionalInfo': good.additionalInfo,
      'createdAt': good.createdAt.millisecondsSinceEpoch,
      'updatedAt': good.updatedAt.millisecondsSinceEpoch,
    };
  }

  // Convert Firebase document to your ElementalGood model
  static ElementalGood goodFromFirestore(Map<String, dynamic> data, String id) {
    return ElementalGood(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      priceType: data['priceType'] ?? 'per_day',
      location: data['location'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      goodType: data['goodType'] ?? '',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      condition: data['condition'] ?? 'good',
      specifications: List<String>.from(data['specifications'] ?? []),
      powerSource: data['powerSource'] ?? 'manual',
      requiresDeposit: data['requiresDeposit'] ?? false,
      depositAmount: data['depositAmount'] != null
          ? (data['depositAmount'] as num).toDouble()
          : null,
      isAvailable: data['isAvailable'] ?? false,
      availableFrom: DateTime.fromMillisecondsSinceEpoch(
        data['availableFrom'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      availableTo: data['availableTo'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['availableTo'])
          : null,
      owner: ElementalGoodOwner(
        id: data['owner']?['id'] ?? '',
        name: data['owner']?['name'] ?? '',
        phone: data['owner']?['phone'] ?? '',
        email: data['owner']?['email'] ?? '',
        profileImage: data['owner']?['profileImage'],
        rating: (data['owner']?['rating'] ?? 0).toDouble(),
        totalItems: data['owner']?['totalItems'] ?? 0,
      ),
      reviews: (data['reviews'] as List? ?? [])
          .map(
            (reviewData) => Review(
              id: reviewData['id'] ?? '',
              userId: reviewData['userId'] ?? '',
              userName: reviewData['userName'] ?? '',
              userImage: reviewData['userImage'],
              rating: (reviewData['rating'] ?? 0).toDouble(),
              comment: reviewData['comment'] ?? '',
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                reviewData['createdAt'] ??
                    DateTime.now().millisecondsSinceEpoch,
              ),
            ),
          )
          .toList(),
      rating: (data['rating'] ?? 0).toDouble(),
      additionalInfo: data['additionalInfo'] as Map<String, dynamic>?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        data['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
