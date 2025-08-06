import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_providers.dart';
import '../models/room_models.dart';
import '../widgets/glassmorphism_container.dart';
import '../services/firebase_service.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  bool _isTestingConnection = false;
  String _connectionStatus = '';

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    setState(() {
      _isTestingConnection = true;
      _connectionStatus = 'Testing Firebase connection...';
    });

    try {
      bool isConnected = await FirebaseService.testConnection();
      setState(() {
        _connectionStatus = isConnected
            ? '✅ Firebase connected successfully!'
            : '❌ Firebase connection failed';
      });
    } catch (e) {
      setState(() {
        _connectionStatus = '❌ Firebase connection error: $e';
      });
    } finally {
      setState(() {
        _isTestingConnection = false;
      });
    }
  }

  Future<void> _addSampleRoom() async {
    final sampleRoom = RoomItem(
      id: '',
      title: 'Sample Room ${DateTime.now().millisecondsSinceEpoch}',
      description:
          'This is a beautiful room with stunning views. Perfect for a peaceful stay in our village guest house.',
      imageUrls: [
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        'https://images.unsplash.com/photo-1568495248636-6432b97bd949?w=800',
      ],
      panoramaUrls: [
        'https://images.unsplash.com/photo-1600121848594-d8644e57abab?w=1200',
      ],
      price: 75.00,
      contactPhone: '+1234567890',
      createdAt: DateTime.now(),
    );

    try {
      await context.read<RoomProvider>().addRoom(sampleRoom);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sample room added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add room: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Firebase Test'),
        actions: [
          IconButton(
            onPressed: _testFirebaseConnection,
            icon: const Icon(Icons.refresh),
            tooltip: 'Test Connection',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connection Status
                GlassmorphismContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Firebase Connection',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_isTestingConnection)
                          const Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Testing connection...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        else
                          Text(
                            _connectionStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Demo Actions
                GlassmorphismContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Demo Actions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _addSampleRoom,
                            icon: const Icon(Icons.home),
                            label: const Text('Add Sample Room'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Current Data
                Consumer<RoomProvider>(
                  builder: (context, roomProvider, child) {
                    return GlassmorphismContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rooms (${roomProvider.rooms.length})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (roomProvider.isLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            else if (roomProvider.errorMessage.isNotEmpty)
                              Text(
                                'Error: ${roomProvider.errorMessage}',
                                style: const TextStyle(color: Colors.red),
                              )
                            else if (roomProvider.rooms.isEmpty)
                              const Text(
                                'No rooms found. Try adding a sample room!',
                                style: TextStyle(color: Colors.white70),
                              )
                            else
                              ...roomProvider.rooms
                                  .take(3)
                                  .map(
                                    (room) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        '• ${room.title} - \$${room.price}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
