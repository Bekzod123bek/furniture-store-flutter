import 'package:flutter/material.dart';
import 'package:furniture_store/app/app.dart';
import 'package:furniture_store/app/bootstrap.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const FurnitureStoreApp());
}
