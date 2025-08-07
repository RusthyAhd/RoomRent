import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'optimized_image_manager.dart';

class ImageHelper {
  /// Check if the image path is an asset image
  static bool isAssetImage(String imagePath) {
    return imagePath.startsWith('assets/');
  }

  /// Build an optimized Image widget with performance enhancements
  static Widget buildImage({
    required String imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? errorWidget,
    Widget? loadingWidget,
    bool enableLazyLoading = true,
    String? heroTag,
  }) {
    return OptimizedImageManager.buildOptimizedImage(
      imageUrl: imagePath,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: loadingWidget,
      errorWidget: errorWidget,
      enableLazyLoading: enableLazyLoading,
      heroTag: heroTag,
    );
  }

  /// Build an appropriate ImageProvider based on the image path
  static ImageProvider buildImageProvider(String imagePath) {
    if (isAssetImage(imagePath)) {
      return AssetImage(imagePath);
    } else {
      return CachedNetworkImageProvider(imagePath);
    }
  }

  /// Build an appropriate DecorationImage based on the image path
  static DecorationImage buildDecorationImage({
    required String imagePath,
    BoxFit fit = BoxFit.cover,
  }) {
    return DecorationImage(image: buildImageProvider(imagePath), fit: fit);
  }

  /// Preload critical images for better performance
  static Future<void> preloadImage(String imagePath, BuildContext context) {
    return OptimizedImageManager.preloadImage(imagePath, context);
  }

  /// Preload multiple images
  static Future<void> preloadImages(
    List<String> imagePaths,
    BuildContext context,
  ) async {
    final futures = imagePaths.map((path) => preloadImage(path, context));
    await Future.wait(futures);
  }

  static Widget _buildDefaultErrorWidget() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported,
        size: 50,
        color: Colors.grey,
      ),
    );
  }

  static Widget _buildDefaultLoadingWidget() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
