import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animated_background/animated_background.dart';
import '../providers/app_providers.dart';
import '../models/guest_house_manager.dart';
import '../services/data_service.dart';
import '../widgets/glass_widgets.dart';
import '../widgets/room_card.dart';
import 'manager_contact_screen.dart';

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
                    Row(
                      children: [
                        Expanded(
                          child: GlassCard(
                            margin: const EdgeInsets.only(right: 8),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.hotel,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Consumer<RoomProvider>(
                                  builder: (context, provider, child) {
                                    final availableRooms = provider.rooms
                                        .where((room) => room.isAvailable)
                                        .length;
                                    return Text(
                                      '$availableRooms',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                const Text(
                                  'Available Rooms',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (manager != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ManagerContactScreen(manager: manager!),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Loading manager details...'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                            child: GlassCard(
                              margin: const EdgeInsets.only(left: 8),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.contact_phone,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Contact',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    'Manager',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Available Rooms',
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

                          return ListView.builder(
                            itemCount: availableRooms.length,
                            itemBuilder: (context, index) {
                              final room = availableRooms[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: RoomCard(
                                  room: room,
                                  onTap: () {
                                    // Show room details in a dialog or simply show room info
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(room.title),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Price: \$${room.price}/${room.priceType}',
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Location: ${room.location}',
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Description: ${room.description}',
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('Close'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                if (manager != null) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ManagerContactScreen(
                                                            manager: manager!,
                                                            roomId: room.id,
                                                            roomTitle:
                                                                room.title,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Contact for Booking',
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
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
}
