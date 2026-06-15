import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pharmacy/services/cache_manager.dart';

class OptimizedProductImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const OptimizedProductImage({
    Key? key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
      cacheManager: CustomCacheManager.instance,
    );
  }
}
