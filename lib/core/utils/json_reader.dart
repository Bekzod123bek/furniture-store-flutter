/// Reads typed values from a decoded JSON / Firestore map and throws a
/// [FormatException] naming the field when one is missing or has a wrong type.
/// Repositories turn that into a `ServerFailure`.
class JsonReader {
  const JsonReader(this._map, [this._path = '']);

  final Map<String, dynamic> _map;
  final String _path;

  String string(String key) => _require<String>(key);

  int integer(String key) => _require<num>(key).toInt();

  double number(String key) => _require<num>(key).toDouble();

  bool boolean(String key) => _require<bool>(key);

  String? optionalString(String key) => _optional<String>(key);

  int? optionalInt(String key) => _optional<num>(key)?.toInt();

  double? optionalNumber(String key) => _optional<num>(key)?.toDouble();

  bool booleanOr(String key, {required bool orElse}) =>
      _optional<bool>(key) ?? orElse;

  List<T> list<T>(String key) {
    final value = _require<List<dynamic>>(key);
    return value.map((e) {
      if (e is! T) throw FormatException('"${_name(key)}" has a bad item: $e');
      return e;
    }).toList();
  }

  List<JsonReader> objects(String key) {
    final value = _require<List<dynamic>>(key);
    return [
      for (var i = 0; i < value.length; i++)
        JsonReader(_asMap(value[i], '${_name(key)}[$i]'), '${_name(key)}[$i]'),
    ];
  }

  String _name(String key) => _path.isEmpty ? key : '$_path.$key';

  T _require<T>(String key) {
    final value = _map[key];
    if (value is! T) {
      throw FormatException(
        '"${_name(key)}" must be $T but was ${value.runtimeType}',
      );
    }
    return value;
  }

  T? _optional<T>(String key) {
    final value = _map[key];
    if (value == null) return null;
    if (value is! T) {
      throw FormatException(
        '"${_name(key)}" must be $T but was ${value.runtimeType}',
      );
    }
    return value;
  }

  static Map<String, dynamic> _asMap(Object? value, String name) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    throw FormatException('"$name" must be an object');
  }
}
