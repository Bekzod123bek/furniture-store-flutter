import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/format.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities.dart';
import '../cubit/cart_cubit.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cart) {
          if (cart.items.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Add something you like and it will appear here.',
              action: OutlinedButton(
                onPressed: onBrowse,
                child: const Text('Start shopping'),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              for (final item in cart.items) _CartTile(item: item),
              const SizedBox(height: 8),
              const _PromoField(),
              const SizedBox(height: 16),
              CartSummary(cart: cart),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cart) => cart.items.isEmpty
            ? const SizedBox.shrink()
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const CheckoutPage(),
                      ),
                    ),
                    child: Text('Checkout · ${money(cart.total)}'),
                  ),
                ),
              ),
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.read<CartCubit>();
    return Dismissible(
      key: ValueKey('${item.product.id}-${item.color.name}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) {
        cart.remove(item);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('${item.product.name} removed'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () => cart.add(
                  item.product,
                  color: item.color,
                  quantity: item.quantity,
                ),
              ),
            ),
          );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              AppImage(
                item.product.images.first,
                width: 84,
                height: 84,
                borderRadius: BorderRadius.circular(14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      maxLines: 1,
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
                            color: Color(item.color.value),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(item.color.name, style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      money(item.subtotal),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _SmallButton(
                    icon: Icons.add,
                    tooltip: 'Increase',
                    onTap: () => cart.setQuantity(item, item.quantity + 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${item.quantity}',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  _SmallButton(
                    icon: item.quantity == 1
                        ? Icons.delete_outline
                        : Icons.remove,
                    tooltip: item.quantity == 1 ? 'Remove' : 'Decrease',
                    onTap: () => cart.setQuantity(item, item.quantity - 1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 18),
          ),
        ),
      ),
    );
  }
}

class _PromoField extends StatefulWidget {
  const _PromoField();

  @override
  State<_PromoField> createState() => _PromoFieldState();
}

class _PromoFieldState extends State<_PromoField> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply() {
    final ok = context.read<CartCubit>().applyPromo(_controller.text);
    setState(() => _error = ok ? null : 'Unknown code. Try SALE10');
    if (ok) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final code = context.select<CartCubit, String?>((c) => c.state.promoCode);
    if (code != null) {
      return Card(
        child: ListTile(
          leading: const Icon(
            Icons.local_offer_outlined,
            color: Color(0xFF2E7D32),
          ),
          title: Text('$code applied'),
          subtitle: Text(
            '${(promoCodes[code]! * 100).round()}% off your items',
          ),
          trailing: IconButton(
            tooltip: 'Remove code',
            icon: const Icon(Icons.close),
            onPressed: () {
              _controller.clear();
              context.read<CartCubit>().removePromo();
            },
          ),
        ),
      );
    }
    return TextField(
      controller: _controller,
      textCapitalization: TextCapitalization.characters,
      onSubmitted: (_) => _apply(),
      decoration: InputDecoration(
        hintText: 'Promo code',
        prefixIcon: const Icon(Icons.local_offer_outlined),
        errorText: _error,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(6),
          child: TextButton(onPressed: _apply, child: const Text('Apply')),
        ),
      ),
    );
  }
}

/// Subtotal, discount, delivery and total.
class CartSummary extends StatelessWidget {
  const CartSummary({super.key, required this.cart, this.extraDelivery = 0});

  final CartState cart;
  final int extraDelivery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delivery = cart.delivery + extraDelivery;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Line('Subtotal (${cart.count} items)', money(cart.subtotal)),
            if (cart.discount > 0)
              _Line(
                'Discount',
                '−${money(cart.discount)}',
                color: const Color(0xFF2E7D32),
              ),
            _Line('Delivery', delivery == 0 ? 'Free' : money(delivery)),
            if (cart.delivery > 0 && cart.subtotal < freeDeliveryFrom)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Add ${money(freeDeliveryFrom - cart.subtotal)} more for free delivery',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            const Divider(height: 24),
            _Line('Total', money(cart.total + extraDelivery), bold: true),
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
