import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';
import 'package:furniture_store/features/cart/presentation/l10n/cart_labels.dart';
import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_filter.dart';
import 'package:furniture_store/features/catalog/presentation/l10n/catalog_labels.dart';
import 'package:furniture_store/features/orders/domain/entities/order_status.dart';
import 'package:furniture_store/features/orders/domain/entities/payment_method.dart';
import 'package:furniture_store/features/orders/presentation/l10n/order_labels.dart';
import 'package:furniture_store/features/room_design/domain/entities/match_reason.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_type.dart';
import 'package:furniture_store/features/room_design/domain/entities/slot_kind.dart';
import 'package:furniture_store/features/room_design/presentation/l10n/room_labels.dart';
import 'package:furniture_store/features/settings/domain/entities/app_language.dart';
import 'package:furniture_store/features/settings/domain/entities/theme_preference.dart';
import 'package:furniture_store/features/settings/presentation/l10n/settings_labels.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

void main() {
  const codes = ['uz', 'ru', 'en'];

  test('every language has every text, and none is left empty', () {
    Map<String, dynamic> read(String code) =>
        jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync())
            as Map<String, dynamic>;
    Set<String> keys(Map<String, dynamic> arb) =>
        arb.keys.where((k) => !k.startsWith('@')).toSet();

    final english = read('en');
    for (final code in codes) {
      final arb = read(code);
      expect(keys(arb), keys(english), reason: code);
      for (final key in keys(arb)) {
        expect((arb[key] as String).trim(), isNotEmpty, reason: '$code.$key');
      }
    }
  });

  test('Uzbek and Russian texts are really translated', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final uz = lookupAppLocalizations(const Locale('uz'));
    final ru = lookupAppLocalizations(const Locale('ru'));
    expect(uz.navHome, isNot(en.navHome));
    expect(ru.navHome, isNot(en.navHome));
    expect(uz.checkoutPlace(r'$10'), contains(r'$10'));
    expect(ru.homeResults(3), '3 результата');
    expect(ru.homeResults(5), '5 результатов');
    expect(uz.homeResults(5), '5 ta natija');
  });

  test('every enum has a label in every language', () {
    for (final code in codes) {
      final l10n = lookupAppLocalizations(Locale(code));
      final labels = [
        for (final v in ProductCategory.values) v.label(l10n),
        for (final v in DesignStyle.values) v.label(l10n),
        for (final v in SortOption.values) v.label(l10n),
        for (final v in RoomType.values) v.label(l10n),
        for (final v in SlotKind.values) v.label(l10n),
        for (final v in OrderStatus.values) v.label(l10n),
        for (final v in PaymentMethod.values) v.label(l10n),
        for (final v in DeliveryMethod.values) v.label(l10n),
        for (final v in ThemePreference.values) v.label(l10n),
        for (final v in AppLanguage.values) v.label(l10n),
      ];
      expect(labels.every((l) => l.isNotEmpty), isTrue, reason: code);
    }
  });

  test('match reasons become sentences with their values', () {
    final uz = lookupAppLocalizations(const Locale('uz'));
    final en = lookupAppLocalizations(const Locale('en'));
    expect(
      const SameStyleReason(DesignStyle.scandinavian).text(uz),
      contains('Skandinav'),
    );
    expect(
      const ColorReason('Sand', ['white', 'beige']).text(en),
      'Sand goes with your white and beige tones',
    );
    expect(const ColorReason('Sand', []).text(en), contains('Sand'));
    expect(
      const SizeReason(widthCm: 190, floorPercent: 8).text(en),
      '190 cm wide, about 8% of the floor',
    );
    expect(const NoFloorSpaceReason().text(uz), isNotEmpty);
  });
}
