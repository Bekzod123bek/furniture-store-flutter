import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/auth_cubit.dart';
import '../../domain/entities.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/orders_cubit.dart';
import 'orders_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onOpenFavorites});

  final VoidCallback onOpenFavorites;

  Future<void> _confirmSignOut(BuildContext context) async {
    final auth = context.read<AuthCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Your cart, favorites and orders stay on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (ok ?? false) await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthCubit>().state;
    final orders = context.select<OrdersCubit, int>((c) => c.state.length);
    final favorites = context
        .select<FavoritesCubit, List<Product>>((c) => c.state)
        .length;
    final dark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      auth.initials,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auth.name, style: theme.textTheme.titleLarge),
                        Text(
                          auth.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Stat(label: 'Orders', value: '$orders'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Stat(label: 'Favorites', value: '$favorites'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: const Text('My orders'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const OrdersPage()),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_border_rounded),
                  title: const Text('Favorites'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onOpenFavorites,
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark mode'),
                  value: dark,
                  onChanged: (_) =>
                      context.read<ThemeCubit>().toggle(theme.brightness),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About this app'),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'Furniture Store',
                    applicationVersion: '1.0.0',
                    children: const [
                      Text(
                        'A demo Flutter project with sample data. '
                        'Photos: Unsplash.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _confirmSignOut(context),
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
