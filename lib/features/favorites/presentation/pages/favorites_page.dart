import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/core/widgets/empty_state.dart';
import 'package:furniture_store/core/widgets/failure_view.dart';
import 'package:furniture_store/features/catalog/presentation/widgets/product_card.dart';
import 'package:furniture_store/features/catalog/presentation/widgets/product_grid_skeleton.dart';
import 'package:furniture_store/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:furniture_store/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.status.isLoading && state.products.isEmpty) {
            return const CustomScrollView(slivers: [ProductGridSkeleton()]);
          }
          if (state.status == LoadStatus.failure && state.products.isEmpty) {
            return FailureView(
              failure: state.failure!,
              onRetry: context.read<FavoritesCubit>().load,
            );
          }
          if (state.products.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border_rounded,
              title: l10n.favoritesEmpty,
              message: l10n.favoritesEmptyText,
              action: OutlinedButton(
                onPressed: onBrowse,
                child: Text(l10n.favoritesBrowse),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                sliver: SliverGrid.builder(
                  gridDelegate: productGridDelegate,
                  itemCount: state.products.length,
                  itemBuilder: (_, i) => ProductCard(
                    product: state.products[i],
                    heroPrefix: 'fav',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
