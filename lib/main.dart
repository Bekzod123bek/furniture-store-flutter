import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/shop/presentation/cubit/cart_cubit.dart';
import 'features/shop/presentation/cubit/catalog_cubit.dart';
import 'features/shop/presentation/pages/catalog_page.dart';
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
        BlocProvider(create: (_) => sl<CatalogCubit>()),
        BlocProvider.value(value: sl<CartCubit>()),
      ],
      child: MaterialApp(
        title: 'Furniture Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFFB08968),
          useMaterial3: true,
        ),
        home: const CatalogPage(),
      ),
    );
  }
}
