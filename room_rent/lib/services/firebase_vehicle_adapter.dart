import '../models/vehicle.dart';

class FirebaseVehicleAdapter {
  // Convert your existing Vehicle model to Firebase-compatible format
  static Map<String, dynamic> vehicleToFirestore(Vehicle vehicle) {
    return {
      'title': vehicle.title,
      'description': vehicle.description,
      'price': vehicle.price,
      'priceType': vehicle.priceType,
      'location': vehicle.location,
      'address': vehicle.address,
      'latitude': vehicle.latitude,
      'longitude': vehicle.longitude,
      'images': vehicle.images,
      'vehicleType': vehicle.vehicleType,
      'make': vehicle.make,
      'model': vehicle.model,
      'year': vehicle.year,
      'fuelType': vehicle.fuelType,
      'seatingCapacity': vehicle.seatingCapacity,
      'transmissionType': vehicle.transmissionType,
      'features': vehicle.features,
      'isAvailable': vehicle.isAvailable,
      'availableFrom': vehicle.availableFrom.millisecondsSinceEpoch,
      'availableTo': vehicle.availableTo?.millisecondsSinceEpoch,
      'owner': {
        'id': vehicle.owner.id,
        'name': vehicle.owner.name,
        'phone': vehicle.owner.phone,
        'email': vehicle.owner.email,
        'profileImage': vehicle.owner.profileImage,
        'rating': vehicle.owner.rating,
        'totalVehicles': vehicle.owner.totalVehicles,
      },
      'reviews': vehicle.reviews
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
      'rating': vehicle.rating,
      'additionalInfo': vehicle.additionalInfo,
      'createdAt': vehicle.createdAt.millisecondsSinceEpoch,
      'updatedAt': vehicle.updatedAt.millisecondsSinceEpoch,
    };
  }

  // Convert Firebase document to your Vehicle model
  static Vehicle vehicleFromFirestore(Map<String, dynamic> data, String id) {
    return Vehicle(
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
      vehicleType: data['vehicleType'] ?? '',
      make: data['make'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? '',
      fuelType: data['fuelType'] ?? '',
      seatingCapacity: data['seatingCapacity'] ?? 1,
      transmissionType: data['transmissionType'] ?? 'manual',
      features: List<String>.from(data['features'] ?? []),
      isAvailable: data['isAvailable'] ?? false,
      availableFrom: DateTime.fromMillisecondsSinceEpoch(
        data['availableFrom'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      availableTo: data['availableTo'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['availableTo'])
          : null,
      owner: VehicleOwner(
        id: data['owner']?['id'] ?? '',
        name: data['owner']?['name'] ?? '',
        phone: data['owner']?['phone'] ?? '',
        email: data['owner']?['email'] ?? '',
        profileImage: data['owner']?['profileImage'],
        rating: (data['owner']?['rating'] ?? 0).toDouble(),
        totalVehicles: data['owner']?['totalVehicles'] ?? 0,
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
