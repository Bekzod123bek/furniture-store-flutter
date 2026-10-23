import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/core/widgets/empty_state.dart';
import 'package:furniture_store/core/widgets/failure_view.dart';
import 'package:furniture_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_filter.dart';
import 'package:furniture_store/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:furniture_store/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:furniture_store/features/catalog/presentation/l10n/catalog_labels.dart';
import 'package:furniture_store/features/catalog/presentation/widgets/ai_room_card.dart';
import 'package:furniture_store/features/catalog/presentation/widgets/banner_carousel.dart';
import 'package:furniture_store/features/catalog/presentation/widgets/category_icon.dart';
import 'package:furniture_store/features/catalog/presentation/widgets/filter_sheet.dart';
import 'package:furniture_store/features/catalog/presentation/widgets/product_card.dart';
import 'package:furniture_store/features/catalog/presentation/widgets/product_grid_skeleton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _search = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = context.l10n;
    context.read<CatalogCubit>().setCategoryNames({
      for (final c in ProductCategory.values) c: [c.label(l10n)],
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openFilters(CatalogState state) async {
    final summary = state.summary;
    if (summary == null) return;
    final result = await showFilterSheet(
      context,
      filter: state.filter,
      summary: summary,
    );
    if (result != null && mounted) {
      context.read<CatalogCubit>().applyFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            final cubit = context.read<CatalogCubit>();
            final filter = state.filter;
            final loading = state.status.isLoading;

            if (state.status == LoadStatus.failure && state.all.isEmpty) {
              return FailureView(
                failure: state.failure!,
                onRetry: () => cubit.load(forceRefresh: true),
              );
            }

            return RefreshIndicator(
              onRefresh: () => cubit.load(forceRefresh: true),
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: _Header()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: _SearchRow(
                        controller: _search,
                        state: state,
                        onFilters: () => _openFilters(state),
                      ),
                    ),
                  ),
                  if (filter.isBrowsing) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: AiRoomCard(),
                      ),
                    ),
                    if (state.banners.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: BannerCarousel(
                            banners: state.banners,
                            onCategoryTap: cubit.selectCategory,
                          ),
                        ),
                      ),
                  ],
                  SliverToBoxAdapter(
                    child: _CategoryChips(selected: filter.category),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 8, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              loading
                                  ? l10n.homeLoading
                                  : filter.isBrowsing
                                  ? l10n.homePopular
                                  : l10n.homeResults(state.visible.length),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          _SortButton(sort: filter.sort),
                        ],
                      ),
                    ),
                  ),
                  if (loading && state.all.isEmpty)
                    const ProductGridSkeleton()
                  else if (state.visible.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: Icons.search_off,
                        title: state.all.isEmpty
                            ? l10n.homeEmptyCatalog
                            : l10n.homeNothingFound,
                        message: state.all.isEmpty
                            ? l10n.homeEmptyCatalogText
                            : l10n.homeNothingFoundText,
                        action: state.all.isEmpty
                            ? null
                            : OutlinedButton(
                                onPressed: () {
                                  _search.clear();
                                  cubit.applyFilter(
                                    ProductFilter(sort: filter.sort),
                                  );
                                },
                                child: Text(l10n.homeResetFilters),
                              ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverGrid.builder(
                        gridDelegate: productGridDelegate,
                        itemCount: state.visible.length,
                        itemBuilder: (_, i) =>
                            ProductCard(product: state.visible[i]),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final user = context.select((AuthCubit c) => c.state.user);
    final name = user?.firstName ?? '';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? l10n.commonHello : l10n.commonHelloName(name),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(l10n.homeTitle, style: theme.textTheme.headlineSmall),
              ],
            ),
          ),
          if (user != null)
            CircleAvatar(
              radius: 22,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                user.initials,
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.controller,
    required this.state,
    required this.onFilters,
  });

  final TextEditingController controller;
  final CatalogState state;
  final VoidCallback onFilters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CatalogCubit>();
    final filter = state.filter;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onChanged: cubit.search,
            decoration: InputDecoration(
              hintText: l10n.homeSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: filter.query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l10n.homeClearSearch,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.clear();
                        cubit.search('');
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
            tooltip: l10n.homeFilters,
            style: IconButton.styleFrom(
              minimumSize: const Size(54, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: state.summary == null ? null : onFilters,
            icon: const Icon(Icons.tune),
          ),
        ),
      ],
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.sort});

  final SortOption sort;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<SortOption>(
      tooltip: l10n.homeSort,
      initialValue: sort,
      onSelected: context.read<CatalogCubit>().sortBy,
      itemBuilder: (_) => [
        for (final s in SortOption.values)
          PopupMenuItem(value: s, child: Text(s.label(l10n))),
      ],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.swap_vert, size: 18),
            const SizedBox(width: 4),
            Text(
              sort.label(l10n),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}

/// Categories as a row of rounded chips with icons.
class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected});

  final ProductCategory? selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CatalogCubit>();
    return SizedBox(
      height: 64,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        children: [
          _Chip(
            icon: Icons.grid_view_rounded,
            label: l10n.homeAllCategories,
            selected: selected == null,
            onTap: () => cubit.selectCategory(null),
          ),
          for (final c in ProductCategory.values)
            _Chip(
              icon: c.icon,
              label: c.label(l10n),
              selected: selected == c,
              onTap: () => cubit.selectCategory(selected == c ? null : c),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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
    final foreground = selected ? scheme.onPrimary : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Semantics(
        button: true,
        selected: selected,
        child: Material(
          color: selected ? scheme.primary : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: foreground),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
