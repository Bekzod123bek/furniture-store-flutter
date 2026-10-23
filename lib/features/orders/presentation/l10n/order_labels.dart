import 'package:furniture_store/features/orders/domain/entities/order_status.dart';
import 'package:furniture_store/features/orders/domain/entities/payment_method.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

extension OrderStatusLabel on OrderStatus {
  String label(AppLocalizations l10n) => switch (this) {
    OrderStatus.processing => l10n.statusProcessing,
    OrderStatus.shipped => l10n.statusShipped,
    OrderStatus.delivered => l10n.statusDelivered,
    OrderStatus.cancelled => l10n.statusCancelled,
  };
}

extension PaymentMethodLabel on PaymentMethod {
  String label(AppLocalizations l10n) => switch (this) {
    PaymentMethod.cashOnDelivery => l10n.paymentCashOnDelivery,
    PaymentMethod.cardOnDelivery => l10n.paymentCardOnDelivery,
  };
}
