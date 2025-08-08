import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageCompressionUtil {
  /// Compress image for web with optimized settings
  static Future<Uint8List> compressImageForWeb(
    Uint8List imageData, {
    int maxWidth = 800,
    int maxHeight = 600,
    int quality = 85,
  }) async {
    if (kIsWeb) {
      return compute(_compressImage, {
        'imageData': imageData,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
        'quality': quality,
      });
    }
    return imageData;
  }

  static Uint8List _compressImage(Map<String, dynamic> params) {
    final Uint8List imageData = params['imageData'];
    final int maxWidth = params['maxWidth'];
    final int maxHeight = params['maxHeight'];
    final int quality = params['quality'];

    try {
      // Decode the image
      final img.Image? image = img.decodeImage(imageData);
      if (image == null) return imageData;

      // Calculate new dimensions maintaining aspect ratio
      final int originalWidth = image.width;
      final int originalHeight = image.height;

      if (originalWidth <= maxWidth && originalHeight <= maxHeight) {
        // Image is already small enough, just compress quality
        return Uint8List.fromList(img.encodeJpg(image, quality: quality));
      }

      final double aspectRatio = originalWidth / originalHeight;
      int newWidth, newHeight;

      if (aspectRatio > 1) {
        // Landscape orientation
        newWidth = maxWidth;
        newHeight = (maxWidth / aspectRatio).round();
      } else {
        // Portrait orientation
        newHeight = maxHeight;
        newWidth = (maxHeight * aspectRatio).round();
      }

      // Resize the image
      final img.Image resizedImage = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // Encode as JPEG with quality compression
      return Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return imageData;
    }
  }

  /// Get optimized image dimensions for different screen sizes
  static Map<String, int> getOptimizedDimensions(double screenWidth) {
    if (screenWidth < 600) {
      // Mobile
      return {'width': 400, 'height': 300};
    } else if (screenWidth < 1200) {
      // Tablet
      return {'width': 600, 'height': 450};
    } else {
      // Desktop
      return {'width': 800, 'height': 600};
    }
  }

  /// Generate different sizes for responsive images
  static Future<Map<String, Uint8List>> generateResponsiveImages(
    Uint8List originalImage,
  ) async {
    final Map<String, Uint8List> responsiveImages = {};

    // Generate different sizes
    final sizes = [
      {'key': 'thumbnail', 'width': 150, 'height': 100},
      {'key': 'mobile', 'width': 400, 'height': 300},
      {'key': 'tablet', 'width': 600, 'height': 450},
      {'key': 'desktop', 'width': 800, 'height': 600},
    ];

    for (final size in sizes) {
      final compressed = await compressImageForWeb(
        originalImage,
        maxWidth: size['width'] as int,
        maxHeight: size['height'] as int,
        quality: size['key'] == 'thumbnail' ? 75 : 85,
      );
      responsiveImages[size['key'] as String] = compressed;
    }

    return responsiveImages;
  }
}
