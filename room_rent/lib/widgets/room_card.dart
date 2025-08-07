import 'package:flutter/material.dart';
import '../models/room.dart';
import '../widgets/panorama_room_image.dart';
import '../utils/image_helper.dart';
import 'glass_widgets.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;
  final bool showFavoriteButton;

  const RoomCard({
    super.key,
    required this.room,
    required this.onTap,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // Add fixed height to prevent unbounded constraints
      child: GlassCard(
        borderRadius: 16,
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: room.images.isNotEmpty
                          ? _buildRoomImage()
                          : Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.home,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),

                    // Available indicator
                    if (room.isAvailable)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Available',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Favorite button
                    if (showFavoriteButton)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Toggle favorite - implement in provider
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                    // 360 indicator
                    if (room.panoramaImage != null)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.threesixty,
                                color: Colors.white,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '360°',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Content section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        room.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              room.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Rating and amenities
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.orange.shade400,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            room.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.bed,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${room.bedrooms}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Price
                      Row(
                        children: [
                          Text(
                            '\$${room.price.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Text(
                            '/${_getPriceUnit(room.priceType)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
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

  Widget _buildRoomImage() {
    final imageUrl = room.images.first;
    final isAssetImage = imageUrl.startsWith('assets/');

    if (isAssetImage &&
        (imageUrl.contains('room.jpg') ||
            imageUrl.contains('ac room.jpg') ||
            imageUrl.contains('non-ac room.jpg') ||
            imageUrl.contains('confrence hall.jpg'))) {
      // Use panorama view for room image assets
      return PanoramaRoomImage(
        imagePath: imageUrl,
        roomTitle: room.title,
        height: double.infinity,
        width: double.infinity,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        showControls: true,
        isFullInteractive: true,
      );
    } else if (isAssetImage) {
      // Regular asset image with optimization
      return ImageHelper.buildImage(
        imagePath: imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        enableLazyLoading: true,
        heroTag: 'room_${room.id}_$imageUrl',
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      );
    } else {
      // Network image with optimization
      return ImageHelper.buildImage(
        imagePath: imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        enableLazyLoading: true,
        heroTag: 'room_${room.id}_$imageUrl',
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      );
    }
  }

  String _getPriceUnit(String priceType) {
    switch (priceType) {
      case 'per_night':
        return 'night';
      case 'per_week':
        return 'week';
      case 'per_month':
        return 'month';
      default:
        return 'night';
    }
  }
}
