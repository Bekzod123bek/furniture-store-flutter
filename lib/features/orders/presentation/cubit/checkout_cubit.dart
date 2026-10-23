import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/core/utils/id_generator.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';
import 'package:furniture_store/features/orders/domain/entities/payment_method.dart';
import 'package:furniture_store/features/orders/domain/entities/shipping_address.dart';
import 'package:furniture_store/features/orders/domain/usecases/get_saved_address.dart';
import 'package:furniture_store/features/orders/domain/usecases/place_order.dart';
import 'package:furniture_store/features/orders/presentation/cubit/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required PlaceOrder placeOrder,
    required GetSavedAddress getSavedAddress,
    required IdGenerator idGenerator,
    DateTime Function()? clock,
  }) : _place = placeOrder,
       _getSavedAddress = getSavedAddress,
       _orderId = idGenerator.newId(),
       _clock = clock ?? DateTime.now,
       super(const CheckoutState());

  final PlaceOrder _place;
  final GetSavedAddress _getSavedAddress;
  final DateTime Function() _clock;

  /// One id per checkout screen: pressing "Place order" again after a failed
  /// attempt can never create a second order.
  final String _orderId;

  /// Loads the address from the previous order to pre-fill the form.
  Future<void> loadSavedAddress() async {
    final result = await _getSavedAddress(const NoParams());
    if (isClosed) return;
    final address = result.valueOrNull;
    if (address != null) emit(state.copyWith(savedAddress: address));
  }

  void setDelivery(DeliveryMethod method) =>
      emit(state.copyWith(delivery: method));

  void setPayment(PaymentMethod method) =>
      emit(state.copyWith(payment: method));

  Future<void> placeOrder({
    required Cart cart,
    required ShippingAddress address,
  }) async {
    if (state.placing || state.placedOrder != null) return;
    emit(state.copyWith(placing: true, failure: () => null));
    final result = await _place(
      PlaceOrderParams(
        orderId: _orderId,
        cart: cart,
        delivery: state.delivery,
        address: address,
        payment: state.payment,
        now: _clock(),
      ),
    );
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(placing: false, placedOrder: value));
      case Err(:final failure):
        emit(state.copyWith(placing: false, failure: () => failure));
    }
  }
}
