import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/format.dart';
import '../../../../core/widgets/app_image.dart';
import '../../domain/entities.dart';
import '../cubit/favorites_cubit.dart';
import '../pages/product_page.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.heroPrefix = 'grid',
  });

  final Product product;

  /// Keeps Hero tags unique when one product shows in several lists.
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final heroTag = '$heroPrefix-${product.id}';
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ProductPage(product: product, heroTag: heroTag),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: heroTag,
                    child: AppImage(
                      product.images.first,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                if (product.discountPercent > 0 || product.isNew)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: _Badge(
                      label: product.discountPercent > 0
                          ? '-${product.discountPercent}%'
                          : 'NEW',
                      color: product.discountPercent > 0
                          ? const Color(0xFFD9534F)
                          : scheme.primary,
                    ),
                  ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: _FavoriteButton(product: product),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 16,
                color: Color(0xFFF5A623),
              ),
              const SizedBox(width: 2),
              Text(
                '${product.rating}  (${product.reviewCount})',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                money(product.price),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.primary,
                ),
              ),
              if (product.oldPrice != null) ...[
                const SizedBox(width: 6),
                Text(
                  money(product.oldPrice!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final favorite = context.select<FavoritesCubit, bool>(
      (c) => c.state.contains(product),
    );
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.read<FavoritesCubit>().toggle(product),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, a) =>
                ScaleTransition(scale: a, child: child),
            child: Icon(
              favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(favorite),
              size: 20,
              color: favorite ? const Color(0xFFD9534F) : Colors.black87,
              semanticLabel: favorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
            ),
          ),
        ),
      ),
    );
  }
}
