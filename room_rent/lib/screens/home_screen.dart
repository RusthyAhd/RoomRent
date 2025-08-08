import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animated_background/animated_background.dart';
import '../providers/firebase_room_provider.dart';
import '../providers/firebase_vehicle_provider.dart';
import '../providers/firebase_traditional_food_provider.dart';
import '../providers/firebase_elemental_good_provider.dart';
import '../models/room.dart';
import '../models/vehicle.dart';
import '../models/traditional_food.dart';
import '../models/elemental_good.dart';
import '../widgets/dialogs/room_details_dialog.dart';
import '../widgets/dialogs/vehicle_details_dialog.dart';
import '../widgets/dialogs/traditional_food_details_dialog.dart';
import '../widgets/dialogs/elemental_good_details_dialog.dart';
import '../utils/app_quotes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

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

    // Initialize real-time streams and load sample data if needed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final roomProvider = context.read<FirebaseRoomProvider>();
      final vehicleProvider = context.read<FirebaseVehicleProvider>();
      final foodProvider = context.read<FirebaseTraditionalFoodProvider>();
      final goodProvider = context.read<FirebaseElementalGoodProvider>();

      // Initialize real-time streams for all categories
      roomProvider.initializeRoomsStream();
      vehicleProvider.initializeVehiclesStream();
      foodProvider.initializeFoodsStream();
      goodProvider.initializeGoodsStream();

      // Wait a bit for initial data to load
      await Future.delayed(const Duration(milliseconds: 1000));

      // Add sample data if collections are empty
      if (roomProvider.rooms.isEmpty) {
        await roomProvider.addSampleRoom();
      }
      if (vehicleProvider.vehicles.isEmpty) {
        await vehicleProvider.addSampleVehicles();
      }
      if (foodProvider.foods.isEmpty) {
        await foodProvider.addSampleFoods();
      }
      if (goodProvider.goods.isEmpty) {
        await goodProvider.addSampleGoods();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Shimmer.fromColors(
                                baseColor: Colors.white70,
                                highlightColor: Colors.white,
                                child: const Text(
                                  'Pegas Rental Hub',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            AppQuotes.getRandomRentalQuote(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.white, Colors.white70],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Service Categories',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Content Area
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: MultiProvider(
                        providers: [
                          ChangeNotifierProvider.value(
                            value: context.watch<FirebaseRoomProvider>(),
                          ),
                          ChangeNotifierProvider.value(
                            value: context.watch<FirebaseVehicleProvider>(),
                          ),
                          ChangeNotifierProvider.value(
                            value: context
                                .watch<FirebaseTraditionalFoodProvider>(),
                          ),
                          ChangeNotifierProvider.value(
                            value: context
                                .watch<FirebaseElementalGoodProvider>(),
                          ),
                        ],
                        builder: (context, child) {
                          final roomProvider = context
                              .watch<FirebaseRoomProvider>();
                          final vehicleProvider = context
                              .watch<FirebaseVehicleProvider>();
                          final foodProvider = context
                              .watch<FirebaseTraditionalFoodProvider>();
                          final goodProvider = context
                              .watch<FirebaseElementalGoodProvider>();

                          if (roomProvider.isLoading ||
                              vehicleProvider.isLoading ||
                              foodProvider.isLoading ||
                              goodProvider.isLoading) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                // Individual Room Cards Section
                                _buildRoomSection(
                                  'Rooms',
                                  Icons.hotel,
                                  roomProvider.rooms,
                                ),
                                const SizedBox(height: 20),

                                // Vehicle Categories
                                _buildVehicleSection(
                                  'Vehicles',
                                  Icons.directions_car,
                                  vehicleProvider.vehicles,
                                ),
                                const SizedBox(height: 20),

                                // Traditional Foods Categories
                                _buildFoodSection(
                                  'Traditional Foods',
                                  Icons.restaurant,
                                  foodProvider.foods,
                                ),
                                const SizedBox(height: 20),

                                // Elemental Goods Categories
                                _buildGoodsSection(
                                  'Elemental Goods',
                                  Icons.kitchen,
                                  goodProvider.goods,
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // New simplified room section
  Widget _buildRoomSection(String title, IconData icon, List<Room> rooms) {
    if (rooms.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.white70),
            const SizedBox(height: 16),
            const Text(
              'No rooms available at the moment',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Individual Room Cards
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return _buildIndividualRoomCard(room, index < rooms.length - 1);
            },
          ),
        ),
      ],
    );
  }

  // Individual room card that directly opens room details
  Widget _buildIndividualRoomCard(Room room, bool hasMargin) {
    final isAcRoom = room.amenities.contains('Air Conditioning');
    final accentColor = isAcRoom ? Colors.lightBlueAccent : Colors.greenAccent;

    return Container(
      width: 280,
      margin: EdgeInsets.only(right: hasMargin ? 20 : 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showRoomDetails(room),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Image
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      room.images.isNotEmpty
                          ? room.images.first
                          : (isAcRoom
                                ? 'assets/images/ac room.jpg'
                                : 'assets/images/non-ac room.jpg'),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(), // Empty container instead of badges
                  ),
                ),
              ),

              // Room Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Room Title
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
                      const SizedBox(height: 8),

                      // Price
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: accentColor,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rs ${room.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                          Text(
                            '/${room.priceType.replaceAll('per_', '')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Key Amenities
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${room.bedrooms} Bed • ${room.bathrooms} Bath',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              room.location,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Direct method to show room details
  void _showRoomDetails(Room room) {
    showDialog(
      context: context,
      builder: (context) => RoomDetailsDialog(room: room),
    );
  }

  // Simplified vehicle section
  Widget _buildVehicleSection(
    String title,
    IconData icon,
    List<Vehicle> vehicles,
  ) {
    if (vehicles.isEmpty) {
      return _buildEmptySection(title, icon, 'No vehicles available');
    }

    return _buildGenericSection<Vehicle>(
      title: title,
      icon: icon,
      items: vehicles,
      cardBuilder: (vehicle, hasMargin) =>
          _buildVehicleCard(vehicle, hasMargin),
    );
  }

  // Simplified food section
  Widget _buildFoodSection(
    String title,
    IconData icon,
    List<TraditionalFood> foods,
  ) {
    if (foods.isEmpty) {
      return _buildEmptySection(title, icon, 'No food items available');
    }

    return _buildGenericSection<TraditionalFood>(
      title: title,
      icon: icon,
      items: foods,
      cardBuilder: (food, hasMargin) => _buildFoodCard(food, hasMargin),
    );
  }

  // Simplified goods section
  Widget _buildGoodsSection(
    String title,
    IconData icon,
    List<ElementalGood> goods,
  ) {
    if (goods.isEmpty) {
      return _buildEmptySection(title, icon, 'No goods available');
    }

    return _buildGenericSection<ElementalGood>(
      title: title,
      icon: icon,
      items: goods,
      cardBuilder: (good, hasMargin) => _buildGoodCard(good, hasMargin),
    );
  }

  // Generic section builder
  Widget _buildGenericSection<T>({
    required String title,
    required IconData icon,
    required List<T> items,
    required Widget Function(T item, bool hasMargin) cardBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Items
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return cardBuilder(items[index], index < items.length - 1);
            },
          ),
        ),
      ],
    );
  }

  // Empty section widget
  Widget _buildEmptySection(String title, IconData icon, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.white70),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Individual vehicle card
  Widget _buildVehicleCard(Vehicle vehicle, bool hasMargin) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: hasMargin ? 20 : 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.orangeAccent.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showVehicleDetails(vehicle),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Image
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      vehicle.images.isNotEmpty
                          ? vehicle.images.first
                          : _getVehicleDefaultImage(vehicle.vehicleType),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(), // Empty container instead of badges
                  ),
                ),
              ),

              // Vehicle Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.orangeAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rs ${vehicle.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          Text(
                            '/${vehicle.priceType.replaceAll('per_', '')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Individual food card
  Widget _buildFoodCard(TraditionalFood food, bool hasMargin) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: hasMargin ? 20 : 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.greenAccent.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showFoodDetails(food),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Image
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      food.images.isNotEmpty
                          ? food.images.first
                          : _getFoodDefaultImage(food.foodType),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(), // Empty container instead of badges
                  ),
                ),
              ),

              // Food Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.greenAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rs ${food.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            ),
                          ),
                          Text(
                            '/${food.priceType.replaceAll('per_', '')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Individual good card
  Widget _buildGoodCard(ElementalGood good, bool hasMargin) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: hasMargin ? 20 : 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.purpleAccent.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showGoodDetails(good),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Good Image
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      good.images.isNotEmpty
                          ? good.images.first
                          : _getGoodDefaultImage(good.goodType),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(), // Empty container instead of badges
                  ),
                ),
              ),

              // Good Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        good.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.purpleAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rs ${good.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purpleAccent,
                            ),
                          ),
                          Text(
                            '/${good.priceType.replaceAll('per_', '')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods for default images
  String _getVehicleDefaultImage(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'motorcycle':
        return 'assets/images/motorcycle.jpg';
      case 'car':
        return 'assets/images/car.jpg';
      case 'lorry':
        return 'assets/images/lorry.jpg';
      default:
        return 'assets/images/car.jpg';
    }
  }

  String _getFoodDefaultImage(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'string_hoppers':
        return 'assets/images/string_hoppers.jpg';
      case 'milk_hoppers':
        return 'assets/images/milk_hoppers.jpg';
      case 'puttu':
        return 'assets/images/puttu.jpg';
      case 'rice_and_curry':
        return 'assets/images/rice_curry.jpg';
      default:
        return 'assets/images/rice_curry.jpg';
    }
  }

  String _getGoodDefaultImage(String goodType) {
    switch (goodType.toLowerCase()) {
      case 'iron':
        return 'assets/images/iron.jpg';
      case 'kettle':
        return 'assets/images/kettle.jpg';
      case 'rice_cooker':
        return 'assets/images/rice_cooker.jpg';
      case 'bbq_rack':
        return 'assets/images/bbq_rack.jpg';
      case 'gas_cooker_with_cylinder':
        return 'assets/images/gas_cooker.jpg';
      default:
        return 'assets/images/kettle.jpg';
    }
  }

  // Detail showing methods
  void _showVehicleDetails(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => VehicleDetailsDialog(vehicle: vehicle),
    );
  }

  void _showFoodDetails(TraditionalFood food) {
    showDialog(
      context: context,
      builder: (context) => TraditionalFoodDetailsDialog(food: food),
    );
  }

  void _showGoodDetails(ElementalGood good) {
    showDialog(
      context: context,
      builder: (context) => ElementalGoodDetailsDialog(good: good),
    );
  }
}
