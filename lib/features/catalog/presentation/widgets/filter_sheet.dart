import 'package:flutter/material.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/theme/app_colors.dart';
import 'package:furniture_store/core/utils/formatters.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_filter.dart';
import 'package:furniture_store/features/catalog/domain/usecases/catalog_summary.dart';

/// Bottom sheet for price, material, rating and sale filters.
/// Returns the new filter, or `null` when dismissed.
Future<ProductFilter?> showFilterSheet(
  BuildContext context, {
  required ProductFilter filter,
  required CatalogSummary summary,
}) => showModalBottomSheet<ProductFilter>(
  context: context,
  isScrollControlled: true,
  builder: (_) => _FilterSheet(initial: filter, summary: summary),
);

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial, required this.summary});

  final ProductFilter initial;
  final CatalogSummary summary;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  /// The price slider moves in steps of this many dollars.
  static const _priceStep = 10;
  static const _ratings = [0.0, 4.0, 4.5];

  late final int _maxPrice =
      (widget.summary.maxPrice / _priceStep).ceil() * _priceStep;
  late RangeValues _price = RangeValues(
    widget.initial.minPrice.toDouble(),
    (widget.initial.maxPrice ?? _maxPrice).toDouble(),
  );
  late final Set<String> _materials = {...widget.initial.materials};
  late double _minRating = widget.initial.minRating;
  late bool _onlyDiscounted = widget.initial.onlyDiscounted;

  void _apply() {
    final max = _price.end.round();
    Navigator.of(context).pop(
      widget.initial.copyWith(
        minPrice: _price.start.round(),
        maxPrice: () => max >= _maxPrice ? null : max,
        materials: _materials,
        minRating: _minRating,
        onlyDiscounted: _onlyDiscounted,
      ),
    );
  }

  void _reset() => setState(() {
    _price = RangeValues(0, _maxPrice.toDouble());
    _materials.clear();
    _minRating = 0;
    _onlyDiscounted = false;
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(l10n.filterTitle, style: theme.textTheme.titleLarge),
                  const Spacer(),
                  TextButton(onPressed: _reset, child: Text(l10n.commonReset)),
                ],
              ),
              const SizedBox(height: 12),
              _Title(
                l10n.filterPrice,
                trailing:
                    '${formatMoney(_price.start)} – ${formatMoney(_price.end)}',
              ),
              RangeSlider(
                values: _price,
                min: 0,
                max: _maxPrice.toDouble(),
                divisions: _maxPrice ~/ _priceStep,
                labels: RangeLabels(
                  formatMoney(_price.start),
                  formatMoney(_price.end),
                ),
                onChanged: (v) => setState(() => _price = v),
              ),
              const SizedBox(height: 8),
              _Title(l10n.filterMaterial),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final m in widget.summary.materials)
                    FilterChip(
                      label: Text(m),
                      selected: _materials.contains(m),
                      onSelected: (on) => setState(
                        () => on ? _materials.add(m) : _materials.remove(m),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _Title(l10n.filterRating),
              Wrap(
                spacing: 8,
                children: [
                  for (final r in _ratings)
                    ChoiceChip(
                      avatar: r == 0
                          ? null
                          : const Icon(
                              Icons.star_rounded,
                              size: 18,
                              color: AppColors.rating,
                            ),
                      label: Text(r == 0 ? l10n.filterAnyRating : '$r+'),
                      selected: _minRating == r,
                      onSelected: (_) => setState(() => _minRating = r),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.filterOnSale),
                value: _onlyDiscounted,
                onChanged: (v) => setState(() => _onlyDiscounted = v),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: _apply, child: Text(l10n.filterShow)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text, {this.trailing});

  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(text, style: theme.textTheme.titleSmall),
          const Spacer(),
          if (trailing != null)
            Text(
              trailing!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}
