import 'package:flutter/material.dart';

import '../../../../core/utils/format.dart';
import '../../domain/entities.dart';

/// Bottom sheet for price, material, rating and sale filters.
/// Returns the new filter, or `null` when dismissed.
Future<ProductFilter?> showFilterSheet(
  BuildContext context, {
  required ProductFilter filter,
  required List<String> materials,
  required int maxPrice,
}) => showModalBottomSheet<ProductFilter>(
  context: context,
  isScrollControlled: true,
  builder: (_) =>
      _FilterSheet(initial: filter, materials: materials, maxPrice: maxPrice),
);

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.initial,
    required this.materials,
    required this.maxPrice,
  });

  final ProductFilter initial;
  final List<String> materials;
  final int maxPrice;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late RangeValues _price = RangeValues(
    widget.initial.minPrice.toDouble(),
    (widget.initial.maxPrice ?? widget.maxPrice).toDouble(),
  );
  late final Set<String> _materials = {...widget.initial.materials};
  late double _minRating = widget.initial.minRating;
  late bool _onlyDiscounted = widget.initial.onlyDiscounted;

  static const _ratings = [0.0, 4.0, 4.5];

  void _apply() {
    final max = _price.end.round();
    Navigator.of(context).pop(
      widget.initial.copyWith(
        minPrice: _price.start.round(),
        maxPrice: () => max >= widget.maxPrice ? null : max,
        materials: _materials,
        minRating: _minRating,
        onlyDiscounted: _onlyDiscounted,
      ),
    );
  }

  void _reset() => setState(() {
    _price = RangeValues(0, widget.maxPrice.toDouble());
    _materials.clear();
    _minRating = 0;
    _onlyDiscounted = false;
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  Text('Filters', style: theme.textTheme.titleLarge),
                  const Spacer(),
                  TextButton(onPressed: _reset, child: const Text('Reset')),
                ],
              ),
              const SizedBox(height: 12),
              _Title(
                'Price',
                trailing: '${money(_price.start)} – ${money(_price.end)}',
              ),
              RangeSlider(
                values: _price,
                min: 0,
                max: widget.maxPrice.toDouble(),
                divisions: 30,
                labels: RangeLabels(money(_price.start), money(_price.end)),
                onChanged: (v) => setState(() => _price = v),
              ),
              const SizedBox(height: 8),
              const _Title('Material'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final m in widget.materials)
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
              const _Title('Rating'),
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
                              color: Color(0xFFF5A623),
                            ),
                      label: Text(r == 0 ? 'Any' : '$r+'),
                      selected: _minRating == r,
                      onSelected: (_) => setState(() => _minRating = r),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Only items on sale'),
                value: _onlyDiscounted,
                onChanged: (v) => setState(() => _onlyDiscounted = v),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _apply,
                child: const Text('Show results'),
              ),
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
