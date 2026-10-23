import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/router/route_args.dart';
import 'package:furniture_store/core/router/routes.dart';
import 'package:furniture_store/core/theme/app_colors.dart';
import 'package:furniture_store/core/utils/formatters.dart';
import 'package:furniture_store/core/widgets/app_image.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/favorites/presentation/cubit/favorites_cubit.dart';

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
    final l10n = context.l10n;
    final heroTag = '$heroPrefix-${product.id}';
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pushNamed(
        Routes.productDetails,
        arguments: ProductDetailsArgs(productId: product.id, heroTag: heroTag),
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
                          : l10n.productNew,
                      color: product.discountPercent > 0
                          ? AppColors.sale
                          : scheme.primary,
                    ),
                  ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: FavoriteButton(product: product),
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
              const Icon(Icons.star_rounded, size: 16, color: AppColors.rating),
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
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 6,
                  children: [
                    Text(
                      formatMoney(product.price),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                    if (product.oldPrice != null)
                      Text(
                        formatMoney(product.oldPrice!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ),
              _QuickAddButton(product: product),
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

/// Heart button that adds or removes [product] from the favorites.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final favorite = context.select<FavoritesCubit, bool>(
      (c) => c.state.contains(product),
    );
    return IconButton(
      tooltip: favorite
          ? context.l10n.productRemoveFavorite
          : context.l10n.productAddFavorite,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        minimumSize: const Size(44, 44),
      ),
      onPressed: () => context.read<FavoritesCubit>().toggle(product),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, a) =>
            ScaleTransition(scale: a, child: child),
        child: Icon(
          favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(favorite),
          size: 22,
          color: favorite ? AppColors.sale : Colors.black87,
        ),
      ),
    );
  }
}

/// Puts one piece in the default colour into the cart without opening the
/// product page.
class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({required this.product});

  final Product product;

  Future<void> _add(BuildContext context) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    await context.read<CartCubit>().add(product);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.productAdded('1', product.name))),
      );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton.filled(
      tooltip: context.l10n.productAddToCart,
      onPressed: () => _add(context),
      style: IconButton.styleFrom(
        minimumSize: const Size(40, 40),
        fixedSize: const Size(40, 40),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      icon: const Icon(Icons.add_shopping_cart, size: 20),
    );
  }
}
