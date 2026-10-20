import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/format.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities.dart';
import '../cubit/orders_cubit.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: BlocBuilder<OrdersCubit, List<Order>>(
        builder: (context, orders) {
          if (orders.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              message: 'Your placed orders will show up here.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final order = orders[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  shape: const Border(),
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  title: Text(
                    'Order ${order.id}',
                    style: theme.textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    '${formatDate(order.date)} · ${order.itemCount} items · ${money(order.total)}',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Processing',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
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
                          '${line.color} · ${line.quantity} × ${money(line.price)}',
                        ),
                      ),
                    const Divider(height: 20),
                    _Row('Discount', '−${money(order.discount)}'),
                    _Row(
                      'Delivery',
                      order.delivery == 0 ? 'Free' : money(order.delivery),
                    ),
                    _Row('Payment', order.paymentMethod),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        order.address,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
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
