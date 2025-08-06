import '../models/room_models.dart';
import '../services/firebase_service.dart';

class SampleDataLoader {
  static Future<void> loadSampleRooms() async {
    final sampleRooms = [
      RoomItem(
        id: '',
        title: 'Deluxe Ocean View Room',
        description:
            'Spacious room with stunning ocean views, private balcony, and modern amenities. Perfect for couples seeking a romantic getaway.',
        imageUrls: [
          'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
          'https://images.unsplash.com/photo-1578683010236-d716f9a3f461?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2072&q=80',
        ],
        panoramaUrls: [
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
        ],
        price: 150.0,
        contactPhone: '+94777123456',
        createdAt: DateTime.now(),
      ),
      RoomItem(
        id: '',
        title: 'Cozy Garden Suite',
        description:
            'Peaceful garden-facing suite with traditional décor and modern comfort. Includes complimentary breakfast and garden access.',
        imageUrls: [
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2158&q=80',
          'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
        ],
        panoramaUrls: [
          'https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2074&q=80',
        ],
        price: 120.0,
        contactPhone: '+94777654321',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      RoomItem(
        id: '',
        title: 'Family Beach Villa',
        description:
            'Spacious villa accommodating up to 6 people, direct beach access, private pool, and full kitchen facilities.',
        imageUrls: [
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
          'https://images.unsplash.com/photo-1513584684374-8bab748fbf90?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2065&q=80',
        ],
        panoramaUrls: [
          'https://images.unsplash.com/photo-1502005229762-cf1b2da02f3f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2187&q=80',
        ],
        price: 300.0,
        contactPhone: '+94777987654',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];

    try {
      for (final room in sampleRooms) {
        await FirebaseService.addRoom(room);
        print('Added sample room: ${room.title}');
      }
      print('Sample data loaded successfully!');
    } catch (e) {
      print('Error loading sample data: $e');
    }
  }

  static Future<void> loadAllSampleData() async {
    print('Loading sample data...');
    await loadSampleRooms();
    print('All sample data loaded!');
  }
}
