import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/error/failure_messages.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/router/route_args.dart';
import 'package:furniture_store/core/router/routes.dart';
import 'package:furniture_store/core/utils/formatters.dart';
import 'package:furniture_store/core/utils/validators.dart';
import 'package:furniture_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:furniture_store/features/cart/presentation/widgets/cart_summary.dart';
import 'package:furniture_store/features/location/domain/entities/place_address.dart';
import 'package:furniture_store/features/orders/domain/entities/payment_method.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';
import 'package:furniture_store/features/orders/presentation/cubit/checkout_cubit.dart';
import 'package:furniture_store/features/orders/presentation/cubit/checkout_state.dart';
import 'package:furniture_store/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:furniture_store/features/orders/presentation/widgets/delivery_point_card.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
    text: context.read<AuthCubit>().state.user?.name ?? '',
  );
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _street = TextEditingController();

  /// The point picked on the map, if any.
  PlaceAddress? _place;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_city.text.isEmpty) _city.text = context.l10n.checkoutDefaultCity;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _city.dispose();
    _street.dispose();
    super.dispose();
  }

  /// Fills the form with the address from the previous order.
  void _prefill(ShippingAddress address) {
    _name.text = address.fullName;
    _phone.text = address.phone;
    _city.text = address.city;
    _street.text = address.street;
    final point = address.location;
    if (point != null) {
      setState(
        () => _place = PlaceAddress(
          point: point,
          city: address.city,
          street: address.street,
        ),
      );
    }
  }

  Future<void> _pickOnMap() async {
    final result = await Navigator.of(context).pushNamed(
      Routes.locationPicker,
      arguments: LocationPickerArgs(initial: _place?.point),
    );
    if (!mounted || result is! PlaceAddress) return;
    setState(() => _place = result);
    // The map knows the street; keep the flat number the user typed.
    if (result.city.isNotEmpty) _city.text = result.city;
    if (result.street.isNotEmpty && !_street.text.contains(result.street)) {
      _street.text = result.street;
    }
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) return;
    context.read<CheckoutCubit>().placeOrder(
      cart: context.read<CartCubit>().state.cart,
      address: ShippingAddress(
        fullName: _name.text.trim(),
        phone: _phone.text.trim(),
        city: _city.text.trim(),
        street: _street.text.trim(),
        location: _place?.point,
      ),
    );
  }

  void _onState(BuildContext context, CheckoutState state) {
    final saved = state.savedAddress;
    if (saved != null && _street.text.isEmpty && _phone.text.isEmpty) {
      _prefill(saved);
    }
    final order = state.placedOrder;
    if (order != null) {
      context.read<CartCubit>().clear();
      context.read<OrdersCubit>().addPlaced(order);
      Navigator.of(context).pushReplacementNamed(
        Routes.orderSuccess,
        arguments: OrderSuccessArgs(
          orderNumber: order.number,
          total: order.total,
        ),
      );
      return;
    }
    final failure = state.failure;
    if (failure != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(failure.localized(context.l10n))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final validators = Validators(l10n);
    final cart = context.select<CartCubit, Cart>((c) => c.state.cart);
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listenWhen: (a, b) =>
          a.savedAddress != b.savedAddress ||
          a.placedOrder != b.placedOrder ||
          a.failure != b.failure,
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<CheckoutCubit>();
        return Scaffold(
          appBar: AppBar(title: Text(l10n.checkoutTitle)),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Text(l10n.checkoutAddress, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                DeliveryPointCard(place: _place, onPick: _pickOnMap),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  decoration: InputDecoration(labelText: l10n.loginFullName),
                  validator: validators.required,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  decoration: InputDecoration(
                    labelText: l10n.checkoutPhone,
                    hintText: l10n.checkoutPhoneHint,
                  ),
                  validator: validators.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _city,
                  autofillHints: const [AutofillHints.addressCity],
                  decoration: InputDecoration(labelText: l10n.checkoutCity),
                  validator: validators.required,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _street,
                  maxLines: 2,
                  autofillHints: const [AutofillHints.fullStreetAddress],
                  decoration: InputDecoration(labelText: l10n.checkoutStreet),
                  validator: validators.required,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.checkoutDeliveryTitle,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SegmentedButton<DeliveryMethod>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: DeliveryMethod.standard,
                      icon: const Icon(Icons.local_shipping_outlined),
                      label: Text(
                        cart.standardDelivery == 0
                            ? l10n.checkoutStandardFree
                            : l10n.checkoutStandardPrice(
                                formatMoney(cart.standardDelivery),
                              ),
                      ),
                    ),
                    ButtonSegment(
                      value: DeliveryMethod.express,
                      icon: const Icon(Icons.bolt),
                      label: Text(
                        l10n.checkoutExpress(
                          formatMoney(Cart.expressSurcharge),
                        ),
                      ),
                    ),
                  ],
                  selected: {state.delivery},
                  onSelectionChanged: (s) => cubit.setDelivery(s.first),
                ),
                const SizedBox(height: 24),
                Text(l10n.checkoutPayment, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                SegmentedButton<PaymentMethod>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: PaymentMethod.cashOnDelivery,
                      icon: const Icon(Icons.payments_outlined),
                      label: Text(l10n.checkoutCash),
                    ),
                    ButtonSegment(
                      value: PaymentMethod.cardOnDelivery,
                      icon: const Icon(Icons.credit_card),
                      label: Text(l10n.checkoutCard),
                    ),
                  ],
                  selected: {state.payment},
                  onSelectionChanged: (s) => cubit.setPayment(s.first),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.checkoutPayNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Text(l10n.checkoutSummary, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                CartSummary(cart: cart, delivery: state.delivery),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: FilledButton(
                onPressed: state.placing || cart.isEmpty ? null : _placeOrder,
                child: state.placing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : Text(
                        l10n.checkoutPlace(
                          formatMoney(cart.total(state.delivery)),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
