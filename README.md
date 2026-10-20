# Furniture Store

A personal demo project: a mobile furniture shop built with Flutter.

Browse products by category, open a product, add it to the cart, change
quantities and check out.

> **Note:** this is a portfolio/demo project, not a production app. The
> catalog comes from an in-memory mock repository, there is no backend and no
> real payment.

## Stack

- Flutter / Dart
- `flutter_bloc` (Cubit) for state management
- `get_it` for dependency injection
- Clean Architecture split: `domain`, `data`, `presentation`

## Structure

```
lib/
  main.dart
  injection.dart
  features/shop/
    domain/        entities and repository contract
    data/          mock repository
    presentation/  cubits and pages
```

## Run

```bash
flutter pub get
flutter run
flutter test
```

## Possible next steps

- Replace the mock repository with a REST API (`dio`)
- Product images and search
- Persist the cart locally
