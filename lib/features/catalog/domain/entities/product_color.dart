import 'package:equatable/equatable.dart';

/// A colour variant of a product. [argb] is a 0xAARRGGBB value, kept as an
/// int so the domain layer does not depend on Flutter.
class ProductColor extends Equatable {
  const ProductColor(this.name, this.argb);

  final String name;
  final int argb;

  @override
  List<Object?> get props => [name, argb];
}
