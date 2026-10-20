import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/format.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../injection.dart';
import '../../domain/entities.dart';
import '../../domain/product_repository.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/favorites_cubit.dart';
import '../widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product, required this.heroTag});

  final Product product;
  final String heroTag;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _gallery = PageController();
  int _image = 0;
  late ProductColor _color = widget.product.colors.first;
  int _quantity = 1;

  Product get product => widget.product;

  @override
  void dispose() {
    _gallery.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    await context.read<CartCubit>().add(
      product,
      color: _color,
      quantity: _quantity,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$_quantity × ${product.name} added to cart')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final related = sl<ProductRepository>().related(product);
    final favorite = context.select<FavoritesCubit, bool>(
      (c) => c.state.contains(product),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            stretch: true,
            leading: const Padding(
              padding: EdgeInsets.all(6),
              child: _CircleBack(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: IconButton.filledTonal(
                  tooltip: favorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  onPressed: () =>
                      context.read<FavoritesCubit>().toggle(product),
                  icon: Icon(
                    favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: favorite ? const Color(0xFFD9534F) : null,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.heroTag,
                    child: PageView.builder(
                      controller: _gallery,
                      itemCount: product.images.length,
                      onPageChanged: (i) => setState(() => _image = i),
                      itemBuilder: (_, i) => AppImage(product.images[i]),
                    ),
                  ),
                  if (product.images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < product.images.length; i++)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: i == _image ? 22 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: i == _image
                                    ? Colors.white
                                    : Colors.white60,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.label.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(product.name, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (var i = 1; i <= 5; i++)
                        Icon(
                          i <= product.rating.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 20,
                          color: const Color(0xFFF5A623),
                        ),
                      const SizedBox(width: 6),
                      Text(
                        '${product.rating} · ${product.reviewCount} reviews',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        money(product.price),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          money(product.oldPrice!),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Save ${product.discountPercent}%',
                          style: const TextStyle(
                            color: Color(0xFFD9534F),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Colour: ${_color.name}',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    children: [
                      for (final c in product.colors)
                        _ColorDot(
                          color: c,
                          selected: c == _color,
                          onTap: () => setState(() => _color = c),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('About', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  _SpecRow(
                    icon: Icons.texture,
                    label: 'Material',
                    value: product.material,
                  ),
                  _SpecRow(
                    icon: Icons.straighten,
                    label: 'Size',
                    value: product.dimensions,
                  ),
                  const _SpecRow(
                    icon: Icons.local_shipping_outlined,
                    label: 'Delivery',
                    value: '3–5 days',
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text('Reviews', style: theme.textTheme.titleMedium),
                      const Spacer(),
                      Text(
                        '${product.reviewCount} total',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final r in product.reviews) _ReviewTile(review: r),
                ],
              ),
            ),
          ),
          if (related.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'You may also like',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: related.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (_, i) => SizedBox(
                    width: 160,
                    child: ProductCard(
                      product: related[i],
                      heroPrefix: 'related-${product.id}',
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          child: Row(
            children: [
              _QuantityStepper(
                value: _quantity,
                onChanged: (v) => setState(() => _quantity = v),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text('Add · ${money(product.price * _quantity)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleBack extends StatelessWidget {
  const _CircleBack();

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: 'Back',
    onPressed: () => Navigator.of(context).maybePop(),
    icon: const Icon(Icons.arrow_back),
  );
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final ProductColor color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: color.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(color.value),
              shape: BoxShape.circle,
              border: Border.all(color: scheme.outlineVariant),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Text(label, style: theme.textTheme.bodyMedium),
          const Spacer(),
          Text(value, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    review.author[0],
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(review.author, style: theme.textTheme.titleSmall),
                ),
                for (var i = 0; i < review.rating; i++)
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Color(0xFFF5A623),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              review.date,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Decrease',
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          Text('$value', style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            tooltip: 'Increase',
            onPressed: value < 10 ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
