import 'dart:math';

/// Creates unique ids. An interface so tests can use fixed values.
abstract interface class IdGenerator {
  String newId();
}

class RandomIdGenerator implements IdGenerator {
  RandomIdGenerator([Random? random]) : _random = random ?? Random.secure();

  static const _alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  final Random _random;

  @override
  String newId() => String.fromCharCodes(
    List.generate(
      20,
      (_) => _alphabet.codeUnitAt(_random.nextInt(_alphabet.length)),
    ),
  );
}
