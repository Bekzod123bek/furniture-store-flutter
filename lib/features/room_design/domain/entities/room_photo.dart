import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// A picture of a room, ready to be analysed.
class RoomPhoto extends Equatable {
  const RoomPhoto({required this.bytes, required this.mimeType});

  final Uint8List bytes;

  /// For example `image/jpeg`.
  final String mimeType;

  @override
  List<Object?> get props => [bytes.length, mimeType];
}
