import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/manager_contact_screen.dart';
import 'models/room.dart';
import 'models/guest_house_manager.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _listController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _listAnimation;

  List<Room> availableRooms = [];
  bool showRooms = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _listAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _listController, curve: Curves.easeOutBack));

    _startLaunchSequence();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _listController.dispose();
    super.dispose();
  }

  void _startLaunchSequence() async {
    _fadeController.forward();
    _scaleController.forward();

    // Load room data
    await _loadRoomData();

    // Wait for animation to complete and then show rooms
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        showRooms = true;
        isLoading = false;
      });
      _listController.forward();
    }
  }

  Future<void> _loadRoomData() async {
    try {
      final String response = await rootBundle.loadString('assets/sample_data/rooms.json');
      final List<dynamic> data = json.decode(response);
      
      setState(() {
        availableRooms = data.map((json) => Room.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error loading room data: $e');
    }
  }

  void _navigateToManagerContact(Room room) {
    // Convert RoomInCharge to GuestHouseManager
    final manager = GuestHouseManager(
      id: room.inCharge.id,
      name: room.inCharge.name,
      position: 'Property Manager',
      email: room.inCharge.email,
      phone: room.inCharge.phone,
      avatar: 'assets/images/user.jpg',
      bio: room.inCharge.bio ?? 'Experienced property manager',
      guestHouseName: 'Village Guest House',
      village: 'Village',
      district: 'District',
      state: 'State',
      yearsOfExperience: 5,
      languages: room.inCharge.languages,
      specialties: ['Property Management', 'Guest Services'],
      isAvailable: true,
      rating: room.inCharge.rating,
      totalGuests: room.inCharge.totalReviews,
      certificates: [],
      reviews: [],
      joinedDate: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManagerContactScreen(
          manager: manager,
          roomId: room.id,
          roomTitle: room.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF667eea),
            ],
          ),
        ),
        child: SafeArea(
          child: !showRooms ? _buildLaunchContent() : _buildRoomsContent(),
        ),
      ),
    );
  }

  Widget _buildLaunchContent() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home_work_rounded,
                  size: 70,
                  color: Color(0xFF667eea),
                ),
              ),

              const SizedBox(height: 40),

              // App Name
              const Text(
                'Village Guest House',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Tagline
              const Text(
                'Comfortable • Authentic • Welcoming',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 60),

              // Loading indicator
              if (isLoading) ...[
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),

                const SizedBox(height: 20),

                // Loading text
                const Text(
                  'Loading available rooms...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white60,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomsContent() {
    return SlideTransition(
      position: _listAnimation,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.home_work_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Village Guest House',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Available Rooms',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.dashboard,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Rooms List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: availableRooms.length,
              itemBuilder: (context, index) {
                final room = availableRooms[index];
                return _buildRoomCard(room, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Room room, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _navigateToManagerContact(room),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Room Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/room.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Room Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        room.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.bed,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${room.bedrooms} bed',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.bathroom,
                            size: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${room.bathrooms} bath',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${room.price.toStringAsFixed(0)}/${room.priceType.split('_').last}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                room.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Contact Button
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.contact_phone,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
