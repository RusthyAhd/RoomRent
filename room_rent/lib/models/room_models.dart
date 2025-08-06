class RoomItem {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final List<String> panoramaUrls;
  final double price;
  final String contactPhone;
  final DateTime createdAt;

  RoomItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.panoramaUrls,
    required this.price,
    required this.contactPhone,
    required this.createdAt,
  });

  factory RoomItem.fromMap(Map<String, dynamic> map, String documentId) {
    return RoomItem(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      panoramaUrls: List<String>.from(map['panoramaUrls'] ?? []),
      price: (map['price'] ?? 0.0).toDouble(),
      contactPhone: map['contactPhone'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'panoramaUrls': panoramaUrls,
      'price': price,
      'contactPhone': contactPhone,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}

class ChatMessage {
  final String id;
  final String message;
  final String senderName;
  final DateTime timestamp;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.message,
    required this.senderName,
    required this.timestamp,
    this.imageUrl,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, String documentId) {
    return ChatMessage(
      id: documentId,
      message: map['message'] ?? '',
      senderName: map['senderName'] ?? 'Anonymous',
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderName': senderName,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
    };
  }
}
