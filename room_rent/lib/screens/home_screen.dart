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

enum CategoryType { room, vehicle, traditionalFood, elementalGood }

class SubCategoryData {
  final String name;
  final String type;
  final List<dynamic> items;
  final String imagePath;

  SubCategoryData({
    required this.name,
    required this.type,
    required this.items,
    required this.imagePath,
  });
}

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

    // Load initial data and create sample rooms if none exist
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final roomProvider = context.read<FirebaseRoomProvider>();
      final vehicleProvider = context.read<FirebaseVehicleProvider>();
      final foodProvider = context.read<FirebaseTraditionalFoodProvider>();
      final goodProvider = context.read<FirebaseElementalGoodProvider>();

      // Load existing data
      await roomProvider.loadRooms();
      await vehicleProvider.loadVehicles();
      await foodProvider.loadTraditionalFoods();
      await goodProvider.loadElementalGoods();

      // Add sample rooms if none exist
      if (roomProvider.rooms.isEmpty) {
        await roomProvider.addSampleRoom();
        await roomProvider.loadRooms(); // Refresh to show the new data
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
                                // Room Categories
                                _buildMainCategoryContainer(
                                  'Rooms',
                                  Icons.hotel,
                                  Colors.lightBlueAccent,
                                  'Comfortable accommodation for your stay',
                                  [
                                    _buildSubCategoryData(
                                      'AC Rooms',
                                      'air_conditioning',
                                      roomProvider.rooms
                                          .where(
                                            (r) => r.amenities.contains(
                                              'Air Conditioning',
                                            ),
                                          )
                                          .toList(),
                                      'assets/images/ac room.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Non-AC Rooms',
                                      'natural_ventilation',
                                      roomProvider.rooms
                                          .where(
                                            (r) => !r.amenities.contains(
                                              'Air Conditioning',
                                            ),
                                          )
                                          .toList(),
                                      'assets/images/non-ac room.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Conference Hall',
                                      'conference_hall',
                                      roomProvider.rooms
                                          .where(
                                            (r) =>
                                                r.propertyType ==
                                                'conference_hall',
                                          )
                                          .toList(),
                                      'assets/images/confrence hall.jpg',
                                    ),
                                  ],
                                  CategoryType.room,
                                ),
                                const SizedBox(height: 20),

                                // Vehicle Categories
                                _buildMainCategoryContainer(
                                  'Vehicles',
                                  Icons.directions_car,
                                  Colors.orangeAccent,
                                  'Reliable transportation for your journey',
                                  [
                                    _buildSubCategoryData(
                                      'Motor Cycle',
                                      'motorcycle',
                                      vehicleProvider.getVehiclesByType(
                                        'motorcycle',
                                      ),
                                      'assets/images/motorcycle.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Three Wheeler',
                                      'three_wheel',
                                      vehicleProvider.getVehiclesByType(
                                        'three_wheel',
                                      ),
                                      'assets/images/three_wheel.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Car',
                                      'car',
                                      vehicleProvider.getVehiclesByType('car'),
                                      'assets/images/car.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Van',
                                      'van',
                                      vehicleProvider.getVehiclesByType('van'),
                                      'assets/images/van.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Lorry',
                                      'lorry',
                                      vehicleProvider.getVehiclesByType(
                                        'lorry',
                                      ),
                                      'assets/images/lorry.jpg',
                                    ),
                                  ],
                                  CategoryType.vehicle,
                                ),
                                const SizedBox(height: 20),

                                // Traditional Foods Categories
                                _buildMainCategoryContainer(
                                  'Traditional Foods',
                                  Icons.restaurant,
                                  Colors.greenAccent,
                                  'Authentic Sri Lankan cuisine',
                                  [
                                    _buildSubCategoryData(
                                      'String Hoppers',
                                      'string_hoppers',
                                      foodProvider.getFoodsByType(
                                        'string_hoppers',
                                      ),
                                      'assets/images/string_hoppers.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Milk Hoppers',
                                      'milk_hoppers',
                                      foodProvider.getFoodsByType(
                                        'milk_hoppers',
                                      ),
                                      'assets/images/milk_hoppers.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Puttu',
                                      'puttu',
                                      foodProvider.getFoodsByType('puttu'),
                                      'assets/images/puttu.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Rice & Curry',
                                      'rice_and_curry',
                                      foodProvider.getRiceAndCurryVarieties(),
                                      'assets/images/rice_curry.jpg',
                                    ),
                                  ],
                                  CategoryType.traditionalFood,
                                ),
                                const SizedBox(height: 20),

                                // Elemental Goods Categories
                                _buildMainCategoryContainer(
                                  'Elemental Goods',
                                  Icons.kitchen,
                                  Colors.purpleAccent,
                                  'Essential items for your convenience',
                                  [
                                    _buildSubCategoryData(
                                      'Iron',
                                      'iron',
                                      goodProvider.getGoodsByType('iron'),
                                      'assets/images/iron.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Kettle',
                                      'kettle',
                                      goodProvider.getGoodsByType('kettle'),
                                      'assets/images/kettle.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Rice Cooker',
                                      'rice_cooker',
                                      goodProvider.getGoodsByType(
                                        'rice_cooker',
                                      ),
                                      'assets/images/rice_cooker.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'BBQ Rack',
                                      'bbq_rack',
                                      goodProvider.getGoodsByType('bbq_rack'),
                                      'assets/images/bbq_rack.jpg',
                                    ),
                                    _buildSubCategoryData(
                                      'Gas Cooker',
                                      'gas_cooker_with_cylinder',
                                      goodProvider.getGoodsByType(
                                        'gas_cooker_with_cylinder',
                                      ),
                                      'assets/images/gas_cooker.jpg',
                                    ),
                                  ],
                                  CategoryType.elementalGood,
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

  SubCategoryData _buildSubCategoryData(
    String name,
    String type,
    List<dynamic> items,
    String imagePath,
  ) {
    return SubCategoryData(
      name: name,
      type: type,
      items: items.where((item) => item.isAvailable).toList(),
      imagePath: imagePath,
    );
  }

  Widget _buildMainCategoryContainer(
    String title,
    IconData icon,
    Color accentColor,
    String description,
    List<SubCategoryData> subCategories,
    CategoryType categoryType,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Category Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withOpacity(0.15),
                  accentColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.3),
                        accentColor.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accentColor.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${subCategories.fold<int>(0, (sum, category) => sum + category.items.length)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sub-categories
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  final subCategory = subCategories[index];
                  return _buildSubCategoryCard(
                    subCategory,
                    accentColor,
                    categoryType,
                    index < subCategories.length - 1,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryCard(
    SubCategoryData subCategory,
    Color accentColor,
    CategoryType categoryType,
    bool hasMargin,
  ) {
    return Container(
      width: 320,
      margin: EdgeInsets.only(right: hasMargin ? 20 : 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showSubCategoryDetails(subCategory, categoryType),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: AssetImage(subCategory.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            subCategory.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withOpacity(0.3),
                                accentColor.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${subCategory.items.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Availability Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: subCategory.items.isNotEmpty
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        subCategory.items.isNotEmpty
                            ? 'Available'
                            : 'Not Available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubCategoryDetails(
    SubCategoryData subCategory,
    CategoryType categoryType,
  ) {
    if (subCategory.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppQuotes.getRandomMotivationalQuote()}\n\nNo ${subCategory.name.toLowerCase()} available at the moment',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show a selection dialog if there are multiple items
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Select ${subCategory.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: subCategory.items.length,
                itemBuilder: (context, index) {
                  final item = subCategory.items[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      _getItemTitle(item, categoryType),
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _getItemSubtitle(item, categoryType),
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showItemDetails(item, categoryType);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getItemTitle(dynamic item, CategoryType categoryType) {
    switch (categoryType) {
      case CategoryType.room:
        return (item as Room).title;
      case CategoryType.vehicle:
        return (item as Vehicle).title;
      case CategoryType.traditionalFood:
        return (item as TraditionalFood).title;
      case CategoryType.elementalGood:
        return (item as ElementalGood).title;
    }
  }

  String _getItemSubtitle(dynamic item, CategoryType categoryType) {
    switch (categoryType) {
      case CategoryType.room:
        final room = item as Room;
        return 'Rs ${room.price.toStringAsFixed(0)}/${room.priceType.replaceAll('per_', '')}';
      case CategoryType.vehicle:
        final vehicle = item as Vehicle;
        return 'Rs ${vehicle.price.toStringAsFixed(0)}/${vehicle.priceType.replaceAll('per_', '')}';
      case CategoryType.traditionalFood:
        final food = item as TraditionalFood;
        return 'Rs ${food.price.toStringAsFixed(0)}/${food.priceType.replaceAll('per_', '')}';
      case CategoryType.elementalGood:
        final good = item as ElementalGood;
        return 'Rs ${good.price.toStringAsFixed(0)}/${good.priceType.replaceAll('per_', '')}';
    }
  }

  void _showItemDetails(dynamic item, CategoryType categoryType) {
    switch (categoryType) {
      case CategoryType.room:
        showDialog(
          context: context,
          builder: (context) => RoomDetailsDialog(room: item as Room),
        );
        break;
      case CategoryType.vehicle:
        showDialog(
          context: context,
          builder: (context) => VehicleDetailsDialog(vehicle: item as Vehicle),
        );
        break;
      case CategoryType.traditionalFood:
        showDialog(
          context: context,
          builder: (context) =>
              TraditionalFoodDetailsDialog(food: item as TraditionalFood),
        );
        break;
      case CategoryType.elementalGood:
        showDialog(
          context: context,
          builder: (context) =>
              ElementalGoodDetailsDialog(good: item as ElementalGood),
        );
        break;
    }
  }
}
