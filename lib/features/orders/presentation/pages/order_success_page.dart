import 'package:flutter/material.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/router/route_args.dart';
import 'package:furniture_store/core/theme/app_colors.dart';
import 'package:furniture_store/core/utils/formatters.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key, required this.args});

  final OrderSuccessArgs args;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 72,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(l10n.successTitle, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(
                l10n.successText(args.orderNumber, formatMoney(args.total)),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                child: Text(l10n.successContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
