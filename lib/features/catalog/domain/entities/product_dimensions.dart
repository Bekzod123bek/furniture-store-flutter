import 'package:equatable/equatable.dart';

/// Outer size of a product in centimetres.
class ProductDimensions extends Equatable {
  const ProductDimensions({
    required this.widthCm,
    required this.depthCm,
    required this.heightCm,
  });

  final int widthCm;
  final int depthCm;
  final int heightCm;

  /// Floor area covered by the product, in square metres.
  double get footprintM2 => widthCm * depthCm / 10000;

  /// Human readable size, for example `214 × 92 × 84 cm`.
  String get label => '$widthCm × $depthCm × $heightCm cm';

  @override
  List<Object?> get props => [widthCm, depthCm, heightCm];
}
