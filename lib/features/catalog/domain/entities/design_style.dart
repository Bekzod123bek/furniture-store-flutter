/// Interior design styles used both to tag products and to describe a room.
enum DesignStyle {
  modern,
  scandinavian,
  minimalist,
  classic,
  industrial,
  rustic,
  midCentury;

  /// Looks up a style by its enum name, or `null` for unknown values.
  static DesignStyle? tryParse(String? name) {
    for (final style in values) {
      if (style.name == name) return style;
    }
    return null;
  }
}
