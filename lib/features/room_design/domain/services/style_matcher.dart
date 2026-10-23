import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/catalog/domain/entities/product.dart';
import 'package:furniture_store/features/room_design/domain/entities/room_analysis.dart';

/// Scores how well a product's design styles match the style of a room.
abstract final class StyleMatcher {
  /// Styles that look good together.
  static const _related = <DesignStyle, Set<DesignStyle>>{
    DesignStyle.modern: {
      DesignStyle.minimalist,
      DesignStyle.scandinavian,
      DesignStyle.midCentury,
    },
    DesignStyle.scandinavian: {
      DesignStyle.minimalist,
      DesignStyle.modern,
      DesignStyle.midCentury,
      DesignStyle.rustic,
    },
    DesignStyle.minimalist: {DesignStyle.modern, DesignStyle.scandinavian},
    DesignStyle.classic: {DesignStyle.midCentury, DesignStyle.rustic},
    DesignStyle.industrial: {DesignStyle.modern, DesignStyle.rustic},
    DesignStyle.rustic: {
      DesignStyle.industrial,
      DesignStyle.scandinavian,
      DesignStyle.classic,
    },
    DesignStyle.midCentury: {
      DesignStyle.modern,
      DesignStyle.scandinavian,
      DesignStyle.classic,
    },
  };

  /// 1 = same style, 0.75 = matches the secondary style, 0.5 = a style that
  /// pairs well, 0.15 = unrelated. Products without style tags get 0.4.
  static double score(Product product, RoomAnalysis room) {
    if (product.styles.isEmpty) return 0.4;
    if (product.styles.contains(room.style)) return 1;
    final secondary = room.secondaryStyle;
    if (secondary != null && product.styles.contains(secondary)) return 0.75;
    final related = _related[room.style] ?? const {};
    if (product.styles.any(related.contains)) return 0.5;
    return 0.15;
  }
}
