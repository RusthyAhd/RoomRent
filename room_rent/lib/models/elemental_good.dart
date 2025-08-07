class ElementalGood {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceType; // 'per_day', 'per_week', 'per_month'
  final String location;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> images;
  final String
  goodType; // 'iron', 'kettle', 'rice_cooker', 'bbq_rack', 'gas_cooker_with_cylinder'
  final String brand;
  final String model;
  final String condition; // 'new', 'like_new', 'good', 'fair'
  final List<String> specifications;
  final String powerSource; // 'electric', 'gas', 'manual', 'battery'
  final bool requiresDeposit;
  final double? depositAmount;
  final bool isAvailable;
  final DateTime availableFrom;
  final DateTime? availableTo;
  final ElementalGoodOwner owner;
  final List<Review> reviews;
  final double rating;
  final Map<String, dynamic>? additionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  ElementalGood({
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
    required this.goodType,
    required this.brand,
    required this.model,
    required this.condition,
    required this.specifications,
    required this.powerSource,
    required this.requiresDeposit,
    this.depositAmount,
    required this.isAvailable,
    required this.availableFrom,
    this.availableTo,
    required this.owner,
    required this.reviews,
    required this.rating,
    this.additionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ElementalGood.fromJson(Map<String, dynamic> json) {
    return ElementalGood(
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
      goodType: json['goodType'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      condition: json['condition'] as String,
      specifications: List<String>.from(json['specifications'] as List),
      powerSource: json['powerSource'] as String,
      requiresDeposit: json['requiresDeposit'] as bool,
      depositAmount: json['depositAmount'] != null
          ? (json['depositAmount'] as num).toDouble()
          : null,
      isAvailable: json['isAvailable'] as bool,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: json['availableTo'] != null
          ? DateTime.parse(json['availableTo'] as String)
          : null,
      owner: ElementalGoodOwner.fromJson(json['owner'] as Map<String, dynamic>),
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
      'goodType': goodType,
      'brand': brand,
      'model': model,
      'condition': condition,
      'specifications': specifications,
      'powerSource': powerSource,
      'requiresDeposit': requiresDeposit,
      'depositAmount': depositAmount,
      'isAvailable': isAvailable,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo?.toIso8601String(),
      'owner': owner.toJson(),
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'rating': rating,
      'additionalInfo': additionalInfo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ElementalGood copyWith({
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
    String? goodType,
    String? brand,
    String? model,
    String? condition,
    List<String>? specifications,
    String? powerSource,
    bool? requiresDeposit,
    double? depositAmount,
    bool? isAvailable,
    DateTime? availableFrom,
    DateTime? availableTo,
    ElementalGoodOwner? owner,
    List<Review>? reviews,
    double? rating,
    Map<String, dynamic>? additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ElementalGood(
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
      goodType: goodType ?? this.goodType,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      condition: condition ?? this.condition,
      specifications: specifications ?? this.specifications,
      powerSource: powerSource ?? this.powerSource,
      requiresDeposit: requiresDeposit ?? this.requiresDeposit,
      depositAmount: depositAmount ?? this.depositAmount,
      isAvailable: isAvailable ?? this.isAvailable,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
      owner: owner ?? this.owner,
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ElementalGoodOwner {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final double rating;
  final int totalItems;

  ElementalGoodOwner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.rating,
    required this.totalItems,
  });

  factory ElementalGoodOwner.fromJson(Map<String, dynamic> json) {
    return ElementalGoodOwner(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profileImage'] as String?,
      rating: (json['rating'] as num).toDouble(),
      totalItems: json['totalItems'] as int,
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
      'totalItems': totalItems,
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
