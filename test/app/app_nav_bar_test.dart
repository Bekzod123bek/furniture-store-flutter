import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/app/view/widgets/app_nav_bar.dart';
import 'package:furniture_store/core/l10n/l10n.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required Locale locale,
    required ValueChanged<int> onSelected,
    required VoidCallback onCenter,
    int cartCount = 0,
  }) => tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          final l10n = context.l10n;
          return Scaffold(
            bottomNavigationBar: AppNavBar(
              selectedIndex: 0,
              onSelected: onSelected,
              centerLabel: l10n.navScan,
              onCenterPressed: onCenter,
              items: [
                AppNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: l10n.navHome,
                ),
                AppNavItem(
                  icon: Icons.favorite_border,
                  selectedIcon: Icons.favorite,
                  label: l10n.navFavorites,
                ),
                AppNavItem(
                  icon: Icons.shopping_bag_outlined,
                  selectedIcon: Icons.shopping_bag,
                  label: l10n.navCart,
                  badgeCount: cartCount,
                ),
                AppNavItem(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: l10n.navProfile,
                ),
              ],
            ),
          );
        },
      ),
    ),
  );

  testWidgets('shows Uzbek labels, the cart badge and reacts to taps', (
    tester,
  ) async {
    final tapped = <int>[];
    var centerTaps = 0;
    await pump(
      tester,
      locale: const Locale('uz'),
      onSelected: tapped.add,
      onCenter: () => centerTaps++,
      cartCount: 3,
    );

    expect(find.text('Asosiy'), findsOneWidget);
    expect(find.text('Savatcha'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.text('Savatcha'));
    await tester.tap(find.text('Profil'));
    await tester.tap(find.byIcon(Icons.auto_awesome));
    expect(tapped, [2, 3]);
    expect(centerTaps, 1);
  });

  testWidgets('fits a small phone in Russian without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pump(
      tester,
      locale: const Locale('ru'),
      onSelected: (_) {},
      onCenter: () {},
    );
    expect(find.text('Избранное'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
