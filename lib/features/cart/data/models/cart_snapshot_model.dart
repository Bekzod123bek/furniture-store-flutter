import 'package:furniture_store/core/utils/json_reader.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_line.dart';
import 'package:furniture_store/features/cart/domain/entities/cart_snapshot.dart';

abstract final class CartSnapshotModel {
  static CartSnapshot fromMap(Map<String, dynamic> map) {
    final json = JsonReader(map);
    return CartSnapshot(
      lines: [
        for (final line in json.objects('lines'))
          CartLine(
            productId: line.string('productId'),
            colorName: line.string('colorName'),
            quantity: line.integer('quantity'),
          ),
      ],
      promoCode: json.optionalString('promoCode'),
    );
  }

  static Map<String, Object?> toMap(CartSnapshot snapshot) => {
    'lines': [
      for (final l in snapshot.lines)
        {
          'productId': l.productId,
          'colorName': l.colorName,
          'quantity': l.quantity,
        },
    ],
    'promoCode': snapshot.promoCode,
  };
}
