import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_categories.dart';
import '../providers/firebase_room_provider.dart';
import '../providers/vehicle_provider.dart';
import '../providers/traditional_food_provider.dart';
import '../providers/elemental_good_provider.dart';
import '../widgets/category_type_card.dart';
import 'admin_login_screen.dart';
import 'admin_panel_screen.dart';

class ComprehensiveHomeScreen extends StatefulWidget {
  const ComprehensiveHomeScreen({super.key});

  @override
  State<ComprehensiveHomeScreen> createState() =>
      _ComprehensiveHomeScreenState();
}

class _ComprehensiveHomeScreenState extends State<ComprehensiveHomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    // Load all data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FirebaseRoomProvider>().loadRooms();
      context.read<VehicleProvider>().loadVehicles();
      context.read<TraditionalFoodProvider>().loadFoods();
      context.read<ElementalGoodProvider>().loadGoods();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298), Color(0xFF6DD5ED)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCategoryView(AppCategories.rooms),
                      _buildCategoryView(AppCategories.vehicles),
                      _buildCategoryView(AppCategories.traditionalFoods),
                      _buildCategoryView(AppCategories.elementalGoods),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Pegas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Discover amazing rooms, vehicles, foods & goods',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Admin Access Button
              GestureDetector(
                onTap: _checkAdminAccess,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        indicator: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(20),
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        tabs: AppCategories.categories.entries.map((entry) {
          return Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(entry.value.title),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryView(String categoryId) {
    final category = AppCategories.categories[categoryId]!;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            category.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.description,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildTypeGrid(category)),
        ],
      ),
    );
  }

  Widget _buildTypeGrid(CategoryInfo category) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: category.types.length,
      itemBuilder: (context, index) {
        final typeInfo = category.types.values.elementAt(index);
        return CategoryTypeCard(typeInfo: typeInfo);
      },
    );
  }

  Future<void> _checkAdminAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_admin_logged_in') ?? false;
    final loginTime = prefs.getInt('admin_login_time') ?? 0;

    // Check if login is still valid (24 hours)
    final now = DateTime.now().millisecondsSinceEpoch;
    final isLoginValid = (now - loginTime) < (24 * 60 * 60 * 1000);

    if (isLoggedIn && isLoginValid) {
      // Already logged in, go to admin panel
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
        );
      }
    } else {
      // Need to login
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
        );
      }
    }
  }
}
