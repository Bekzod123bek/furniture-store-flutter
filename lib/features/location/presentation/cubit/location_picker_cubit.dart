import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/location/domain/usecases/find_address.dart';
import 'package:furniture_store/features/location/domain/usecases/get_current_position.dart';
import 'package:furniture_store/features/location/presentation/cubit/location_picker_state.dart';

/// The user moves the map under a fixed pin. When the map stops, the address
/// under the pin is looked up. Lookups wait a moment after the last move, so
/// dragging the map does not flood the free geocoder.
class LocationPickerCubit extends Cubit<LocationPickerState> {
  LocationPickerCubit({
    required GetCurrentPosition getCurrentPosition,
    required FindAddress findAddress,
    this.debounce = const Duration(milliseconds: 800),
  }) : _getPosition = getCurrentPosition,
       _findAddress = findAddress,
       super(const LocationPickerState());

  final GetCurrentPosition _getPosition;
  final FindAddress _findAddress;
  final Duration debounce;

  Timer? _timer;
  String _languageCode = 'uz';

  /// Opens at [initial], or at the device position when it is `null`.
  Future<void> start({GeoPoint? initial, required String languageCode}) async {
    _languageCode = languageCode;
    if (initial != null) {
      emit(state.copyWith(center: initial, moveRequest: state.moveRequest + 1));
      await _resolve(initial);
    } else {
      await locate();
    }
  }

  /// Moves the pin to where the device is.
  Future<void> locate() async {
    emit(state.copyWith(locating: true, failure: () => null));
    final result = await _getPosition(const NoParams());
    if (isClosed) return;
    switch (result) {
      case Ok(:final value):
        emit(
          state.copyWith(
            center: value,
            locating: false,
            address: () => null,
            moveRequest: state.moveRequest + 1,
          ),
        );
        await _resolve(value);
      case Err(:final failure):
        emit(state.copyWith(locating: false, failure: () => failure));
        // Without a position we still show the address at the map centre.
        if (state.address == null) await _resolve(state.center);
    }
  }

  /// Called while the user drags the map.
  void cameraMoved(GeoPoint center) {
    emit(
      state.copyWith(
        center: center,
        address: () => null,
        resolving: true,
        failure: () => null,
      ),
    );
    _timer?.cancel();
    _timer = Timer(debounce, () => _resolve(center));
  }

  Future<void> _resolve(GeoPoint point) async {
    emit(state.copyWith(resolving: true));
    final result = await _findAddress(
      FindAddressParams(point, languageCode: _languageCode),
    );
    // The user may have moved the map while we waited.
    if (isClosed || state.center != point) return;
    final lookupFailure = result.failureOrNull;
    emit(
      state.copyWith(
        resolving: false,
        address: () => result.valueOrNull,
        // Keep an earlier message (for example "location denied") unless
        // this lookup failed too.
        failure: lookupFailure == null ? null : () => lookupFailure,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
