import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// OpenStreetMap tiles. Fine for a small app; switch to a tile provider
/// (MapTiler, Stadia, Yandex) before heavy use, as OSM's policy asks.
TileLayer osmTileLayer() => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.bekzod.furniture_store',
  maxZoom: 19,
);

/// The attribution OpenStreetMap requires on every map.
Widget osmAttribution() => const RichAttributionWidget(
  alignment: AttributionAlignment.bottomLeft,
  showFlutterMapAttribution: false,
  attributions: [TextSourceAttribution('OpenStreetMap contributors')],
);
