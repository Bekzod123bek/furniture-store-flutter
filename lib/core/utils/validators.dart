import 'package:flutter/widgets.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

/// Form field validators. Each returns an error text in the current
/// language, or `null` when the value is valid.
class Validators {
  const Validators(this._l10n);

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static const minPasswordLength = 6;

  final AppLocalizations _l10n;

  static bool isEmail(String value) => _emailPattern.hasMatch(value.trim());

  static bool isPhone(String value) =>
      value.replaceAll(RegExp(r'\D'), '').length >= 9;

  FormFieldValidator<String> get required =>
      (v) => (v ?? '').trim().isEmpty ? _l10n.validationRequired : null;

  FormFieldValidator<String> get name =>
      (v) => (v ?? '').trim().length < 2 ? _l10n.validationName : null;

  FormFieldValidator<String> get email =>
      (v) => isEmail(v ?? '') ? null : _l10n.validationEmail;

  FormFieldValidator<String> get password =>
      (v) => (v ?? '').length < minPasswordLength
      ? _l10n.validationPassword('$minPasswordLength')
      : null;

  FormFieldValidator<String> get phone =>
      (v) => isPhone(v ?? '') ? null : _l10n.validationPhone;
}
