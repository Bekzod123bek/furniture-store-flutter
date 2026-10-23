import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({required this.uid, required this.name, required this.email});

  final String uid;
  final String name;
  final String email;

  String get firstName {
    final first = name.trim().split(RegExp(r'\s+')).first;
    return first.isEmpty ? 'there' : first;
  }

  /// Up to two capital letters for the avatar.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  List<Object?> get props => [uid, name, email];
}
