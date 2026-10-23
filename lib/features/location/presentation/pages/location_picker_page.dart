import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:furniture_store/core/error/failure_messages.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/features/location/domain/entities/geo_point.dart';
import 'package:furniture_store/features/location/presentation/cubit/location_picker_cubit.dart';
import 'package:furniture_store/features/location/presentation/cubit/location_picker_state.dart';
import 'package:furniture_store/features/location/presentation/widgets/osm_tile_layer.dart';
import 'package:latlong2/latlong.dart';

/// Full-screen map with a pin in the middle. Returns the chosen
/// `PlaceAddress` with `Navigator.pop`.
class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key, this.initial});

  final GeoPoint? initial;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  static const _zoom = 17.0;

  final _map = MapController();
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    context.read<LocationPickerCubit>().start(
      initial: widget.initial,
      languageCode: context.languageCode,
    );
  }

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  void _onState(BuildContext context, LocationPickerState state) {
    _map.move(LatLng(state.center.latitude, state.center.longitude), _zoom);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final start = widget.initial ?? GeoPoint.tashkent;
    return BlocListener<LocationPickerCubit, LocationPickerState>(
      listenWhen: (a, b) => a.moveRequest != b.moveRequest,
      listener: _onState,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.locationTitle)),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: LatLng(start.latitude, start.longitude),
                initialZoom: _zoom,
                minZoom: 4,
                maxZoom: 19,
                onPositionChanged: (camera, hasGesture) {
                  if (!hasGesture) return;
                  context.read<LocationPickerCubit>().cameraMoved(
                    GeoPoint(camera.center.latitude, camera.center.longitude),
                  );
                },
              ),
              children: [osmTileLayer(), osmAttribution()],
            ),
            const IgnorePointer(child: Center(child: _Pin())),
            Positioned(
              right: 16,
              bottom: 16,
              child: BlocBuilder<LocationPickerCubit, LocationPickerState>(
                buildWhen: (a, b) => a.locating != b.locating,
                builder: (context, state) => FloatingActionButton(
                  heroTag: null,
                  tooltip: l10n.locationMyPosition,
                  onPressed: state.locating
                      ? null
                      : context.read<LocationPickerCubit>().locate,
                  child: state.locating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Icon(Icons.my_location),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const _AddressPanel(),
      ),
    );
  }
}

/// A pin whose tip sits exactly on the map centre.
class _Pin extends StatelessWidget {
  const _Pin();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Transform.translate(
      offset: const Offset(0, -22),
      child: Icon(
        Icons.location_on,
        size: 48,
        color: scheme.primary,
        shadows: const [Shadow(blurRadius: 8, color: Colors.black38)],
      ),
    );
  }
}

class _AddressPanel extends StatelessWidget {
  const _AddressPanel();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return BlocBuilder<LocationPickerCubit, LocationPickerState>(
      builder: (context, state) {
        final address = state.address;
        final String text;
        if (state.resolving) {
          text = l10n.locationFinding;
        } else if (address != null && address.hasAddress) {
          text = address.label;
        } else {
          text = l10n.locationNoAddress;
        }
        final failure = state.failure;
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              border: Border(
                top: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.locationMoveHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                if (failure != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    failure.localized(l10n),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: state.resolving
                      ? null
                      : () => Navigator.of(context).pop(state.selection),
                  icon: const Icon(Icons.check),
                  label: Text(l10n.locationConfirm),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
