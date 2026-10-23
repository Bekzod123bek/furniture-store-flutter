import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/features/location/domain/entities/place_address.dart';
import 'package:furniture_store/features/location/presentation/widgets/osm_tile_layer.dart';
import 'package:latlong2/latlong.dart';

/// Shows the delivery point picked on the map, or a button to pick one.
class DeliveryPointCard extends StatelessWidget {
  const DeliveryPointCard({
    super.key,
    required this.place,
    required this.onPick,
  });

  final PlaceAddress? place;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final current = place;
    if (current == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.map_outlined, color: scheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.checkoutLocation,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.checkoutLocationHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onPick,
                icon: const Icon(Icons.location_on_outlined),
                label: Text(l10n.checkoutPickOnMap),
              ),
            ],
          ),
        ),
      );
    }
    final point = LatLng(current.point.latitude, current.point.longitude);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 130,
            child: IgnorePointer(
              child: FlutterMap(
                key: ValueKey(current.point),
                options: MapOptions(initialCenter: point, initialZoom: 16),
                children: [
                  osmTileLayer(),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: 40,
                        height: 40,
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.place_outlined, color: scheme.primary),
            title: Text(
              current.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(l10n.checkoutLocation),
            trailing: TextButton(
              onPressed: onPick,
              child: Text(l10n.checkoutChangeLocation),
            ),
          ),
        ],
      ),
    );
  }
}
