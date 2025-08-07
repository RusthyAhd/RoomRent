class Vehicle {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceType; // 'per_hour', 'per_day', 'per_week', 'per_month'
  final String location;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> images;
  final String
  vehicleType; // 'motorcycle', 'three_wheel', 'car', 'van', 'lorry'
  final String make;
  final String model;
  final String year;
  final String fuelType;
  final int seatingCapacity;
  final String transmissionType; // 'manual', 'automatic'
  final List<String> features;
  final bool isAvailable;
  final DateTime availableFrom;
  final DateTime? availableTo;
  final VehicleOwner owner;
  final List<Review> reviews;
  final double rating;
  final Map<String, dynamic>? additionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
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
    required this.vehicleType,
    required this.make,
    required this.model,
    required this.year,
    required this.fuelType,
    required this.seatingCapacity,
    required this.transmissionType,
    required this.features,
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

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
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
      vehicleType: json['vehicleType'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as String,
      fuelType: json['fuelType'] as String,
      seatingCapacity: json['seatingCapacity'] as int,
      transmissionType: json['transmissionType'] as String,
      features: List<String>.from(json['features'] as List),
      isAvailable: json['isAvailable'] as bool,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: json['availableTo'] != null
          ? DateTime.parse(json['availableTo'] as String)
          : null,
      owner: VehicleOwner.fromJson(json['owner'] as Map<String, dynamic>),
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
      'vehicleType': vehicleType,
      'make': make,
      'model': model,
      'year': year,
      'fuelType': fuelType,
      'seatingCapacity': seatingCapacity,
      'transmissionType': transmissionType,
      'features': features,
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

  Vehicle copyWith({
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
    String? vehicleType,
    String? make,
    String? model,
    String? year,
    String? fuelType,
    int? seatingCapacity,
    String? transmissionType,
    List<String>? features,
    bool? isAvailable,
    DateTime? availableFrom,
    DateTime? availableTo,
    VehicleOwner? owner,
    List<Review>? reviews,
    double? rating,
    Map<String, dynamic>? additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
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
      vehicleType: vehicleType ?? this.vehicleType,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      fuelType: fuelType ?? this.fuelType,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      transmissionType: transmissionType ?? this.transmissionType,
      features: features ?? this.features,
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

class VehicleOwner {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final double rating;
  final int totalVehicles;

  VehicleOwner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.rating,
    required this.totalVehicles,
  });

  factory VehicleOwner.fromJson(Map<String, dynamic> json) {
    return VehicleOwner(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profileImage: json['profileImage'] as String?,
      rating: (json['rating'] as num).toDouble(),
      totalVehicles: json['totalVehicles'] as int,
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
      'totalVehicles': totalVehicles,
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
