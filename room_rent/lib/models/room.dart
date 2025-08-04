class Room {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceType; // 'per_night', 'per_month', 'per_week'
  final String location;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> images;
  final String? panoramaImage;
  final int bedrooms;
  final int bathrooms;
  final double area; // in square meters
  final List<String> amenities;
  final bool isAvailable;
  final DateTime availableFrom;
  final DateTime? availableTo;
  final RoomInCharge inCharge;
  final List<Review> reviews;
  final double rating;
  final String propertyType; // 'apartment', 'house', 'room', 'studio'
  final Map<String, dynamic>? additionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
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
    this.panoramaImage,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.amenities,
    required this.isAvailable,
    required this.availableFrom,
    this.availableTo,
    required this.inCharge,
    required this.reviews,
    required this.rating,
    required this.propertyType,
    this.additionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
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
      panoramaImage: json['panoramaImage'] as String?,
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      area: (json['area'] as num).toDouble(),
      amenities: List<String>.from(json['amenities'] as List),
      isAvailable: json['isAvailable'] as bool,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: json['availableTo'] != null
          ? DateTime.parse(json['availableTo'] as String)
          : null,
      inCharge: RoomInCharge.fromJson(json['inCharge'] as Map<String, dynamic>),
      reviews: (json['reviews'] as List)
          .map((review) => Review.fromJson(review as Map<String, dynamic>))
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      propertyType: json['propertyType'] as String,
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
      'panoramaImage': panoramaImage,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'amenities': amenities,
      'isAvailable': isAvailable,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo?.toIso8601String(),
      'inCharge': inCharge.toJson(),
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'rating': rating,
      'propertyType': propertyType,
      'additionalInfo': additionalInfo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Room copyWith({
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
    String? panoramaImage,
    int? bedrooms,
    int? bathrooms,
    double? area,
    List<String>? amenities,
    bool? isAvailable,
    DateTime? availableFrom,
    DateTime? availableTo,
    RoomInCharge? inCharge,
    List<Review>? reviews,
    double? rating,
    String? propertyType,
    Map<String, dynamic>? additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Room(
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
      panoramaImage: panoramaImage ?? this.panoramaImage,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      amenities: amenities ?? this.amenities,
      isAvailable: isAvailable ?? this.isAvailable,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
      inCharge: inCharge ?? this.inCharge,
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
      propertyType: propertyType ?? this.propertyType,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RoomInCharge {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String role; // 'owner', 'manager', 'agent'
  final double rating;
  final int totalReviews;
  final bool isVerified;
  final String? bio;
  final List<String> languages;

  RoomInCharge({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.role,
    required this.rating,
    required this.totalReviews,
    required this.isVerified,
    this.bio,
    required this.languages,
  });

  factory RoomInCharge.fromJson(Map<String, dynamic> json) {
    return RoomInCharge(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String,
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      isVerified: json['isVerified'] as bool,
      bio: json['bio'] as String?,
      languages: List<String>.from(json['languages'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'role': role,
      'rating': rating,
      'totalReviews': totalReviews,
      'isVerified': isVerified,
      'bio': bio,
      'languages': languages,
    };
  }
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String>? images;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'images': images,
    };
  }
}
