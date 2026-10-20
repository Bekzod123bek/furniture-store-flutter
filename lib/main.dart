import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/auth_cubit.dart';
import 'features/auth/login_page.dart';
import 'features/auth/onboarding_page.dart';
import 'features/shop/presentation/cubit/cart_cubit.dart';
import 'features/shop/presentation/cubit/catalog_cubit.dart';
import 'features/shop/presentation/cubit/favorites_cubit.dart';
import 'features/shop/presentation/cubit/orders_cubit.dart';
import 'features/shop/presentation/pages/main_shell.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const FurnitureStoreApp());
}

class FurnitureStoreApp extends StatelessWidget {
  const FurnitureStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<CatalogCubit>()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()),
        BlocProvider(create: (_) => sl<CartCubit>()),
        BlocProvider(create: (_) => sl<OrdersCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          title: 'Furniture Store',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          home: BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (a, b) => a.status != b.status,
            builder: (context, state) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: switch (state.status) {
                AuthStatus.onboarding => const OnboardingPage(),
                AuthStatus.signedOut => const LoginPage(),
                AuthStatus.signedIn => const MainShell(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
