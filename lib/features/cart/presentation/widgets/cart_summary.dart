import 'package:flutter/material.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/theme/app_colors.dart';
import 'package:furniture_store/core/utils/formatters.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';

/// Subtotal, discount, delivery and total.
class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.cart,
    this.delivery = DeliveryMethod.standard,
  });

  final Cart cart;
  final DeliveryMethod delivery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final fee = cart.deliveryFee(delivery);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Line(l10n.cartSubtotal(cart.count), formatMoney(cart.subtotal)),
            if (cart.discount > 0)
              _Line(
                l10n.cartDiscount,
                '−${formatMoney(cart.discount)}',
                color: AppColors.success,
              ),
            _Line(
              l10n.cartDelivery,
              fee == 0 ? l10n.commonFree : formatMoney(fee),
            ),
            if (cart.amountToFreeDelivery > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.cartFreeDeliveryHint(
                      formatMoney(cart.amountToFreeDelivery),
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            const Divider(height: 24),
            _Line(
              l10n.commonTotal,
              formatMoney(cart.total(delivery)),
              bold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.bold = false, this.color});

  final String label;
  final String value;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = bold
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(
            value,
            style: style?.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
