import 'package:flutter/material.dart';
import '../utils/image_helper.dart';

class ImagePreloadService {
  static final ImagePreloadService _instance = ImagePreloadService._internal();
  factory ImagePreloadService() => _instance;
  ImagePreloadService._internal();

  static const List<String> _criticalAssetImages = [
    'assets/images/Pegas_Logo.png',
    'assets/images/room.png',
    'assets/images/ac room.jpg',
    'assets/images/non-ac room.jpg',
    'assets/images/confrence hall.jpg',
    'assets/images/user.jpg',
    'assets/images/manager.jpg',
  ];

  /// Preload critical images when the app starts
  static Future<void> preloadCriticalImages(BuildContext context) async {
    try {
      // Preload in chunks to avoid overwhelming the system
      const int chunkSize = 3;
      for (int i = 0; i < _criticalAssetImages.length; i += chunkSize) {
        final chunk = _criticalAssetImages.skip(i).take(chunkSize).toList();
        await ImageHelper.preloadImages(chunk, context);

        // Small delay between chunks to prevent blocking
        await Future.delayed(const Duration(milliseconds: 50));
      }
      debugPrint('✅ Critical images preloaded successfully');
    } catch (e) {
      debugPrint('❌ Error preloading critical images: $e');
    }
  }

  /// Preload images for a specific screen
  static Future<void> preloadScreenImages(
    List<String> images,
    BuildContext context,
  ) async {
    try {
      await ImageHelper.preloadImages(images, context);
      debugPrint('✅ Screen images preloaded: ${images.length} images');
    } catch (e) {
      debugPrint('❌ Error preloading screen images: $e');
    }
  }

  /// Get list of critical images that should be preloaded
  static List<String> get criticalImages => _criticalAssetImages;
}
