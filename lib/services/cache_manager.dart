import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static final instance = CacheManager(
    Config(
      'product_images',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100, // Keep max 100 images
    ),
  );
}
