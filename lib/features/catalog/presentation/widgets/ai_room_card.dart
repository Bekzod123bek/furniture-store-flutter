import 'package:flutter/material.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/router/routes.dart';
import 'package:furniture_store/core/theme/app_colors.dart';

/// Eye-catching entry point of the "furnish my room from a photo" feature.
class AiRoomCard extends StatelessWidget {
  const AiRoomCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    void open() => Navigator.of(context).pushNamed(Routes.roomScan);
    return Semantics(
      button: true,
      label: l10n.homeRoomCardTitle,
      child: Material(
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: const BoxDecoration(gradient: AppColors.aiGradient),
          child: InkWell(
            onTap: open,
            child: Stack(
              children: [
                const Positioned(
                  right: -18,
                  bottom: -22,
                  child: Icon(
                    Icons.weekend_rounded,
                    size: 128,
                    color: Color(0x26FFFFFF),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.homeRoomCardTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(right: 56),
                        child: Text(
                          l10n.homeRoomCardText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: open,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.brand,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        icon: const Icon(Icons.photo_camera_outlined, size: 18),
                        label: Text(l10n.homeRoomCardAction),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
