import 'package:flutter/material.dart';

class CloudImage extends StatelessWidget {
  final String imageUrl;
  final String fallbackAsset;
  final double? height;
  final double? width;

  const CloudImage({
    super.key,
    required this.imageUrl,
    required this.fallbackAsset,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: height ?? 80,
          width: width ?? 80,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          fallbackAsset,
          height: height,
          width: width,
          fit: BoxFit.contain,
        );
      },
    );
  }
}
