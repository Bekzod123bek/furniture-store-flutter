import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../injection.dart';
import '../../../auth/auth_cubit.dart';
import '../../domain/entities.dart';
import '../../domain/product_repository.dart';
import '../cubit/catalog_cubit.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_icon.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openFilters(ProductFilter filter) async {
    final repo = sl<ProductRepository>();
    final result = await showFilterSheet(
      context,
      filter: filter,
      materials: repo.materials,
      maxPrice: repo.maxPrice,
    );
    if (result != null && mounted) {
      context.read<CatalogCubit>().applyFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = context.select<AuthCubit, String>((c) => c.state.name);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            final filter = state.filter;
            final browsing =
                filter.query.isEmpty &&
                filter.category == null &&
                filter.activeCount == 0;
            return RefreshIndicator(
              onRefresh: context.read<CatalogCubit>().load,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${name.split(' ').first} 👋',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Find furniture you love',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _search,
                                  textInputAction: TextInputAction.search,
                                  onChanged: context
                                      .read<CatalogCubit>()
                                      .search,
                                  decoration: InputDecoration(
                                    hintText: 'Search sofas, oak, lamps…',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: filter.query.isEmpty
                                        ? null
                                        : IconButton(
                                            tooltip: 'Clear search',
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              _search.clear();
                                              context
                                                  .read<CatalogCubit>()
                                                  .search('');
                                            },
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Badge(
                                isLabelVisible: filter.activeCount > 0,
                                label: Text('${filter.activeCount}'),
                                child: IconButton.filled(
                                  tooltip: 'Filters',
                                  style: IconButton.styleFrom(
                                    minimumSize: const Size(54, 54),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () => _openFilters(filter),
                                  icon: const Icon(Icons.tune),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (browsing)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: BannerCarousel(
                          onCategoryTap: context
                              .read<CatalogCubit>()
                              .selectCategory,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: _CategoryBar(selected: filter.category),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 8, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.loading
                                  ? 'Loading…'
                                  : browsing
                                  ? 'Popular now'
                                  : '${state.products.length} results',
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          PopupMenuButton<SortOption>(
                            tooltip: 'Sort',
                            initialValue: filter.sort,
                            onSelected: context.read<CatalogCubit>().sortBy,
                            itemBuilder: (_) => [
                              for (final s in SortOption.values)
                                PopupMenuItem(value: s, child: Text(s.label)),
                            ],
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Text(
                                    filter.sort.label,
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  const Icon(Icons.expand_more, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.loading && state.products.isEmpty)
                    const ProductGridSkeleton()
                  else if (state.products.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: Icons.search_off,
                        title: 'Nothing found',
                        message:
                            'Try another search word or reset the filters.',
                        action: OutlinedButton(
                          onPressed: () {
                            _search.clear();
                            context.read<CatalogCubit>().applyFilter(
                              ProductFilter(sort: filter.sort),
                            );
                          },
                          child: const Text('Reset filters'),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverOpacity(
                        opacity: state.loading ? 0.5 : 1,
                        sliver: SliverGrid.builder(
                          gridDelegate: productGridDelegate,
                          itemCount: state.products.length,
                          itemBuilder: (_, i) =>
                              ProductCard(product: state.products[i]),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.selected});

  final Category? selected;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CatalogCubit>();
    return SizedBox(
      height: 104,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
        children: [
          _CategoryItem(
            icon: Icons.grid_view_rounded,
            label: 'All',
            selected: selected == null,
            onTap: () => cubit.selectCategory(null),
          ),
          for (final c in Category.values)
            _CategoryItem(
              icon: c.icon,
              label: c.label,
              selected: selected == c,
              onTap: () => cubit.selectCategory(selected == c ? null : c),
            ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 64,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: selected
                      ? scheme.primary
                      : scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
