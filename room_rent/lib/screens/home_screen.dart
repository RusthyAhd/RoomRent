import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animated_background/animated_background.dart';
import '../providers/app_providers.dart';
import '../models/guest_house_manager.dart';
import '../models/room.dart';
import '../services/data_service.dart';
import '../widgets/glass_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  GuestHouseManager? manager;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _slideController.forward();

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomProvider>().loadRooms();
      _loadManager();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadManager() async {
    try {
      final loadedManager = await DataService().loadManager();
      setState(() {
        manager = loadedManager;
      });
    } catch (e) {
      print('Error loading manager: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: BubblesBehaviour(),
        vsync: this,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF667eea)],
            ),
          ),
          child: SlideTransition(
            position: _slideAnimation,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Shimmer.fromColors(
                      baseColor: Colors.white70,
                      highlightColor: Colors.white,
                      child: const Text(
                        'Village Guest House',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Find your perfect room for a comfortable stay',
                      style: TextStyle(fontSize: 16, color: Colors.white60),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Room Categories',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Consumer<RoomProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }

                          final availableRooms = provider.rooms
                              .where((room) => room.isAvailable)
                              .toList();

                          if (availableRooms.isEmpty) {
                            return const Center(
                              child: Text(
                                'No rooms available at the moment',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          // Separate rooms into exactly 2 categories: AC and Non-AC
                          final acRooms = availableRooms
                              .where(
                                (room) =>
                                    room.amenities.contains('Air Conditioning'),
                              )
                              .toList();
                          final nonAcRooms = availableRooms
                              .where(
                                (room) => !room.amenities.contains(
                                  'Air Conditioning',
                                ),
                              )
                              .toList();

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                // AC Rooms Container
                                _buildRoomCategoryContainer(
                                  'Air Conditioned Rooms',
                                  acRooms,
                                  Icons.ac_unit,
                                  Colors.lightBlueAccent,
                                  'Premium comfort with climate control',
                                ),
                                const SizedBox(height: 20),

                                // Non-AC Rooms Container
                                _buildRoomCategoryContainer(
                                  'Non-AC Rooms',
                                  nonAcRooms,
                                  Icons.air,
                                  Colors.greenAccent,
                                  'Affordable comfort with natural ventilation',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCategoryContainer(
    String title,
    List<Room> rooms,
    IconData icon,
    Color accentColor,
    String description,
  ) {
    return GlassCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: accentColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${rooms.length} available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Room Cards Section
          if (rooms.isNotEmpty)
            SizedBox(
              height: 220,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return Container(
                    width: 300,
                    margin: EdgeInsets.only(
                      right: index < rooms.length - 1 ? 16 : 0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _showRoomDetails(room),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      room.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accentColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: accentColor,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          room.rating.toStringAsFixed(1),
                                          style: TextStyle(
                                            color: accentColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                room.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white60,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      room.location,
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${room.price.toStringAsFixed(0)}/${room.priceType.replaceAll('per_', '')}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showContactInfo(context, room);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Book Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No ${title.toLowerCase()} available at the moment',
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showRoomDetails(Room room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Room Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    'assets/images/room.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Room Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                room.location,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.green,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '\$${room.price}/${room.priceType.replaceAll('per_', '')}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              room.description,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: room.amenities.contains('Air Conditioning')
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: room.amenities.contains('Air Conditioning')
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                          ),
                          child: Text(
                            room.amenities.contains('Air Conditioning')
                                ? 'AC Room'
                                : 'Non-AC Room',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: room.amenities.contains('Air Conditioning')
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Shift Selection Buttons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Choose Your Preferred Shift:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showManagerProfile(context, room, 'day');
                              },
                              icon: const Icon(
                                Icons.wb_sunny,
                                color: Colors.orange,
                              ),
                              label: const Text('Day Shift'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.withOpacity(0.1),
                                foregroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.orange),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showManagerProfile(context, room, 'night');
                              },
                              icon: const Icon(
                                Icons.nightlight_round,
                                color: Colors.indigo,
                              ),
                              label: const Text('Night Shift'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo.withOpacity(0.1),
                                foregroundColor: Colors.indigo,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.indigo),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContactInfo(BuildContext context, [Room? room]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            room != null ? 'Contact for ${room.title}' : 'Contact Manager',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (room != null) ...[
                Text('Room: ${room.title}'),
                Text(
                  'Price: \$${room.price}/${room.priceType.replaceAll('per_', '')}',
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                'Contact Information:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (manager != null) ...[
                Text('Manager: ${manager!.name}'),
                Text('Phone: ${manager!.phone}'),
                Text('Email: ${manager!.email}'),
              ] else ...[
                const Text('Manager: Village Guest House'),
                const Text('Phone: +1234567890'),
                const Text('Email: info@villageguesthouse.com'),
              ],
              const SizedBox(height: 8),
              const Text(
                'Available 24/7 for bookings and inquiries',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Here you could implement actual calling or messaging functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Contact information copied! Call or email to book.',
                    ),
                  ),
                );
              },
              child: const Text('Contact Now'),
            ),
          ],
        );
      },
    );
  }

  void _showManagerProfile(BuildContext context, Room room, String shift) {
    // Define manager data for day and night shifts
    final Map<String, Map<String, String>> managerData = {
      'day': {
        'name': 'John Smith',
        'phone': '+1234567890',
        'email': 'john.smith@villageguesthouse.com',
        'experience': '8 years',
        'specialization': 'Guest Services & Day Operations',
        'availability': '6:00 AM - 6:00 PM',
        'languages': 'English, Spanish',
      },
      'night': {
        'name': 'Maria Rodriguez',
        'phone': '+1987654321',
        'email': 'maria.rodriguez@villageguesthouse.com',
        'experience': '6 years',
        'specialization': 'Night Security & Guest Assistance',
        'availability': '6:00 PM - 6:00 AM',
        'languages': 'English, French',
      },
    };

    final managerInfo = managerData[shift]!;
    final isDay = shift == 'day';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with shift indicator
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDay
                          ? [
                              Colors.orange.withOpacity(0.8),
                              Colors.amber.withOpacity(0.8),
                            ]
                          : [
                              Colors.indigo.withOpacity(0.8),
                              Colors.purple.withOpacity(0.8),
                            ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isDay ? Icons.wb_sunny : Icons.nightlight_round,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${shift.toUpperCase()} SHIFT MANAGER',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Manager Profile Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Manager Image
                        CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/manager.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey[600],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Manager Name
                        Text(
                          managerInfo['name']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Specialization
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDay
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.indigo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDay ? Colors.orange : Colors.indigo,
                            ),
                          ),
                          child: Text(
                            managerInfo['specialization']!,
                            style: TextStyle(
                              color: isDay ? Colors.orange : Colors.indigo,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Manager Details
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildManagerDetailItem(
                                  Icons.phone,
                                  'Phone',
                                  managerInfo['phone']!,
                                  isDay ? Colors.orange : Colors.indigo,
                                ),
                                _buildManagerDetailItem(
                                  Icons.email,
                                  'Email',
                                  managerInfo['email']!,
                                  isDay ? Colors.orange : Colors.indigo,
                                ),
                                _buildManagerDetailItem(
                                  Icons.schedule,
                                  'Availability',
                                  managerInfo['availability']!,
                                  isDay ? Colors.orange : Colors.indigo,
                                ),
                                _buildManagerDetailItem(
                                  Icons.work,
                                  'Experience',
                                  managerInfo['experience']!,
                                  isDay ? Colors.orange : Colors.indigo,
                                ),
                                _buildManagerDetailItem(
                                  Icons.language,
                                  'Languages',
                                  managerInfo['languages']!,
                                  isDay ? Colors.orange : Colors.indigo,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Room Info Summary
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Room: ${room.title}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Price: \$${room.price}/${room.priceType.replaceAll('per_', '')}',
                            ),
                            Text('Shift: ${shift.toUpperCase()}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Contact Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showContactConfirmation(
                              context,
                              room,
                              managerInfo,
                              shift,
                            );
                          },
                          icon: const Icon(Icons.contact_phone),
                          label: const Text('Contact for Booking'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDay
                                ? Colors.orange
                                : Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Back Button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showRoomDetails(room);
                        },
                        child: const Text('Back to Room Details'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildManagerDetailItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactConfirmation(
    BuildContext context,
    Room room,
    Map<String, String> managerInfo,
    String shift,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You are about to contact the manager for booking:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Room: ${room.title}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Shift: ${shift.toUpperCase()}'),
                    Text('Manager: ${managerInfo['name']}'),
                    Text('Phone: ${managerInfo['phone']}'),
                    Text('Email: ${managerInfo['email']}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'The manager will assist you with the booking process and answer any questions about the room.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Contact information saved! You can now call or email ${managerInfo['name']} for booking.',
                    ),
                    duration: const Duration(seconds: 4),
                  ),
                );
              },
              child: const Text('Confirm Contact'),
            ),
          ],
        );
      },
    );
  }
}
