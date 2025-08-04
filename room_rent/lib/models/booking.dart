class Booking {
  final String id;
  final String userId;
  final String roomId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final double totalAmount;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final String paymentStatus; // 'pending', 'paid', 'failed', 'refunded'
  final String? paymentMethod;
  final String? paymentId;
  final String? specialRequests;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.paymentId,
    this.specialRequests,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['userId'] as String,
      roomId: json['roomId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      userPhone: json['userPhone'] as String,
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      checkOutDate: DateTime.parse(json['checkOutDate'] as String),
      guests: json['guests'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      paymentId: json['paymentId'] as String?,
      specialRequests: json['specialRequests'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'roomId': roomId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'guests': guests,
      'totalAmount': totalAmount,
      'status': status,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'paymentId': paymentId,
      'specialRequests': specialRequests,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  int get numberOfDays {
    return checkOutDate.difference(checkInDate).inDays;
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';

  bool get isPaymentPending => paymentStatus == 'pending';
  bool get isPaymentPaid => paymentStatus == 'paid';
  bool get isPaymentFailed => paymentStatus == 'failed';
  bool get isPaymentRefunded => paymentStatus == 'refunded';

  Booking copyWith({
    String? id,
    String? userId,
    String? roomId,
    String? userName,
    String? userEmail,
    String? userPhone,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guests,
    double? totalAmount,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? paymentId,
    String? specialRequests,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roomId: roomId ?? this.roomId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guests: guests ?? this.guests,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentId: paymentId ?? this.paymentId,
      specialRequests: specialRequests ?? this.specialRequests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
