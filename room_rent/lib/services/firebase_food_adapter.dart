import '../models/traditional_food.dart';

class FirebaseFoodAdapter {
  // Convert your existing TraditionalFood model to Firebase-compatible format
  static Map<String, dynamic> foodToFirestore(TraditionalFood food) {
    return {
      'title': food.title,
      'description': food.description,
      'price': food.price,
      'priceType': food.priceType,
      'location': food.location,
      'address': food.address,
      'latitude': food.latitude,
      'longitude': food.longitude,
      'images': food.images,
      'foodType': food.foodType,
      'variety': food.variety,
      'ingredients': food.ingredients,
      'spiceLevel': food.spiceLevel,
      'preparationTime': food.preparationTime,
      'dietaryInfo': food.dietaryInfo,
      'isAvailable': food.isAvailable,
      'availableFrom': food.availableFrom.millisecondsSinceEpoch,
      'availableTo': food.availableTo?.millisecondsSinceEpoch,
      'availableTimes': food.availableTimes,
      'provider': {
        'id': food.provider.id,
        'name': food.provider.name,
        'phone': food.provider.phone,
        'email': food.provider.email,
        'profileImage': food.provider.profileImage,
        'rating': food.provider.rating,
        'totalDishes': food.provider.totalDishes,
        'specialties': food.provider.specialties,
      },
      'reviews': food.reviews
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
      'rating': food.rating,
      'additionalInfo': food.additionalInfo,
      'createdAt': food.createdAt.millisecondsSinceEpoch,
      'updatedAt': food.updatedAt.millisecondsSinceEpoch,
    };
  }

  // Convert Firebase document to your TraditionalFood model
  static TraditionalFood foodFromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return TraditionalFood(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      priceType: data['priceType'] ?? 'per_plate',
      location: data['location'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      foodType: data['foodType'] ?? '',
      variety: data['variety'],
      ingredients: List<String>.from(data['ingredients'] ?? []),
      spiceLevel: data['spiceLevel'] ?? 'mild',
      preparationTime: data['preparationTime'] ?? '',
      dietaryInfo: List<String>.from(data['dietaryInfo'] ?? []),
      isAvailable: data['isAvailable'] ?? false,
      availableFrom: DateTime.fromMillisecondsSinceEpoch(
        data['availableFrom'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      availableTo: data['availableTo'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['availableTo'])
          : null,
      availableTimes: List<String>.from(data['availableTimes'] ?? []),
      provider: FoodProvider(
        id: data['provider']?['id'] ?? '',
        name: data['provider']?['name'] ?? '',
        phone: data['provider']?['phone'] ?? '',
        email: data['provider']?['email'] ?? '',
        profileImage: data['provider']?['profileImage'],
        rating: (data['provider']?['rating'] ?? 0).toDouble(),
        totalDishes: data['provider']?['totalDishes'] ?? 0,
        specialties: List<String>.from(data['provider']?['specialties'] ?? []),
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
