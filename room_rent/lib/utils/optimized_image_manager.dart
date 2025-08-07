import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:async';

class OptimizedImageManager {
  static final OptimizedImageManager _instance =
      OptimizedImageManager._internal();
  factory OptimizedImageManager() => _instance;
  OptimizedImageManager._internal();

  // Custom cache manager for better performance
  static final CacheManager _cacheManager = CacheManager(
    Config(
      'optimized_image_cache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: 'optimized_image_cache'),
      fileService: HttpFileService(),
    ),
  );

  // Preload critical images
  static final Set<String> _preloadedImages = {};
  static final Map<String, Completer<void>> _preloadingImages = {};

  /// Preload critical images for better performance
  static Future<void> preloadImage(
    String imageUrl,
    BuildContext context,
  ) async {
    if (_preloadedImages.contains(imageUrl) ||
        _preloadingImages.containsKey(imageUrl)) {
      return _preloadingImages[imageUrl]?.future ?? Future.value();
    }

    final completer = Completer<void>();
    _preloadingImages[imageUrl] = completer;

    try {
      if (imageUrl.startsWith('assets/')) {
        await precacheImage(AssetImage(imageUrl), context);
      } else {
        await _cacheManager.getSingleFile(imageUrl);
      }
      _preloadedImages.add(imageUrl);
      completer.complete();
    } catch (e) {
      completer.completeError(e);
    } finally {
      _preloadingImages.remove(imageUrl);
    }
  }

  /// Build optimized image widget with lazy loading
  static Widget buildOptimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
    bool enableLazyLoading = true,
    String? heroTag,
  }) {
    Widget imageWidget = _buildImageWidget(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );

    // Add hero animation if specified
    if (heroTag != null) {
      imageWidget = Hero(tag: heroTag, child: imageWidget);
    }

    // Add border radius if specified
    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius, child: imageWidget);
    }

    // Add lazy loading if enabled
    if (enableLazyLoading) {
      imageWidget = VisibilityDetector(
        key: Key('image_$imageUrl'),
        onVisibilityChanged: (info) {
          // Preload when image becomes partially visible
          if (info.visibleFraction > 0.1) {
            // Preload in background without blocking UI
            _preloadImageSilently(imageUrl);
          }
        },
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  static Widget _buildImageWidget({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    final isAsset = imageUrl.startsWith('assets/');

    if (isAsset) {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: _calculateCacheWidth(width),
        cacheHeight: _calculateCacheHeight(height),
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _buildDefaultErrorWidget(),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheManager: _cacheManager,
        memCacheWidth: _calculateCacheWidth(width),
        memCacheHeight: _calculateCacheHeight(height),
        placeholder: (context, url) =>
            placeholder ?? _buildDefaultPlaceholder(),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildDefaultErrorWidget(),
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 100),
      );
    }
  }

  static void _preloadImageSilently(String imageUrl) {
    if (!_preloadedImages.contains(imageUrl) &&
        !_preloadingImages.containsKey(imageUrl)) {
      final completer = Completer<void>();
      _preloadingImages[imageUrl] = completer;

      _cacheManager
          .getSingleFile(imageUrl)
          .then((_) {
            _preloadedImages.add(imageUrl);
            completer.complete();
          })
          .catchError((e) {
            completer.completeError(e);
          })
          .whenComplete(() {
            _preloadingImages.remove(imageUrl);
          });
    }
  }

  static int? _calculateCacheWidth(double? width) {
    if (width == null) return null;
    // Optimize cache size based on screen density
    return (width * 2).round();
  }

  static int? _calculateCacheHeight(double? height) {
    if (height == null) return null;
    // Optimize cache size based on screen density
    return (height * 2).round();
  }

  static Widget _buildDefaultPlaceholder() {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
          ),
        ),
      ),
    );
  }

  static Widget _buildDefaultErrorWidget() {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: const Icon(
        Icons.image_not_supported,
        size: 32,
        color: Colors.white54,
      ),
    );
  }

  /// Clear cache if needed
  static Future<void> clearCache() async {
    await _cacheManager.emptyCache();
    _preloadedImages.clear();
  }

  /// Get cache info
  static Future<void> logCacheInfo() async {
    final cacheInfo = await _cacheManager.getFileFromCache('');
    debugPrint('Cache info: ${cacheInfo?.toString()}');
  }
}
