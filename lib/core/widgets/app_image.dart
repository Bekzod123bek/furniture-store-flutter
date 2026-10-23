import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:furniture_store/core/widgets/skeleton.dart';

/// Network image with a skeleton placeholder and an error fallback.
class AppImage extends StatelessWidget {
  const AppImage(
    this.url, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  /// Turned off in tests, where the cache plugins are not available.
  static bool useCache = true;

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = useCache
        ? CachedNetworkImage(
            imageUrl: url,
            fit: fit,
            width: width,
            height: height,
            fadeInDuration: const Duration(milliseconds: 250),
            placeholder: (_, _) => const Skeleton(),
            errorWidget: (_, _, _) => const _ImageError(),
          )
        : Image.network(
            url,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (_, _, _) => const _ImageError(),
          );
    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.chair_outlined, color: scheme.onSurfaceVariant),
      ),
    );
  }
}
