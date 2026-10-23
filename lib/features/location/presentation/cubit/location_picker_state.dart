import 'package:equatable/equatable.dart';
import 'package:furniture_store/core/error/failures.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/location/domain/entities/place_address.dart';

class LocationPickerState extends Equatable {
  const LocationPickerState({
    this.center = GeoPoint.tashkent,
    this.address,
    this.locating = false,
    this.resolving = false,
    this.moveRequest = 0,
    this.failure,
  });

  /// The point under the pin.
  final GeoPoint center;

  /// The address found for [center]; `null` while it is being looked up.
  final PlaceAddress? address;

  /// Reading the device position.
  final bool locating;

  /// Looking up the address of [center].
  final bool resolving;

  /// Grows each time the map must jump to [center] (after "my location").
  final int moveRequest;
  final Failure? failure;

  /// What "Deliver here" returns: the found address, or just the point.
  PlaceAddress get selection => address ?? PlaceAddress(point: center);

  LocationPickerState copyWith({
    GeoPoint? center,
    PlaceAddress? Function()? address,
    bool? locating,
    bool? resolving,
    int? moveRequest,
    Failure? Function()? failure,
  }) => LocationPickerState(
    center: center ?? this.center,
    address: address != null ? address() : this.address,
    locating: locating ?? this.locating,
    resolving: resolving ?? this.resolving,
    moveRequest: moveRequest ?? this.moveRequest,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [
    center,
    address,
    locating,
    resolving,
    moveRequest,
    failure,
  ];
}
