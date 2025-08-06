import 'package:flutter/material.dart';
import 'panorama_viewer.dart';

class PanoramaRoomImage extends StatelessWidget {
  final String imagePath;
  final String roomTitle;
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final bool showControls;
  final bool isFullInteractive;

  const PanoramaRoomImage({
    super.key,
    required this.imagePath,
    required this.roomTitle,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius,
    this.showControls = true,
    this.isFullInteractive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: GestureDetector(
        onTap: isFullInteractive
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PanoramaViewer(
                      imageUrl: imagePath,
                      title: '$roomTitle - 360° View',
                      isAsset: true,
                    ),
                  ),
                );
              }
            : null,
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.8,
              maxScale: 3.0,
              child: Image.asset(
                imagePath,
                height: height,
                width: width,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: borderRadius ?? BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.white60,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (showControls) ...[
              // 360° Indicator
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.threesixty, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '360°',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Interactive instruction
              if (isFullInteractive)
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Tap for fullscreen 360° view • Pinch to zoom',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
