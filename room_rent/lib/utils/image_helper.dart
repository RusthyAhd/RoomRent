import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageHelper {
  /// Check if the image path is an asset image
  static bool isAssetImage(String imagePath) {
    return imagePath.startsWith('assets/');
  }

  /// Build an appropriate Image widget based on the image path
  static Widget buildImage({
    required String imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? errorWidget,
    Widget? loadingWidget,
  }) {
    final isAsset = isAssetImage(imagePath);

    Widget imageWidget;

    if (isAsset) {
      imageWidget = Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildDefaultErrorWidget();
        },
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) {
          return loadingWidget ?? _buildDefaultLoadingWidget();
        },
        errorWidget: (context, url, error) {
          return errorWidget ?? _buildDefaultErrorWidget();
        },
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: imageWidget);
    }

    return imageWidget;
  }

  /// Build an appropriate ImageProvider based on the image path
  static ImageProvider buildImageProvider(String imagePath) {
    if (isAssetImage(imagePath)) {
      return AssetImage(imagePath);
    } else {
      return NetworkImage(imagePath);
    }
  }

  /// Build an appropriate DecorationImage based on the image path
  static DecorationImage buildDecorationImage({
    required String imagePath,
    BoxFit fit = BoxFit.cover,
  }) {
    return DecorationImage(image: buildImageProvider(imagePath), fit: fit);
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
