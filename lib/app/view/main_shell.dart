import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/app/view/widgets/app_nav_bar.dart';
import 'package:furniture_store/core/error/failure_messages.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/router/routes.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:furniture_store/features/cart/presentation/cubit/cart_state.dart';
import 'package:furniture_store/features/cart/presentation/pages/cart_page.dart';
import 'package:furniture_store/features/catalog/presentation/pages/home_page.dart';
import 'package:furniture_store/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:furniture_store/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:furniture_store/features/favorites/presentation/pages/favorites_page.dart';
import 'package:furniture_store/features/profile/presentation/pages/profile_page.dart';

/// The four main tabs with the floating navigation bar.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _home = 0;
  static const _favorites = 1;

  int _index = _home;

  void _go(int index) => setState(() => _index = index);

  void _showFailure(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cartCount = context.select<CartCubit, int>((c) => c.state.cart.count);
    // Saving the cart or favorites can fail in the background; tell the user
    // once, here, instead of in every widget that changes them.
    return MultiBlocListener(
      listeners: [
        BlocListener<CartCubit, CartState>(
          listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
          listener: (context, state) =>
              _showFailure(context, state.failure!.localized(l10n)),
        ),
        BlocListener<FavoritesCubit, FavoritesState>(
          listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
          listener: (context, state) =>
              _showFailure(context, state.failure!.localized(l10n)),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            const HomePage(),
            FavoritesPage(onBrowse: () => _go(_home)),
            CartPage(onBrowse: () => _go(_home)),
            ProfilePage(onOpenFavorites: () => _go(_favorites)),
          ],
        ),
        bottomNavigationBar: AppNavBar(
          selectedIndex: _index,
          onSelected: _go,
          centerLabel: l10n.navScan,
          onCenterPressed: () =>
              Navigator.of(context).pushNamed(Routes.roomScan),
          items: [
            AppNavItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: l10n.navHome,
            ),
            AppNavItem(
              icon: Icons.favorite_border_rounded,
              selectedIcon: Icons.favorite_rounded,
              label: l10n.navFavorites,
            ),
            AppNavItem(
              icon: Icons.shopping_bag_outlined,
              selectedIcon: Icons.shopping_bag,
              label: l10n.navCart,
              badgeCount: cartCount,
            ),
            AppNavItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
