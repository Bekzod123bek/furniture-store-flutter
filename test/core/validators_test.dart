import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/utils/validators.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

void main() {
  final validators = Validators(lookupAppLocalizations(const Locale('en')));

  group('Validators', () {
    test('email', () {
      expect(validators.email('bekzod@example.com'), isNull);
      expect(validators.email('  bekzod@example.com  '), isNull);
      expect(validators.email('bekzod'), isNotNull);
      expect(validators.email('a@b'), isNotNull);
      expect(validators.email(null), isNotNull);
      expect(Validators.isEmail('a@b.uz'), isTrue);
    });

    test('password needs at least 6 characters', () {
      expect(validators.password('12345'), 'At least 6 characters');
      expect(validators.password('123456'), isNull);
    });

    test('phone needs at least 9 digits and ignores formatting', () {
      expect(validators.phone('+998 90 123 45 67'), isNull);
      expect(validators.phone('12345678'), isNotNull);
      expect(validators.phone(''), isNotNull);
    });

    test('required and name', () {
      expect(validators.required('  '), isNotNull);
      expect(validators.required('x'), isNull);
      expect(validators.name('A'), isNotNull);
      expect(validators.name('Al'), isNull);
    });

    test('messages follow the language', () {
      final uz = Validators(lookupAppLocalizations(const Locale('uz')));
      final ru = Validators(lookupAppLocalizations(const Locale('ru')));
      expect(uz.required(''), 'Toʻldirish shart');
      expect(ru.required(''), 'Обязательное поле');
    });
  });
}
