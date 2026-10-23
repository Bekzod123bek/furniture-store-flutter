import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:furniture_store/app/di/injection.dart';
import 'package:furniture_store/app/router/app_router.dart';
import 'package:furniture_store/app/view/app_gate.dart';
import 'package:furniture_store/app/view/session_scope.dart';
import 'package:furniture_store/core/theme/app_theme.dart';
import 'package:furniture_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furniture_store/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:furniture_store/features/settings/domain/entities/app_settings.dart';
import 'package:furniture_store/features/settings/domain/entities/theme_preference.dart';
import 'package:furniture_store/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

class FurnitureStoreApp extends StatelessWidget {
  const FurnitureStoreApp({super.key});

  /// Used when the phone language is not one of ours.
  static const fallbackLocale = Locale('uz');

  @override
  Widget build(BuildContext context) {
    // These cubits live as long as the app, so they are provided with
    // `.value` and never closed by the widget tree.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<SettingsCubit>()),
        BlocProvider.value(value: sl<OnboardingCubit>()),
        BlocProvider.value(value: sl<AuthCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: switch (settings.theme) {
            ThemePreference.system => ThemeMode.system,
            ThemePreference.light => ThemeMode.light,
            ThemePreference.dark => ThemeMode.dark,
          },
          locale: context.read<SettingsCubit>().locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (device, supported) {
            for (final locale in supported) {
              if (locale.languageCode == device?.languageCode) return locale;
            }
            return fallbackLocale;
          },
          onGenerateRoute: AppRouter.onGenerateRoute,
          // The session scope wraps the Navigator, so every pushed page can
          // reach the cart, favorites and catalog.
          builder: (context, child) => SessionScope(child: child!),
          home: const AppGate(),
        ),
      ),
    );
  }
}
