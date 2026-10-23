import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/app/di/injection.dart';
import 'package:furniture_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:furniture_store/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:furniture_store/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:furniture_store/features/orders/presentation/cubit/orders_cubit.dart';

/// Creates the cubits that hold one user's data (catalog, favorites, cart,
/// orders). They are keyed by user id, so signing out or switching account
/// throws the old data away and loads the new user's data.
class SessionScope extends StatelessWidget {
  const SessionScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final uid = context.select<AuthCubit, String?>((c) => c.state.user?.uid);
    if (uid == null) return child;
    return MultiBlocProvider(
      key: ValueKey(uid),
      providers: [
        BlocProvider(create: (_) => sl<CatalogCubit>()..load()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()..load()),
        BlocProvider(create: (_) => sl<CartCubit>()..load()),
        BlocProvider(create: (_) => sl<OrdersCubit>()..load()),
      ],
      child: child,
    );
  }
}
