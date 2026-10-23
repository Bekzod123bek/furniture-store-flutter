import 'package:flutter/material.dart';
import 'package:furniture_store/core/error/failure_messages.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/widgets/empty_state.dart';

/// Full-area error message with a retry button.
class FailureView extends StatelessWidget {
  const FailureView({super.key, required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return EmptyState(
      icon: failure is NetworkFailure
          ? Icons.wifi_off_rounded
          : Icons.error_outline_rounded,
      title: l10n.commonCouldNotLoad,
      message: failure.localized(l10n),
      action: OutlinedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: Text(l10n.commonRetry),
      ),
    );
  }
}
