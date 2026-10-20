# Furniture Store

A personal demo project: a furniture shop app for Android and iOS built with
Flutter.

> **Note:** this is a portfolio/demo project, not a production app. Products,
> prices and reviews are sample data, there is no backend, sign-in is simulated
> (nothing leaves the device, passwords are not stored) and no real payment is
> taken. Photos are illustrative.

## Screenshots

| Onboarding | Home | Product | Cart |
|---|---|---|---|
| <img src="docs/screenshots/onboarding.jpg" width="180"> | <img src="docs/screenshots/home.jpg" width="180"> | <img src="docs/screenshots/product.jpg" width="180"> | <img src="docs/screenshots/cart.jpg" width="180"> |

Screenshots were taken on an Android emulator (Pixel 7).

## Design

Warm cream and walnut-brown theme (with a dark mode switch), soft shadows, rounded product cards with sale badges and Hero transitions between the grid and the product page.

## Features

- **Onboarding** (3 slides, shown on first launch only)
- **Sign in / register** with form validation (mock)
- **Home**: promo banner carousel, 7 categories, live search, sort
- **Filters** in a bottom sheet: price range, material, rating, sale items
- **Product page**: Hero animation, photo gallery with indicator, colour
  variants, quantity, specs, reviews, related products
- **Cart**: quantities, swipe to remove with undo, promo codes (`SALE10`,
  `WELCOME20`), delivery fee with a free delivery threshold
- **Checkout**: address form, standard / express delivery, payment choice,
  order summary and a success screen
- **Orders history**, **favorites** and **cart** saved on the device
- **Profile**: stats, dark / light mode switch (remembered), sign out
- Shimmer loading, empty states, snackbars, pull to refresh

## Stack

- Flutter / Dart, Material 3
- `flutter_bloc` (Cubit) for state management
- `get_it` for dependency injection
- `shared_preferences` for local storage
- `cached_network_image` + `shimmer` for photos and loading states
- `intl` for money and date formatting
- Clean Architecture split: `domain`, `data`, `presentation`

## Structure

```
lib/
  main.dart                 app, theme, auth routing
  injection.dart            get_it setup
  core/                     theme, ThemeCubit, shared widgets, formatting
  features/
    auth/                   onboarding, login, AuthCubit (mock)
    shop/
      domain/               entities, filter, repository and storage contracts
      data/                 sample catalog, shared_preferences storage
      presentation/         cubits, pages, widgets
```

## Run

```bash
flutter pub get
flutter run
flutter test
```

The app needs an internet connection to load photos.

## Possible next steps

- Real backend with a REST API (`dio`)
- Real authentication and payments
- Push notifications for order status

## Credits

Photos: [Unsplash](https://unsplash.com) (Unsplash License).

## Author

Bekzod Abdurahimov, Flutter developer · [GitHub](https://github.com/Bekzod123bek)
