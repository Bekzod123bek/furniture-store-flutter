import 'package:flutter/material.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/features/room_design/presentation/l10n/room_labels.dart';
import 'package:furniture_store/core/utils/formatters.dart';
import 'package:furniture_store/core/widgets/app_image.dart';
import 'package:furniture_store/features/room_design/domain/entities/recommendation.dart';
import 'package:furniture_store/features/room_design/domain/entities/slot_recommendation.dart';

/// One piece of the furniture set with the reasons it was chosen and a few
/// alternatives to swap in.
class SlotCard extends StatelessWidget {
  const SlotCard({
    super.key,
    required this.slot,
    required this.onOpen,
    required this.onSelect,
  });

  final SlotRecommendation slot;
  final ValueChanged<Recommendation> onOpen;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final item = slot.selected;
    final product = item.product;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              slot.slot.kind.label(l10n).toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.primary,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onOpen(item),
              child: Row(
                children: [
                  AppImage(
                    product.images.first,
                    width: 88,
                    height: 88,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Color(item.color.argb),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: scheme.outlineVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                item.color.name,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.quantity > 1
                              ? l10n.roomQuantityPrice(
                                  '${item.quantity}',
                                  formatMoney(product.price),
                                  formatMoney(item.totalPrice),
                                )
                              : formatMoney(item.totalPrice),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
                ],
              ),
            ),
            if (item.reasons.isNotEmpty) ...[
              const SizedBox(height: 10),
              for (final reason in item.reasons)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          reason.text(l10n),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            if (slot.candidates.length > 1) ...[
              const SizedBox(height: 12),
              Text(l10n.roomOtherOptions, style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: slot.candidates.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, i) => _CandidateThumb(
                    recommendation: slot.candidates[i],
                    selected: i == slot.selectedIndex,
                    onTap: () => onSelect(i),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CandidateThumb extends StatelessWidget {
  const _CandidateThumb({
    required this.recommendation,
    required this.selected,
    required this.onTap,
  });

  final Recommendation recommendation;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final product = recommendation.product;
    return Semantics(
      button: true,
      selected: selected,
      label: '${product.name}, ${formatMoney(recommendation.totalPrice)}',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 2.5 : 1,
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: AppImage(
            product.images.first,
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }
}
