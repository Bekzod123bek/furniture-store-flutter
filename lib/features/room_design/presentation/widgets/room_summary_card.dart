import 'package:flutter/material.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/features/catalog/presentation/l10n/catalog_labels.dart';
import 'package:furniture_store/features/room_design/presentation/l10n/room_labels.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_dimensions.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';

/// What the AI understood about the room. Everything can be corrected, and
/// the furniture set updates straight away.
class RoomSummaryCard extends StatelessWidget {
  const RoomSummaryCard({
    super.key,
    required this.analysis,
    required this.onRoomType,
    required this.onStyle,
    required this.onDimensions,
  });

  final RoomAnalysis analysis;
  final ValueChanged<RoomType> onRoomType;
  final ValueChanged<DesignStyle> onStyle;
  final ValueChanged<RoomDimensions> onDimensions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.roomYourRoom, style: theme.textTheme.titleMedium),
            if (analysis.summary.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                analysis.summary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _Dropdown<RoomType>(
                  label: l10n.roomType,
                  value: analysis.roomType,
                  values: RoomType.values,
                  text: (t) => t.label(l10n),
                  onChanged: onRoomType,
                ),
                _Dropdown<DesignStyle>(
                  label: l10n.roomStyle,
                  value: analysis.style,
                  values: DesignStyle.values,
                  text: (s) => s.label(l10n),
                  onChanged: onStyle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.roomColours, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 14,
              runSpacing: 8,
              children: [
                for (final color in analysis.palette)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Color(color.argb),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(color.name, style: theme.textTheme.bodySmall),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _SizeEditor(
              dimensions: analysis.dimensions,
              confidence: analysis.sizeConfidence,
              onChanged: onDimensions,
            ),
          ],
        ),
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.value,
    required this.values,
    required this.text,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T) text;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
        ),
        items: [
          for (final v in values)
            DropdownMenuItem(value: v, child: Text(text(v))),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class _SizeEditor extends StatelessWidget {
  const _SizeEditor({
    required this.dimensions,
    required this.confidence,
    required this.onChanged,
  });

  static const _step = 0.5;

  final RoomDimensions dimensions;
  final SizeConfidence confidence;
  final ValueChanged<RoomDimensions> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final note = switch (confidence) {
      SizeConfidence.high => l10n.roomSizeHigh,
      SizeConfidence.medium => l10n.roomSizeMedium,
      SizeConfidence.low => l10n.roomSizeLow,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l10n.roomSize, style: theme.textTheme.labelLarge),
            const Spacer(),
            Text(
              '${dimensions.label} · ${dimensions.areaM2.toStringAsFixed(1)} m²',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _Stepper(
                label: l10n.roomWidth,
                meters: dimensions.widthM,
                onChanged: (v) => onChanged(
                  RoomDimensions(widthM: v, lengthM: dimensions.lengthM),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Stepper(
                label: l10n.roomLength,
                meters: dimensions.lengthM,
                onChanged: (v) => onChanged(
                  RoomDimensions(widthM: dimensions.widthM, lengthM: v),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          note,
          style: theme.textTheme.bodySmall?.copyWith(
            color: confidence == SizeConfidence.low
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.meters,
    required this.onChanged,
  });

  final String label;
  final double meters;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: context.l10n.roomDecrease(label),
            onPressed: meters - _SizeEditor._step >= RoomDimensions.minSideM
                ? () => onChanged(meters - _SizeEditor._step)
                : null,
            icon: const Icon(Icons.remove),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                Text(
                  '${meters.toStringAsFixed(1)} m',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.l10n.roomIncrease(label),
            onPressed: meters + _SizeEditor._step <= RoomDimensions.maxSideM
                ? () => onChanged(meters + _SizeEditor._step)
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
