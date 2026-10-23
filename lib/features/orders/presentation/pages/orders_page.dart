import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/error/failure_messages.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/core/utils/formatters.dart';
import 'package:furniture_store/core/widgets/app_image.dart';
import 'package:furniture_store/core/widgets/empty_state.dart';
import 'package:furniture_store/core/widgets/failure_view.dart';
import 'package:furniture_store/features/orders/domain/entities/order.dart';
import 'package:furniture_store/features/orders/domain/entities/order_status.dart';
import 'package:furniture_store/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:furniture_store/features/orders/presentation/cubit/orders_state.dart';
import 'package:furniture_store/features/orders/presentation/l10n/order_labels.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.ordersTitle)),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listenWhen: (a, b) => a.failure != b.failure && b.failure != null,
        listener: (context, state) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(state.failure!.localized(l10n))),
          ),
        builder: (context, state) {
          if (state.status.isLoading && state.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == LoadStatus.failure && state.orders.isEmpty) {
            return FailureView(
              failure: state.failure!,
              onRetry: context.read<OrdersCubit>().load,
            );
          }
          if (state.orders.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_outlined,
              title: l10n.ordersEmpty,
              message: l10n.ordersEmptyText,
            );
          }
          return RefreshIndicator(
            onRefresh: context.read<OrdersCubit>().load,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: state.orders.length,
              itemBuilder: (_, i) => _OrderCard(order: state.orders[i]),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          l10n.ordersNumber(order.number),
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Text(
          '${formatDateTime(order.createdAt, context.languageCode)} · '
          '${l10n.ordersItems(order.itemCount)} · ${formatMoney(order.total)}',
        ),
        trailing: _StatusChip(status: order.status),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          for (final line in order.lines)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: AppImage(
                line.image,
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(line.name),
              subtitle: Text(
                '${line.color} · ${line.quantity} × ${formatMoney(line.price)}',
              ),
            ),
          const Divider(height: 20),
          if (order.discount > 0)
            _Row(l10n.cartDiscount, '−${formatMoney(order.discount)}'),
          _Row(
            l10n.cartDelivery,
            order.delivery == 0 ? l10n.commonFree : formatMoney(order.delivery),
          ),
          _Row(l10n.ordersPayment, order.paymentMethod.label(l10n)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              order.address.formatted,
              style: theme.textTheme.bodySmall,
            ),
          ),
          if (order.address.location != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    l10n.ordersOnMap,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (order.canCancel) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _confirmCancel(context),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
                icon: const Icon(Icons.cancel_outlined),
                label: Text(l10n.ordersCancel),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final cubit = context.read<OrdersCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.ordersCancelTitle),
        content: Text(context.l10n.ordersCancelText(order.number)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.ordersKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.ordersCancel),
          ),
        ],
      ),
    );
    if (ok ?? false) await cubit.cancel(order);
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cancelled = status == OrderStatus.cancelled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cancelled ? scheme.errorContainer : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label(context.l10n),
        style: TextStyle(
          color: cancelled
              ? scheme.onErrorContainer
              : scheme.onPrimaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children: [Text(label), const Spacer(), Text(value)]),
  );
}
