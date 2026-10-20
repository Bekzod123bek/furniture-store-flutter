import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../domain/entities.dart';
import '../cubit/favorites_cubit.dart';
import '../widgets/product_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesCubit, List<Product>>(
        builder: (context, products) {
          if (products.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              message: 'Tap the heart on any product to save it here.',
              action: OutlinedButton(
                onPressed: onBrowse,
                child: const Text('Browse products'),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                sliver: SliverGrid.builder(
                  gridDelegate: productGridDelegate,
                  itemCount: products.length,
                  itemBuilder: (_, i) =>
                      ProductCard(product: products[i], heroPrefix: 'fav'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
