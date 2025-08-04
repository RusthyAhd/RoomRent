class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phone;
  final DateTime? dateOfBirth;
  final String role; // 'customer', 'owner', 'admin'
  final bool isVerified;
  final List<String> favoriteRooms;
  final List<String> bookingHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phone,
    this.dateOfBirth,
    required this.role,
    required this.isVerified,
    required this.favoriteRooms,
    required this.bookingHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      role: json['role'] as String,
      isVerified: json['isVerified'] as bool,
      favoriteRooms: List<String>.from(json['favoriteRooms'] as List),
      bookingHistory: List<String>.from(json['bookingHistory'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'role': role,
      'isVerified': isVerified,
      'favoriteRooms': favoriteRooms,
      'bookingHistory': bookingHistory,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
    DateTime? dateOfBirth,
    String? role,
    bool? isVerified,
    List<String>? favoriteRooms,
    List<String>? bookingHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      favoriteRooms: favoriteRooms ?? this.favoriteRooms,
      bookingHistory: bookingHistory ?? this.bookingHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
