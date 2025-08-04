class GuestHouseManager {
  final String id;
  final String name;
  final String position; // e.g., "Guest House Manager", "In-Charge"
  final String email;
  final String phone;
  final String? whatsapp;
  final String? avatar;
  final String bio;
  final String guestHouseName;
  final String village;
  final String district;
  final String state;
  final int yearsOfExperience;
  final List<String> languages;
  final List<String>
  specialties; // e.g., "Local Tours", "Traditional Food", etc.
  final bool isAvailable;
  final String? facebookProfile;
  final String? instagramProfile;
  final double rating;
  final int totalGuests;
  final List<String> certificates; // Any hospitality certificates
  final List<ManagerReview> reviews;
  final EmergencyContact? emergencyContact;
  final DateTime joinedDate;

  GuestHouseManager({
    required this.id,
    required this.name,
    required this.position,
    required this.email,
    required this.phone,
    this.whatsapp,
    this.avatar,
    required this.bio,
    required this.guestHouseName,
    required this.village,
    required this.district,
    required this.state,
    required this.yearsOfExperience,
    required this.languages,
    required this.specialties,
    required this.isAvailable,
    this.facebookProfile,
    this.instagramProfile,
    required this.rating,
    required this.totalGuests,
    required this.certificates,
    required this.reviews,
    this.emergencyContact,
    required this.joinedDate,
  });

  factory GuestHouseManager.fromJson(Map<String, dynamic> json) {
    return GuestHouseManager(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      whatsapp: json['whatsapp'] as String?,
      avatar: json['avatar'] as String?,
      bio: json['bio'] as String,
      guestHouseName: json['guestHouseName'] as String,
      village: json['village'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      yearsOfExperience: json['yearsOfExperience'] as int,
      languages: List<String>.from(json['languages'] as List),
      specialties: List<String>.from(json['specialties'] as List),
      isAvailable: json['isAvailable'] as bool,
      facebookProfile: json['facebookProfile'] as String?,
      instagramProfile: json['instagramProfile'] as String?,
      rating: (json['rating'] as num).toDouble(),
      totalGuests: json['totalGuests'] as int,
      certificates: List<String>.from(json['certificates'] as List),
      reviews: (json['reviews'] as List)
          .map(
            (review) => ManagerReview.fromJson(review as Map<String, dynamic>),
          )
          .toList(),
      emergencyContact: json['emergencyContact'] != null
          ? EmergencyContact.fromJson(
              json['emergencyContact'] as Map<String, dynamic>,
            )
          : null,
      joinedDate: DateTime.parse(json['joinedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'email': email,
      'phone': phone,
      'whatsapp': whatsapp,
      'avatar': avatar,
      'bio': bio,
      'guestHouseName': guestHouseName,
      'village': village,
      'district': district,
      'state': state,
      'yearsOfExperience': yearsOfExperience,
      'languages': languages,
      'specialties': specialties,
      'isAvailable': isAvailable,
      'facebookProfile': facebookProfile,
      'instagramProfile': instagramProfile,
      'rating': rating,
      'totalGuests': totalGuests,
      'certificates': certificates,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'emergencyContact': emergencyContact?.toJson(),
      'joinedDate': joinedDate.toIso8601String(),
    };
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String relationship; // e.g., "Son", "Daughter", "Assistant"

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relationship,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] as String,
      phone: json['phone'] as String,
      relationship: json['relationship'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'relationship': relationship};
  }
}

class ManagerReview {
  final String id;
  final String guestName;
  final String? guestAvatar;
  final double rating;
  final String comment;
  final DateTime stayDate;
  final DateTime reviewDate;
  final List<String>
  highlights; // e.g., "Helpful", "Responsive", "Local Knowledge"

  ManagerReview({
    required this.id,
    required this.guestName,
    this.guestAvatar,
    required this.rating,
    required this.comment,
    required this.stayDate,
    required this.reviewDate,
    required this.highlights,
  });

  factory ManagerReview.fromJson(Map<String, dynamic> json) {
    return ManagerReview(
      id: json['id'] as String,
      guestName: json['guestName'] as String,
      guestAvatar: json['guestAvatar'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      stayDate: DateTime.parse(json['stayDate'] as String),
      reviewDate: DateTime.parse(json['reviewDate'] as String),
      highlights: List<String>.from(json['highlights'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guestName': guestName,
      'guestAvatar': guestAvatar,
      'rating': rating,
      'comment': comment,
      'stayDate': stayDate.toIso8601String(),
      'reviewDate': reviewDate.toIso8601String(),
      'highlights': highlights,
    };
  }
}
