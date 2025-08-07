class TraditionalFood {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceType; // 'per_plate', 'per_portion', 'per_kg'
  final String location;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> images;
  final String
  foodType; // 'string_hoppers', 'milk_hoppers', 'puttu', 'rice_and_curry'
  final String?
  variety; // For rice_and_curry: 'chicken', 'fish', 'beef', 'sea_foods'
  final List<String> ingredients;
  final String spiceLevel; // 'mild', 'medium', 'hot'
  final String preparationTime; // e.g., "30 minutes"
  final List<String>
  dietaryInfo; // 'vegetarian', 'non-vegetarian', 'vegan', 'gluten-free'
  final bool isAvailable;
  final DateTime availableFrom;
  final DateTime? availableTo;
  final List<String> availableTimes; // e.g., ['breakfast', 'lunch', 'dinner']
  final FoodProvider provider;
  final List<Review> reviews;
  final double rating;
  final Map<String, dynamic>? additionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  TraditionalFood({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.priceType,
    required this.location,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.foodType,
    this.variety,
    required this.ingredients,
    required this.spiceLevel,
    required this.preparationTime,
    required this.dietaryInfo,
    required this.isAvailable,
    required this.availableFrom,
    this.availableTo,
    required this.availableTimes,
    required this.provider,
    required this.reviews,
    required this.rating,
    this.additionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TraditionalFood.fromJson(Map<String, dynamic> json) {
    return TraditionalFood(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      priceType: json['priceType'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      images: List<String>.from(json['images'] as List),
      foodType: json['foodType'] as String,
      variety: json['variety'] as String?,
      ingredients: List<String>.from(json['ingredients'] as List),
      spiceLevel: json['spiceLevel'] as String,
      preparationTime: json['preparationTime'] as String,
      dietaryInfo: List<String>.from(json['dietaryInfo'] as List),
      isAvailable: json['isAvailable'] as bool,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: json['availableTo'] != null
          ? DateTime.parse(json['availableTo'] as String)
          : null,
      availableTimes: List<String>.from(json['availableTimes'] as List),
      provider: FoodProvider.fromJson(json['provider'] as Map<String, dynamic>),
      reviews: (json['reviews'] as List)
          .map((review) => Review.fromJson(review as Map<String, dynamic>))
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'priceType': priceType,
      'location': location,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'images': images,
      'foodType': foodType,
      'variety': variety,
      'ingredients': ingredients,
      'spiceLevel': spiceLevel,
      'preparationTime': preparationTime,
      'dietaryInfo': dietaryInfo,
      'isAvailable': isAvailable,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo?.toIso8601String(),
      'availableTimes': availableTimes,
      'provider': provider.toJson(),
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'rating': rating,
      'additionalInfo': additionalInfo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TraditionalFood copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? priceType,
    String? location,
    String? address,
    double? latitude,
    double? longitude,
    List<String>? images,
    String? foodType,
    String? variety,
    List<String>? ingredients,
    String? spiceLevel,
    String? preparationTime,
    List<String>? dietaryInfo,
    bool? isAvailable,
    DateTime? availableFrom,
    DateTime? availableTo,
    List<String>? availableTimes,
    FoodProvider? provider,
    List<Review>? reviews,
    double? rating,
    Map<String, dynamic>? additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TraditionalFood(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      priceType: priceType ?? this.priceType,
      location: location ?? this.location,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      images: images ?? this.images,
      foodType: foodType ?? this.foodType,
      variety: variety ?? this.variety,
      ingredients: ingredients ?? this.ingredients,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      preparationTime: preparationTime ?? this.preparationTime,
      dietaryInfo: dietaryInfo ?? this.dietaryInfo,
      isAvailable: isAvailable ?? this.isAvailable,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
      availableTimes: availableTimes ?? this.availableTimes,
      provider: provider ?? this.provider,
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class FoodProvider {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final double rating;
  final int totalDishes;
  final List<String> specialties;

  FoodProvider({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.rating,
    required this.totalDishes,
    required this.specialties,
  });

  factory FoodProvider.fromJson(Map<String, dynamic> json) {
    return FoodProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profileImage'] as String?,
      rating: (json['rating'] as num).toDouble(),
      totalDishes: json['totalDishes'] as int,
      specialties: List<String>.from(json['specialties'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'rating': rating,
      'totalDishes': totalDishes,
      'specialties': specialties,
    };
  }
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userImage;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userImage: json['userImage'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
