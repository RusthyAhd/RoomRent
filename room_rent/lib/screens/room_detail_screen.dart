import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/room.dart';
import '../models/guest_house_manager.dart';
import '../providers/app_providers.dart';
import '../widgets/glass_widgets.dart';
import 'manager_contact_screen.dart';

class RoomDetailScreen extends StatefulWidget {
  final String roomId;

  const RoomDetailScreen({super.key, required this.roomId});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) {
        final room = roomProvider.getRoomById(widget.roomId);

        if (room == null) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B5E20),
                  Color(0xFF2E7D32),
                  Color(0xFF388E3C),
                  Color(0xFF4CAF50),
                ],
              ),
            ),
            child: CustomScrollView(
              slivers: [
                // App Bar with Image Gallery
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        // Add to favorites functionality
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildImageGallery(room),
                  ),
                ),

                // Room Details Content
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildRoomContent(room),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Contact Button
          bottomNavigationBar: _buildContactBottomBar(room),
        );
      },
    );
  }

  Widget _buildImageGallery(Room room) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemCount: room.images.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(room.images[index]),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
              ),
            );
          },
        ),

        // Image indicators
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              room.images.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),

        // Room availability badge
        Positioned(
          top: 60,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: room.isAvailable ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              room.isAvailable ? 'Available' : 'Occupied',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomContent(Room room) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Basic Info
          _buildRoomHeader(room),

          const SizedBox(height: 20),

          // Room Stats
          _buildRoomStats(room),

          const SizedBox(height: 20),

          // Description
          _buildDescription(room),

          const SizedBox(height: 20),

          // Amenities
          _buildAmenities(room),

          const SizedBox(height: 20),

          // Manager Info
          _buildManagerInfo(room),

          const SizedBox(height: 20),

          // Reviews
          _buildReviews(room),

          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildRoomHeader(Room room) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: 20,
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
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    room.location,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${room.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      room.priceType.replaceAll('_', ' '),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${room.rating}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      ' (${room.reviews.length})',
                      style: const TextStyle(
                        fontSize: 14,
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
    );
  }

  Widget _buildRoomStats(Room room) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: 15,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(Icons.bed, '${room.bedrooms}', 'Bedrooms'),
            _buildStatItem(Icons.bathroom, '${room.bathrooms}', 'Bathrooms'),
            _buildStatItem(Icons.square_foot, '${room.area}m²', 'Area'),
            _buildStatItem(Icons.home_work, room.propertyType, 'Type'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white60),
        ),
      ],
    );
  }

  Widget _buildDescription(Room room) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: 15,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              room.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenities(Room room) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: 15,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Amenities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: room.amenities
                  .map(
                    (amenity) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        amenity,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagerInfo(Room room) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: 15,
      child: InkWell(
        onTap: () {
          // Convert RoomInCharge to GuestHouseManager for compatibility
          final manager = _convertToGuestHouseManager(room.inCharge);
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
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Manager Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: room.inCharge.avatar != null
                      ? Image.asset(
                          room.inCharge.avatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildDefaultManagerAvatar(),
                        )
                      : _buildDefaultManagerAvatar(),
                ),
              ),

              const SizedBox(width: 16),

              // Manager Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.inCharge.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      room.inCharge.role.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${room.inCharge.rating} (${room.inCharge.totalReviews} reviews)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
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
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.contact_phone,
                  color: Colors.green,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultManagerAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.teal.shade400],
        ),
      ),
      child: const Icon(Icons.person, size: 30, color: Colors.white),
    );
  }

  Widget _buildReviews(Room room) {
    if (room.reviews.isEmpty) return const SizedBox.shrink();

    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: 15,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Guest Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            ...room.reviews
                .take(2)
                .map(
                  (review) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  color: index < review.rating
                                      ? Colors.amber
                                      : Colors.white30,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                review.userName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review.comment,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),

            if (room.reviews.length > 2)
              Center(
                child: TextButton(
                  onPressed: () {
                    // Show all reviews
                  },
                  child: const Text(
                    'View All Reviews',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactBottomBar(Room room) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                final manager = _convertToGuestHouseManager(room.inCharge);
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
              },
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text(
                'Contact Manager',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // Add to favorites
              },
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to convert RoomInCharge to GuestHouseManager
  GuestHouseManager _convertToGuestHouseManager(RoomInCharge inCharge) {
    return GuestHouseManager(
      id: inCharge.id,
      name: inCharge.name,
      position: 'Guest House Manager',
      email: inCharge.email,
      phone: inCharge.phone,
      whatsapp: inCharge.phone,
      avatar: inCharge.avatar,
      bio:
          inCharge.bio ??
          'Experienced guest house manager dedicated to providing excellent service to all guests.',
      guestHouseName: 'Village Heritage Guest House',
      village: 'Harmony Village',
      district: 'Green Valley',
      state: 'Kerala',
      yearsOfExperience: 15,
      languages: inCharge.languages,
      specialties: [
        'Guest Relations',
        'Local Tours',
        'Traditional Hospitality',
      ],
      isAvailable: true,
      rating: inCharge.rating,
      totalGuests: inCharge.totalReviews * 10,
      certificates: ['Hospitality Management'],
      reviews: [],
      joinedDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
    );
  }
}
