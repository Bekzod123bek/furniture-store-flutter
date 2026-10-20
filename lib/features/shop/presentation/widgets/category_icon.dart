import 'package:flutter/material.dart';

import '../../domain/entities.dart';

extension CategoryIcon on Category {
  IconData get icon => switch (this) {
    Category.sofa => Icons.weekend_outlined,
    Category.armchair => Icons.chair_outlined,
    Category.chair => Icons.event_seat_outlined,
    Category.table => Icons.table_restaurant_outlined,
    Category.bed => Icons.bed_outlined,
    Category.lamp => Icons.light_outlined,
    Category.storage => Icons.shelves,
  };
}
