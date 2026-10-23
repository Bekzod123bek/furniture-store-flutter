import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/constants/app_info.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/router/routes.dart';
import 'package:furniture_store/core/theme/app_colors.dart';
import 'package:furniture_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furniture_store/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:furniture_store/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:furniture_store/features/settings/domain/entities/app_language.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';
import 'package:furniture_store/features/settings/domain/entities/theme_preference.dart';
import 'package:furniture_store/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:furniture_store/features/settings/presentation/l10n/settings_labels.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onOpenFavorites});

  final VoidCallback onOpenFavorites;

  Future<void> _confirmSignOut(BuildContext context) async {
    final auth = context.read<AuthCubit>();
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileSignOutTitle),
        content: Text(l10n.profileSignOutText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.profileSignOut),
          ),
        ],
      ),
    );
    if (ok ?? false) await auth.signOut();
  }

  Future<void> _chooseLanguage(BuildContext context) async {
    final settings = context.read<SettingsCubit>();
    final l10n = context.l10n;
    final chosen = await showModalBottomSheet<AppLanguage>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                l10n.profileLanguage,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final language in AppLanguage.values)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: Text(language.label(l10n)),
                trailing: settings.state.language == language
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, language),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (chosen != null) await settings.setLanguage(chosen);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final user = context.watch<AuthCubit>().state.user;
    final orders = context.select<OrdersCubit, int>(
      (c) => c.state.orders.length,
    );
    final favorites = context.select<FavoritesCubit, int>(
      (c) => c.state.products.length,
    );
    final settings = context.watch<SettingsCubit>().state;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _UserCard(
            initials: user?.initials ?? '?',
            name: user?.name ?? '',
            email: user?.email ?? '',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: Icons.receipt_long_outlined,
                  label: l10n.profileOrders,
                  value: '$orders',
                  onTap: () => Navigator.of(context).pushNamed(Routes.orders),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Stat(
                  icon: Icons.favorite_border_rounded,
                  label: l10n.profileFavorites,
                  value: '$favorites',
                  onTap: onOpenFavorites,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.auto_awesome_outlined),
                  title: Text(l10n.profileFurnish),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pushNamed(Routes.roomScan),
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(l10n.profileMyOrders),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pushNamed(Routes.orders),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.profileLanguage),
                  subtitle: Text(settings.language.label(l10n)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _chooseLanguage(context),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.profileAbout),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: l10n.appName,
                    applicationVersion: AppInfo.version,
                    children: [Text(l10n.profileAboutText)],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ThemeCard(settings: settings),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _confirmSignOut(context),
            icon: const Icon(Icons.logout),
            label: Text(l10n.profileSignOut),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.initials,
    required this.name,
    required this.email,
  });

  final String initials;
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.brand,
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
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.dark_mode_outlined),
                const SizedBox(width: 12),
                Text(l10n.profileTheme, style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<ThemePreference>(
                showSelectedIcon: false,
                segments: [
                  for (final p in ThemePreference.values)
                    ButtonSegment(value: p, label: Text(p.label(l10n))),
                ],
                selected: {settings.theme},
                onSelectionChanged: (s) =>
                    context.read<SettingsCubit>().setTheme(s.first),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
