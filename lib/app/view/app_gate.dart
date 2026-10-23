import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/app/di/injection.dart';
import 'package:furniture_store/app/view/main_shell.dart';
import 'package:furniture_store/app/view/splash_page.dart';
import 'package:furniture_store/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:furniture_store/features/auth/presentation/cubit/auth_state.dart';
import 'package:furniture_store/features/auth/presentation/cubit/login_cubit.dart';
import 'package:furniture_store/features/auth/presentation/pages/login_page.dart';
import 'package:furniture_store/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:furniture_store/features/onboarding/presentation/pages/onboarding_page.dart';

/// Chooses the first screen: introduction, sign-in or the shop.
class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarded = context.watch<OnboardingCubit>().state;
    final status = context.select<AuthCubit, AuthStatus>((c) => c.state.status);

    final Widget page;
    if (!onboarded) {
      page = const OnboardingPage(key: ValueKey('onboarding'));
    } else {
      page = switch (status) {
        AuthStatus.unknown => const SplashPage(key: ValueKey('splash')),
        AuthStatus.signedOut => BlocProvider(
          key: const ValueKey('login'),
          create: (_) => sl<LoginCubit>(),
          child: const LoginPage(),
        ),
        AuthStatus.signedIn => const MainShell(key: ValueKey('shell')),
      };
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: page,
    );
  }
}
