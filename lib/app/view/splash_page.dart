import 'package:flutter/material.dart';

/// Shown for a moment while the saved sign-in is restored.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Icon(Icons.chair_rounded, color: scheme.onPrimary, size: 38),
        ),
      ),
    );
  }
}
