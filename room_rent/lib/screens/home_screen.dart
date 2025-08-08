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
import '../widgets/glowing_icon_system.dart';
import '../utils/app_quotes.dart';
import 'dart:ui';

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
              // Room Icon
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isAcRoom
                        ? [
                            const Color(0xFF00BCD4).withOpacity(0.8),
                            const Color(0xFF0097A7).withOpacity(0.9),
                            const Color(0xFF006064),
                          ]
                        : [
                            const Color(0xFFFF9800).withOpacity(0.8),
                            const Color(0xFFE65100).withOpacity(0.9),
                            const Color(0xFFBF360C),
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isAcRoom
                                  ? const Color(0xFF00BCD4)
                                  : const Color(0xFFFF9800))
                              .withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Center(
                      child: GlowingIcon(
                        icon: isAcRoom
                            ? Icons.ac_unit_rounded
                            : Icons.bed_rounded,
                        size: 64,
                        primaryColor: Colors.white,
                        glowColor: isAcRoom
                            ? const Color(0xFF00BCD4)
                            : const Color(0xFFFF9800),
                        glowRadius: 20,
                        animate: isAcRoom,
                        backgroundRadius: 40,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
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
              // Vehicle Icon
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getVehicleGradientColors(vehicle.vehicleType),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getVehicleGlowColor(
                        vehicle.vehicleType,
                      ).withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Center(
                      child: GlowingIcon(
                        icon: _getVehicleIcon(vehicle.vehicleType),
                        size: 64,
                        primaryColor: Colors.white,
                        glowColor: _getVehicleGlowColor(vehicle.vehicleType),
                        glowRadius: 20,
                        animate: vehicle.vehicleType.toLowerCase() == 'bike',
                        showPulse: vehicle.vehicleType.toLowerCase() == 'lorry',
                        backgroundRadius: 40,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
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
              // Food Icon
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getFoodGradientColors(food.foodType),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getFoodGlowColor(food.foodType).withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Center(
                      child: GlowingIcon(
                        icon: _getFoodIcon(food.foodType),
                        size: 64,
                        primaryColor: Colors.white,
                        glowColor: _getFoodGlowColor(food.foodType),
                        glowRadius: 20,
                        animate:
                            food.foodType.toLowerCase() == 'string_hoppers',
                        showPulse:
                            food.foodType.toLowerCase() == 'rice_and_curry',
                        backgroundRadius: 40,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
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
              // Good Icon
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getGoodGradientColors(good.goodType),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getGoodGlowColor(good.goodType).withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Center(
                      child: GlowingIcon(
                        icon: _getGoodIcon(good.goodType),
                        size: 64,
                        primaryColor: Colors.white,
                        glowColor: _getGoodGlowColor(good.goodType),
                        glowRadius: 20,
                        animate: good.goodType.toLowerCase() == 'rice_cooker',
                        showPulse: good.goodType.toLowerCase() == 'gas_cooker',
                        backgroundRadius: 40,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
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

  // Helper methods for vehicle icons and colors
  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'bike':
      case 'motorcycle':
        return Icons.two_wheeler_rounded;
      case 'car':
        return Icons.directions_car_rounded;
      case 'van':
        return Icons.airport_shuttle_rounded;
      case 'lorry':
        return Icons.local_shipping_rounded;
      case 'three_wheel':
        return Icons.electric_rickshaw_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }

  Color _getVehicleGlowColor(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'bike':
      case 'motorcycle':
        return const Color(0xFF4CAF50);
      case 'car':
        return const Color(0xFF2196F3);
      case 'van':
        return const Color(0xFF3F51B5);
      case 'lorry':
        return const Color(0xFFF44336);
      case 'three_wheel':
        return const Color(0xFFFFEB3B);
      default:
        return const Color(0xFF2196F3);
    }
  }

  List<Color> _getVehicleGradientColors(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'bike':
      case 'motorcycle':
        return [
          const Color(0xFF4CAF50).withOpacity(0.8),
          const Color(0xFF388E3C).withOpacity(0.9),
          const Color(0xFF1B5E20),
        ];
      case 'car':
        return [
          const Color(0xFF2196F3).withOpacity(0.8),
          const Color(0xFF1976D2).withOpacity(0.9),
          const Color(0xFF0D47A1),
        ];
      case 'van':
        return [
          const Color(0xFF3F51B5).withOpacity(0.8),
          const Color(0xFF303F9F).withOpacity(0.9),
          const Color(0xFF1A237E),
        ];
      case 'lorry':
        return [
          const Color(0xFFF44336).withOpacity(0.8),
          const Color(0xFFD32F2F).withOpacity(0.9),
          const Color(0xFFB71C1C),
        ];
      case 'three_wheel':
        return [
          const Color(0xFFFFEB3B).withOpacity(0.8),
          const Color(0xFFFBC02D).withOpacity(0.9),
          const Color(0xFFE65100),
        ];
      default:
        return [
          const Color(0xFF2196F3).withOpacity(0.8),
          const Color(0xFF1976D2).withOpacity(0.9),
          const Color(0xFF0D47A1),
        ];
    }
  }

  // Helper methods for food icons and colors
  IconData _getFoodIcon(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'string_hoppers':
        return Icons.soup_kitchen_rounded; // More authentic for string hoppers
      case 'milk_hoppers':
        return Icons.breakfast_dining_rounded; // Better for milk hoppers  
      case 'puttu':
        return Icons.grain_rounded; // More authentic for puttu (grain/rice based)
      case 'rice_and_curry':
        return Icons.rice_bowl_rounded; // Perfect for rice and curry
      default:
        return Icons.restaurant_rounded;
    }
  }

  Color _getFoodGlowColor(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'string_hoppers':
        return const Color(0xFF8D6E63);
      case 'milk_hoppers':
        return const Color(0xFFE91E63);
      case 'puttu':
        return const Color(0xFFFF5722);
      case 'rice_and_curry':
        return const Color(0xFFFFC107);
      default:
        return const Color(0xFFFF9800);
    }
  }

  List<Color> _getFoodGradientColors(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'string_hoppers':
        return [
          const Color(0xFF8D6E63).withOpacity(0.8),
          const Color(0xFF5D4037).withOpacity(0.9),
          const Color(0xFF3E2723),
        ];
      case 'milk_hoppers':
        return [
          const Color(0xFFE91E63).withOpacity(0.8),
          const Color(0xFFC2185B).withOpacity(0.9),
          const Color(0xFF880E4F),
        ];
      case 'puttu':
        return [
          const Color(0xFFFF5722).withOpacity(0.8),
          const Color(0xFFE64A19).withOpacity(0.9),
          const Color(0xFFBF360C),
        ];
      case 'rice_and_curry':
        return [
          const Color(0xFFFFC107).withOpacity(0.8),
          const Color(0xFFFF8F00).withOpacity(0.9),
          const Color(0xFFE65100),
        ];
      default:
        return [
          const Color(0xFFFF9800).withOpacity(0.8),
          const Color(0xFFE65100).withOpacity(0.9),
          const Color(0xFFBF360C),
        ];
    }
  }

  // Helper methods for goods icons and colors
  IconData _getGoodIcon(String goodType) {
    switch (goodType.toLowerCase()) {
      case 'iron':
        return Icons.iron_rounded;
      case 'kettle':
        return Icons.coffee_maker_rounded;
      case 'rice_cooker':
        return Icons.kitchen_rounded;
      case 'bbq_rack':
        return Icons.outdoor_grill_rounded;
      case 'gas_cooker_with_cylinder':
      case 'gas_cooker':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  Color _getGoodGlowColor(String goodType) {
    switch (goodType.toLowerCase()) {
      case 'iron':
        return const Color(0xFF9E9E9E);
      case 'kettle':
        return const Color(0xFF607D8B);
      case 'rice_cooker':
        return const Color(0xFF009688);
      case 'bbq_rack':
        return const Color(0xFF673AB7);
      case 'gas_cooker_with_cylinder':
      case 'gas_cooker':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9C27B0);
    }
  }

  List<Color> _getGoodGradientColors(String goodType) {
    switch (goodType.toLowerCase()) {
      case 'iron':
        return [
          const Color(0xFF9E9E9E).withOpacity(0.8),
          const Color(0xFF616161).withOpacity(0.9),
          const Color(0xFF212121),
        ];
      case 'kettle':
        return [
          const Color(0xFF607D8B).withOpacity(0.8),
          const Color(0xFF455A64).withOpacity(0.9),
          const Color(0xFF263238),
        ];
      case 'rice_cooker':
        return [
          const Color(0xFF009688).withOpacity(0.8),
          const Color(0xFF00695C).withOpacity(0.9),
          const Color(0xFF004D40),
        ];
      case 'bbq_rack':
        return [
          const Color(0xFF673AB7).withOpacity(0.8),
          const Color(0xFF512DA8).withOpacity(0.9),
          const Color(0xFF311B92),
        ];
      case 'gas_cooker_with_cylinder':
      case 'gas_cooker':
        return [
          const Color(0xFFF44336).withOpacity(0.8),
          const Color(0xFFD32F2F).withOpacity(0.9),
          const Color(0xFFB71C1C),
        ];
      default:
        return [
          const Color(0xFF9C27B0).withOpacity(0.8),
          const Color(0xFF7B1FA2).withOpacity(0.9),
          const Color(0xFF4A148C),
        ];
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
