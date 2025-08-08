import 'dart:io';
import 'package:image/image.dart' as img;

/// Script to optimize asset images for better web performance
void main() async {
  final assetDir = Directory('assets/images');
  final outputDir = Directory('assets/images/optimized');

  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  final imageFiles = assetDir
      .listSync()
      .where((file) => file is File && _isImageFile(file.path))
      .cast<File>()
      .toList();

  print('🖼️  Optimizing ${imageFiles.length} images...');

  for (final file in imageFiles) {
    await _optimizeImage(file, outputDir);
  }

  print('✅ Image optimization completed!');
}

bool _isImageFile(String path) {
  final extensions = ['.jpg', '.jpeg', '.png', '.webp'];
  return extensions.any((ext) => path.toLowerCase().endsWith(ext));
}

Future<void> _optimizeImage(File inputFile, Directory outputDir) async {
  try {
    final fileName = inputFile.path.split(Platform.pathSeparator).last;
    print('📸 Processing: $fileName');

    final inputBytes = await inputFile.readAsBytes();
    final image = img.decodeImage(inputBytes);

    if (image == null) {
      print('❌ Failed to decode: $fileName');
      return;
    }

    // Generate different optimized versions
    final optimizations = [
      {'suffix': '_thumb', 'width': 150, 'quality': 75},
      {'suffix': '_small', 'width': 400, 'quality': 85},
      {'suffix': '_medium', 'width': 800, 'quality': 85},
      {'suffix': '_large', 'width': 1200, 'quality': 80},
    ];

    for (final opt in optimizations) {
      final targetWidth = opt['width'] as int;
      final quality = opt['quality'] as int;
      final suffix = opt['suffix'] as String;

      // Skip if image is already smaller than target
      if (image.width <= targetWidth) continue;

      // Calculate new dimensions maintaining aspect ratio
      final aspectRatio = image.width / image.height;
      final newWidth = targetWidth;
      final newHeight = (targetWidth / aspectRatio).round();

      // Resize image
      final resized = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // Determine output format and filename
      final baseName = fileName.split('.').first;
      final outputPath =
          '${outputDir.path}${Platform.pathSeparator}$baseName$suffix.jpg';

      // Encode as JPEG with quality compression
      final encodedBytes = img.encodeJpg(resized, quality: quality);

      // Write optimized image
      await File(outputPath).writeAsBytes(encodedBytes);

      final originalSize = inputBytes.length;
      final optimizedSize = encodedBytes.length;
      final savings = ((originalSize - optimizedSize) / originalSize * 100)
          .round();

      print(
        '  📦 $suffix: ${(optimizedSize / 1024).round()}KB (${savings}% smaller)',
      );
    }
  } catch (e) {
    print('❌ Error processing ${inputFile.path}: $e');
  }
}
