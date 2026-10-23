import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/error/failure_messages.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/router/route_args.dart';
import 'package:furniture_store/core/router/routes.dart';
import 'package:furniture_store/core/theme/app_colors.dart';
import 'package:furniture_store/core/utils/formatters.dart';
import 'package:furniture_store/core/widgets/empty_state.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:furniture_store/features/catalog/presentation/l10n/catalog_labels.dart';
import 'package:furniture_store/features/room_design/domain/entities/furniture_set.dart';
import 'package:furniture_store/features/room_design/domain/entities/photo_source.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_photo.dart';
import 'package:furniture_store/features/room_design/domain/services/fit_checker.dart';
import 'package:furniture_store/features/room_design/presentation/cubit/room_scan_cubit.dart';
import 'package:furniture_store/features/room_design/presentation/cubit/room_scan_state.dart';
import 'package:furniture_store/features/room_design/presentation/l10n/room_labels.dart';
import 'package:furniture_store/features/room_design/presentation/widgets/room_summary_card.dart';
import 'package:furniture_store/features/room_design/presentation/widgets/slot_card.dart';

class RoomScanPage extends StatelessWidget {
  const RoomScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomScanCubit, RoomScanState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final ready = state.status == RoomScanStatus.ready;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.roomTitle),
            actions: [
              if (state.status != RoomScanStatus.idle)
                IconButton(
                  tooltip: l10n.roomStartOver,
                  onPressed: context.read<RoomScanCubit>().reset,
                  icon: const Icon(Icons.restart_alt),
                ),
            ],
          ),
          body: switch (state.status) {
            RoomScanStatus.idle => const _IntroView(),
            RoomScanStatus.analyzing => _AnalyzingView(photo: state.photo!),
            RoomScanStatus.failure => _FailureView(state: state),
            RoomScanStatus.ready => _ResultView(state: state),
          },
          bottomNavigationBar: ready && !state.furnitureSet.isEmpty
              ? _AddAllBar(furnitureSet: state.furnitureSet)
              : null,
        );
      },
    );
  }
}

void _pick(BuildContext context, PhotoSource source) => context
    .read<RoomScanCubit>()
    .pickPhoto(source, languageCode: context.languageCode);

class _IntroView extends StatelessWidget {
  const _IntroView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.aiGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.roomIntroTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.roomIntroText,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => _pick(context, PhotoSource.camera),
          icon: const Icon(Icons.photo_camera_outlined),
          label: Text(l10n.roomTakePhoto),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _pick(context, PhotoSource.gallery),
          icon: const Icon(Icons.photo_library_outlined),
          label: Text(l10n.roomGallery),
        ),
        const SizedBox(height: 24),
        Text(l10n.roomTips, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        _Tip(Icons.crop_free, l10n.roomTipCorner),
        _Tip(Icons.wb_sunny_outlined, l10n.roomTipLight),
        _Tip(Icons.door_front_door_outlined, l10n.roomTipDoor),
        const SizedBox(height: 16),
        Text(
          l10n.roomPrivacy,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({required this.photo, this.height = 220});

  final RoomPhoto photo;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.memory(photo.bytes, fit: BoxFit.cover),
      ),
    );
  }
}

class _AnalyzingView extends StatelessWidget {
  const _AnalyzingView({required this.photo});

  final RoomPhoto photo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _PhotoPreview(photo: photo, height: 260),
        const SizedBox(height: 28),
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 20),
        Text(
          l10n.roomReading,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          l10n.roomReadingText,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.state});

  final RoomScanState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoomScanCubit>();
    final l10n = context.l10n;
    final photo = state.photo;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (photo != null) ...[
          _PhotoPreview(photo: photo, height: 180),
          const SizedBox(height: 12),
        ],
        EmptyState(
          icon: Icons.image_not_supported_outlined,
          title: l10n.roomFailed,
          message: state.failure!.localized(l10n),
          action: Column(
            children: [
              if (photo != null)
                FilledButton.icon(
                  onPressed: cubit.retry,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.commonRetry),
                ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _pick(context, PhotoSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.roomAnotherPhoto),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({required this.state});

  final RoomScanState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final cubit = context.read<RoomScanCubit>();
    final analysis = state.analysis!;
    final set = state.furnitureSet;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        if (state.photo != null)
          _PhotoPreview(photo: state.photo!, height: 170),
        const SizedBox(height: 14),
        RoomSummaryCard(
          analysis: analysis,
          onRoomType: cubit.setRoomType,
          onStyle: cubit.setStyle,
          onDimensions: cubit.setDimensions,
        ),
        const SizedBox(height: 22),
        Text(l10n.roomSetTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          l10n.roomSetFor(
            analysis.roomType.label(l10n),
            analysis.style.label(l10n),
            analysis.dimensions.label,
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        if (set.isEmpty)
          EmptyState(
            icon: Icons.chair_outlined,
            title: l10n.roomNothingFits,
            message: l10n.roomNothingFitsText,
          )
        else ...[
          _FloorUsage(set: set, analysis: analysis),
          const SizedBox(height: 12),
          for (var i = 0; i < set.slots.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SlotCard(
                slot: set.slots[i],
                onSelect: (candidate) => cubit.selectCandidate(i, candidate),
                onOpen: (item) => Navigator.of(context).pushNamed(
                  Routes.productDetails,
                  arguments: ProductDetailsArgs(
                    productId: item.product.id,
                    heroTag: 'room-${item.product.id}',
                  ),
                ),
              ),
            ),
        ],
        for (final slot in set.unfilled)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.roomSlotUnfilled(slot.kind.label(l10n)),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FloorUsage extends StatelessWidget {
  const _FloorUsage({required this.set, required this.analysis});

  final FurnitureSet set;
  final RoomAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final usage = set.floorUsage(analysis.dimensions);
    final percent = '${(usage * 100).round()}';
    final crowded = usage > FitChecker.maxFloorUsage;
    final color = crowded ? AppColors.warning : AppColors.success;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: usage.clamp(0.0, 1.0),
            minHeight: 8,
            color: color,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          crowded ? l10n.roomFloorCrowded(percent) : l10n.roomFloorOk(percent),
          style: theme.textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _AddAllBar extends StatelessWidget {
  const _AddAllBar({required this.furnitureSet});

  final FurnitureSet furnitureSet;

  Future<void> _addAll(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    final pieces = furnitureSet.pieceCount;
    await context.read<CartCubit>().addAll([
      for (final slot in furnitureSet.chosen)
        CartAddition(
          slot.selected.product,
          color: slot.selected.color,
          quantity: slot.selected.quantity,
        ),
    ]);
    navigator.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.roomPiecesAdded(pieces))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.roomSetTotal, style: theme.textTheme.bodySmall),
                Text(
                  formatMoney(furnitureSet.totalPrice),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _addAll(context),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text(l10n.roomAddAll),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
