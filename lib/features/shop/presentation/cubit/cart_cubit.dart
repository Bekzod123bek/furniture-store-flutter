import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super(const []);

  int get total => state.fold(0, (sum, i) => sum + i.subtotal);
  int get count => state.fold(0, (sum, i) => sum + i.quantity);

  void add(Product product) {
    final index = state.indexWhere((i) => i.product == product);
    if (index == -1) {
      emit([...state, CartItem(product: product, quantity: 1)]);
      return;
    }
    final updated = [...state];
    updated[index] = updated[index].copyWith(quantity: updated[index].quantity + 1);
    emit(updated);
  }

  void decrease(Product product) {
    final index = state.indexWhere((i) => i.product == product);
    if (index == -1) return;
    final item = state[index];
    final updated = [...state];
    if (item.quantity <= 1) {
      updated.removeAt(index);
    } else {
      updated[index] = item.copyWith(quantity: item.quantity - 1);
    }
    emit(updated);
  }

  void clear() => emit(const []);
}
