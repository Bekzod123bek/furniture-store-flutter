import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../cubit/cart_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, items) {
          if (items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (_, i) {
              final item = items[i];
              final cart = context.read<CartCubit>();
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 48,
                  height: 48,
                  color: Color(item.product.colorValue),
                ),
                title: Text(item.product.name),
                subtitle: Text('\$${item.product.price} each'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Remove one',
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => cart.decrease(item.product),
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      tooltip: 'Add one',
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => cart.add(item.product),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, items) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: items.isEmpty
                  ? null
                  : () {
                      final total = context.read<CartCubit>().total;
                      context.read<CartCubit>().clear();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Order placed: \$$total')),
                      );
                    },
              child: Text('Checkout  •  \$${context.read<CartCubit>().total}'),
            ),
          ),
        ),
      ),
    );
  }
}
