import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/format.dart';
import '../../../auth/auth_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/orders_cubit.dart';
import 'cart_page.dart';

enum _Delivery { standard, express }

const _expressFee = 40;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: context.read<AuthCubit>().state.name,
  );
  final _phone = TextEditingController();
  final _city = TextEditingController(text: 'Tashkent');
  final _address = TextEditingController();
  _Delivery _delivery = _Delivery.standard;
  String _payment = 'Cash on delivery';
  bool _placing = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _city.dispose();
    _address.dispose();
    super.dispose();
  }

  int get _extra => _delivery == _Delivery.express ? _expressFee : 0;

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _placing = true);
    final cartCubit = context.read<CartCubit>();
    final cart = cartCubit.state;
    final navigator = Navigator.of(context);
    final order = await context.read<OrdersCubit>().place(
      cart: cart,
      delivery: cart.delivery + _extra,
      address:
          '${_name.text.trim()}, ${_phone.text.trim()}\n'
          '${_address.text.trim()}, ${_city.text.trim()}',
      paymentMethod: _payment,
    );
    await cartCubit.clear();
    navigator.pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => OrderSuccessPage(orderId: order.id, total: order.total),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text('Delivery address', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: '+998 90 123 45 67',
              ),
              validator: (v) =>
                  (v ?? '').replaceAll(RegExp(r'\D'), '').length < 9
                  ? 'Enter a valid phone number'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _city,
              decoration: const InputDecoration(labelText: 'City'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Street, house, apartment',
              ),
              validator: _required,
            ),
            const SizedBox(height: 24),
            Text('Delivery', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<_Delivery>(
              segments: [
                ButtonSegment(
                  value: _Delivery.standard,
                  icon: const Icon(Icons.local_shipping_outlined),
                  label: Text(
                    cart.delivery == 0
                        ? 'Standard · Free'
                        : 'Standard · ${money(cart.delivery)}',
                  ),
                ),
                const ButtonSegment(
                  value: _Delivery.express,
                  icon: Icon(Icons.bolt),
                  label: Text('Express · +\$$_expressFee'),
                ),
              ],
              selected: {_delivery},
              onSelectionChanged: (s) => setState(() => _delivery = s.first),
            ),
            const SizedBox(height: 24),
            Text('Payment', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'Cash on delivery',
                  icon: Icon(Icons.payments_outlined),
                  label: Text('Cash'),
                ),
                ButtonSegment(
                  value: 'Card on delivery',
                  icon: Icon(Icons.credit_card),
                  label: Text('Card on delivery'),
                ),
              ],
              selected: {_payment},
              onSelectionChanged: (s) => setState(() => _payment = s.first),
            ),
            const SizedBox(height: 8),
            Text(
              'Demo app: no payment is taken and no order is sent anywhere.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text('Summary', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            CartSummary(cart: cart, extraDelivery: _extra),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton(
            onPressed: _placing || cart.items.isEmpty ? null : _placeOrder,
            child: _placing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Text('Place order · ${money(cart.total + _extra)}'),
          ),
        ),
      ),
    );
  }

  static String? _required(String? v) =>
      (v ?? '').trim().isEmpty ? 'Required' : null;
}

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.total,
  });

  final String orderId;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 72,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text('Order placed!', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(
                'Order $orderId · ${money(total)}\n'
                'You can follow it in Profile → My orders.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Continue shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
