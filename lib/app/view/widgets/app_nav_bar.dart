import 'package:flutter/material.dart';
import 'package:furniture_store/core/theme/app_colors.dart';

/// One tab of [AppNavBar].
class AppNavItem {
  const AppNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int badgeCount;
}

/// Floating bottom bar: a rounded panel with four tabs and a raised round
/// button in the middle for the AI room feature.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.centerLabel,
    required this.onCenterPressed,
  }) : assert(items.length == 4);

  final List<AppNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final String centerLabel;
  final VoidCallback onCenterPressed;

  static const _barHeight = 66.0;
  static const _centerSize = 58.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    Widget tab(int i) => Expanded(
      child: _NavTab(
        item: items[i],
        selected: i == selectedIndex,
        onTap: () => onSelected(i),
      ),
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: SizedBox(
          height: _barHeight + 14,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: _barHeight,
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF221E19) : Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: dark ? 0.4 : 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    tab(0),
                    tab(1),
                    const SizedBox(width: _centerSize + 12),
                    tab(2),
                    tab(3),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: _CenterButton(
                  size: _centerSize,
                  label: centerLabel,
                  onPressed: onCenterPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    Widget icon = Icon(
      selected ? item.selectedIcon : item.icon,
      color: selected ? scheme.onPrimaryContainer : color,
      size: 24,
    );
    if (item.badgeCount > 0) {
      icon = Badge(label: Text('${item.badgeCount}'), child: icon);
    }
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: selected ? 54 : 40,
              height: 30,
              decoration: BoxDecoration(
                color: selected ? scheme.primaryContainer : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  const _CenterButton({
    required this.size,
    required this.label,
    required this.onPressed,
  });

  final double size;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: Material(
          shape: const CircleBorder(),
          elevation: 6,
          shadowColor: AppColors.brand.withValues(alpha: 0.5),
          child: Ink(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.aiGradient,
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
