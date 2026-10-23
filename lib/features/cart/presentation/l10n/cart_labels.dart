import 'package:furniture_store/features/cart/domain/entities/delivery_method.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

extension DeliveryMethodLabel on DeliveryMethod {
  String label(AppLocalizations l10n) => switch (this) {
    DeliveryMethod.standard => l10n.deliveryStandard,
    DeliveryMethod.express => l10n.deliveryExpress,
  };
}
