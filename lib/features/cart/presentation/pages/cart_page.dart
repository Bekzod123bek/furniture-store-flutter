import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/router/routes.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/state/load_status.dart';
import 'package:furniture_store/core/theme/app_colors.dart';
import 'package:furniture_store/core/utils/formatters.dart';
import 'package:furniture_store/core/widgets/app_image.dart';
import 'package:furniture_store/core/widgets/empty_state.dart';
import 'package:furniture_store/core/widgets/failure_view.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_item.dart';
import 'package:furniture_store/features/cart/domain/entities/promo_codes.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_state.dart';
import 'package:furniture_store/features/cart/presentation/widgets/cart_summary.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cart = state.cart;
        final l10n = context.l10n;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.cartTitle)),
          body: _body(context, state),
          bottomNavigationBar: cart.isEmpty
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(Routes.checkout),
                      child: Text(l10n.cartCheckout(formatMoney(cart.total()))),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _body(BuildContext context, CartState state) {
    final cart = state.cart;
    final l10n = context.l10n;
    if (state.status.isLoading && cart.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == LoadStatus.failure && cart.isEmpty) {
      return FailureView(
        failure: state.failure!,
        onRetry: context.read<CartCubit>().load,
      );
    }
    if (cart.isEmpty) {
      return EmptyState(
        icon: Icons.shopping_bag_outlined,
        title: l10n.cartEmpty,
        message: l10n.cartEmptyText,
        action: OutlinedButton(
          onPressed: onBrowse,
          child: Text(l10n.cartStartShopping),
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
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
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
              content: Text(l10n.cartRemoved(item.product.name)),
              action: SnackBarAction(
                label: l10n.commonUndo,
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
                            color: Color(item.color.argb),
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
                      formatMoney(item.subtotal),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _QuantityButton(
                    icon: Icons.add,
                    tooltip: l10n.commonIncrease,
                    onTap: item.quantity >= Cart.maxQuantityPerLine
                        ? null
                        : () => cart.setQuantity(item, item.quantity + 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '${item.quantity}',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  _QuantityButton(
                    icon: item.quantity == 1
                        ? Icons.delete_outline
                        : Icons.remove,
                    tooltip: item.quantity == 1
                        ? l10n.commonRemove
                        : l10n.commonDecrease,
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

/// A 44 px tap target with a smaller visual button.
class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      style: IconButton.styleFrom(
        minimumSize: const Size(44, 40),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, size: 20),
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
    setState(() => _error = ok ? null : context.l10n.cartPromoUnknown);
    if (ok) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final code = context.select<CartCubit, String?>(
      (c) => c.state.cart.promoCode,
    );
    if (code != null) {
      final percent = ((PromoCodes.rateFor(code) ?? 0) * 100).round();
      return Card(
        child: ListTile(
          leading: const Icon(
            Icons.local_offer_outlined,
            color: AppColors.success,
          ),
          title: Text(l10n.cartPromoApplied(code)),
          subtitle: Text(l10n.cartPromoOff('$percent')),
          trailing: IconButton(
            tooltip: l10n.cartPromoRemove,
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
        hintText: l10n.cartPromoHint,
        prefixIcon: const Icon(Icons.local_offer_outlined),
        errorText: _error,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(6),
          child: TextButton(onPressed: _apply, child: Text(l10n.commonApply)),
        ),
      ),
    );
  }
}
