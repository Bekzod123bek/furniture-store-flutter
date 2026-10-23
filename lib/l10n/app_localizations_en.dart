// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Furniture Store';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonCouldNotLoad => 'Could not load';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'Back';

  @override
  String get commonFree => 'Free';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonReset => 'Reset';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonIncrease => 'Increase';

  @override
  String get commonDecrease => 'Decrease';

  @override
  String get commonHello => 'Hello 👋';

  @override
  String commonHelloName(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get errorNetwork => 'No internet connection. Check it and try again.';

  @override
  String get errorServer => 'The server is not responding. Try again later.';

  @override
  String get errorCache => 'Could not read data saved on this device.';

  @override
  String get errorNotFound => 'Nothing was found.';

  @override
  String get errorInvalidCredentials => 'Wrong email or password.';

  @override
  String get errorUnexpected => 'Something went wrong. Try again.';

  @override
  String get errorEmptyCart => 'Your cart is empty.';

  @override
  String get errorIncompleteAddress => 'Please fill in the delivery address.';

  @override
  String get errorOrderNotCancellable =>
      'This order can no longer be cancelled.';

  @override
  String get errorEmailInUse =>
      'This email is already registered. Try signing in.';

  @override
  String get errorWeakPassword =>
      'Choose a stronger password (at least 6 characters).';

  @override
  String get errorInvalidEmail => 'Enter a valid email.';

  @override
  String get errorAccountDisabled => 'This account is disabled.';

  @override
  String get errorTooManyAttempts =>
      'Too many attempts. Wait a few minutes and try again.';

  @override
  String get errorSignInAgain => 'Please sign in again to do this.';

  @override
  String get errorSignedOut => 'You are signed out.';

  @override
  String get errorPhotoTooLarge => 'The photo is too large (over 10 MB).';

  @override
  String get errorPhotoAccess =>
      'Camera or photo access is turned off. Allow it in the phone settings.';

  @override
  String get errorPhotoUnreadable =>
      'The photo could not be analysed. Try a different one.';

  @override
  String get errorNotARoom =>
      'This does not look like the inside of a room. Take a photo of the room you want to furnish.';

  @override
  String get errorAnalysisLimit =>
      'The photo analysis limit is reached for now. Try again later.';

  @override
  String get errorLocationOff =>
      'Location is turned off. Turn it on and try again.';

  @override
  String get errorLocationDenied => 'Location access was not allowed.';

  @override
  String get errorLocationDeniedForever =>
      'Location access is blocked. Allow it in the phone settings.';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationName => 'Enter your name';

  @override
  String get validationEmail => 'Enter a valid email';

  @override
  String validationPassword(String min) {
    return 'At least $min characters';
  }

  @override
  String get validationPhone => 'Enter a valid phone number';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboarding1Title => 'Furniture that feels like home';

  @override
  String get onboarding1Text =>
      'Hand-picked sofas, chairs and tables from trusted makers.';

  @override
  String get onboarding2Title => 'Let AI furnish your room';

  @override
  String get onboarding2Text =>
      'Take a photo of your room and get a matching set: your style, your colours, the right size.';

  @override
  String get onboarding3Title => 'Delivered to your door';

  @override
  String onboarding3Text(String amount) {
    return 'Free delivery on orders over $amount. Mark your entrance on the map.';
  }

  @override
  String get loginWelcome => 'Welcome back';

  @override
  String get loginWelcomeText => 'Sign in to continue shopping.';

  @override
  String get loginCreateTitle => 'Create account';

  @override
  String get loginCreateText => 'Sign up to save favorites and track orders.';

  @override
  String get loginSignIn => 'Sign in';

  @override
  String get loginRegister => 'Register';

  @override
  String get loginCreateButton => 'Create account';

  @override
  String get loginFullName => 'Full name';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginForgot => 'Forgot password?';

  @override
  String get loginEnterEmailFirst => 'Enter your email above first';

  @override
  String loginResetSent(String email) {
    return 'Password reset link sent to $email';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navFavorites => 'Saved';

  @override
  String get navCart => 'Cart';

  @override
  String get navProfile => 'Profile';

  @override
  String get navScan => 'AI room';

  @override
  String get homeTitle => 'Find furniture you love';

  @override
  String get homeSearchHint => 'Search sofas, oak, lamps…';

  @override
  String get homeClearSearch => 'Clear search';

  @override
  String get homeFilters => 'Filters';

  @override
  String get homeRoomCardTitle => 'Furnish your room from a photo';

  @override
  String get homeRoomCardText =>
      'AI picks furniture for your style, colours and size';

  @override
  String get homeRoomCardAction => 'Try it';

  @override
  String get homeLoading => 'Loading…';

  @override
  String get homePopular => 'Popular now';

  @override
  String homeResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String get homeSort => 'Sort';

  @override
  String get homeEmptyCatalog => 'No products yet';

  @override
  String get homeEmptyCatalogText =>
      'The catalog is empty. Pull down to refresh.';

  @override
  String get homeNothingFound => 'Nothing found';

  @override
  String get homeNothingFoundText =>
      'Try another search word or reset the filters.';

  @override
  String get homeResetFilters => 'Reset filters';

  @override
  String get homeAllCategories => 'All';

  @override
  String get homeShopNow => 'Shop now';

  @override
  String get categorySofa => 'Sofas';

  @override
  String get categoryArmchair => 'Armchairs';

  @override
  String get categoryChair => 'Chairs';

  @override
  String get categoryTable => 'Tables';

  @override
  String get categoryBed => 'Beds';

  @override
  String get categoryLamp => 'Lamps';

  @override
  String get categoryStorage => 'Storage';

  @override
  String get sortPopular => 'Popular';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortPriceAsc => 'Price: low to high';

  @override
  String get sortPriceDesc => 'Price: high to low';

  @override
  String get sortRating => 'Top rated';

  @override
  String get filterTitle => 'Filters';

  @override
  String get filterPrice => 'Price';

  @override
  String get filterMaterial => 'Material';

  @override
  String get filterRating => 'Rating';

  @override
  String get filterAnyRating => 'Any';

  @override
  String get filterOnSale => 'Only items on sale';

  @override
  String get filterShow => 'Show results';

  @override
  String get productNew => 'NEW';

  @override
  String productRatingReviews(String rating, String reviews) {
    return '$rating · $reviews reviews';
  }

  @override
  String productSave(String percent) {
    return 'Save $percent%';
  }

  @override
  String productColour(String name) {
    return 'Colour: $name';
  }

  @override
  String get productAbout => 'About';

  @override
  String get productMaterial => 'Material';

  @override
  String get productSize => 'Size';

  @override
  String get productDelivery => 'Delivery';

  @override
  String get productDeliveryDays => '3–5 days';

  @override
  String get productReviews => 'Reviews';

  @override
  String productReviewsTotal(String total) {
    return '$total total';
  }

  @override
  String get productRelated => 'You may also like';

  @override
  String productAdd(String price) {
    return 'Add · $price';
  }

  @override
  String productAdded(String quantity, String name) {
    return '$quantity × $name added to cart';
  }

  @override
  String get productAddToCart => 'Add to cart';

  @override
  String get productAddFavorite => 'Add to favorites';

  @override
  String get productRemoveFavorite => 'Remove from favorites';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get productNotFoundText =>
      'It may have been removed from the catalog.';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'No favorites yet';

  @override
  String get favoritesEmptyText =>
      'Tap the heart on any product to save it here.';

  @override
  String get favoritesBrowse => 'Browse products';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyText => 'Add something you like and it will appear here.';

  @override
  String get cartStartShopping => 'Start shopping';

  @override
  String cartCheckout(String price) {
    return 'Checkout · $price';
  }

  @override
  String cartRemoved(String name) {
    return '$name removed';
  }

  @override
  String get cartPromoHint => 'Promo code';

  @override
  String get cartPromoUnknown => 'Unknown code. Try SALE10';

  @override
  String cartPromoApplied(String code) {
    return '$code applied';
  }

  @override
  String cartPromoOff(String percent) {
    return '$percent% off your items';
  }

  @override
  String get cartPromoRemove => 'Remove code';

  @override
  String cartSubtotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Subtotal ($count items)',
      one: 'Subtotal (1 item)',
    );
    return '$_temp0';
  }

  @override
  String get cartDiscount => 'Discount';

  @override
  String get cartDelivery => 'Delivery';

  @override
  String cartFreeDeliveryHint(String amount) {
    return 'Add $amount more for free delivery';
  }

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutAddress => 'Delivery address';

  @override
  String get checkoutPhone => 'Phone';

  @override
  String get checkoutPhoneHint => '+998 90 123 45 67';

  @override
  String get checkoutCity => 'City';

  @override
  String get checkoutDefaultCity => 'Tashkent';

  @override
  String get checkoutStreet => 'Street, house, apartment';

  @override
  String get checkoutDeliveryTitle => 'Delivery';

  @override
  String get checkoutStandardFree => 'Standard · Free';

  @override
  String checkoutStandardPrice(String price) {
    return 'Standard · $price';
  }

  @override
  String checkoutExpress(String price) {
    return 'Express · +$price';
  }

  @override
  String get checkoutPayment => 'Payment';

  @override
  String get checkoutCash => 'Cash';

  @override
  String get checkoutCard => 'Card on delivery';

  @override
  String get checkoutPayNote =>
      'You pay when the order arrives. No payment is taken in the app.';

  @override
  String get checkoutSummary => 'Summary';

  @override
  String checkoutPlace(String price) {
    return 'Place order · $price';
  }

  @override
  String get checkoutLocation => 'Delivery point';

  @override
  String get checkoutPickOnMap => 'Choose on map';

  @override
  String get checkoutChangeLocation => 'Change';

  @override
  String get checkoutLocationHint =>
      'Mark your entrance on the map so the courier finds you faster.';

  @override
  String get paymentCashOnDelivery => 'Cash on delivery';

  @override
  String get paymentCardOnDelivery => 'Card on delivery';

  @override
  String get deliveryStandard => 'Standard';

  @override
  String get deliveryExpress => 'Express';

  @override
  String get successTitle => 'Order placed!';

  @override
  String successText(String number, String total) {
    return 'Order $number · $total\nYou can follow it in Profile → My orders.';
  }

  @override
  String get successContinue => 'Continue shopping';

  @override
  String get ordersTitle => 'My orders';

  @override
  String get ordersEmpty => 'No orders yet';

  @override
  String get ordersEmptyText => 'Your placed orders will show up here.';

  @override
  String ordersNumber(String number) {
    return 'Order $number';
  }

  @override
  String ordersItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get ordersPayment => 'Payment';

  @override
  String get ordersCancel => 'Cancel order';

  @override
  String get ordersCancelTitle => 'Cancel this order?';

  @override
  String ordersCancelText(String number) {
    return 'Order $number will be cancelled.';
  }

  @override
  String get ordersKeep => 'Keep order';

  @override
  String get ordersOnMap => 'Delivery point marked on the map';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusShipped => 'Shipped';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileOrders => 'Orders';

  @override
  String get profileFavorites => 'Favorites';

  @override
  String get profileFurnish => 'Furnish a room from a photo';

  @override
  String get profileMyOrders => 'My orders';

  @override
  String get profileAbout => 'About this app';

  @override
  String get profileAboutText =>
      'Photos: Unsplash. Room analysis: Google Gemini. Maps: © OpenStreetMap contributors.';

  @override
  String get profileTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get profileLanguage => 'Language';

  @override
  String get languageSystem => 'Phone';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileSignOutTitle => 'Sign out?';

  @override
  String get profileSignOutText =>
      'Your cart, favorites and orders stay in your account.';

  @override
  String get roomTitle => 'Furnish your room';

  @override
  String get roomStartOver => 'Start over';

  @override
  String get roomIntroTitle => 'Photo in, furniture set out';

  @override
  String get roomIntroText =>
      'We read the style, colours and size of your room and pick furniture that belongs there.';

  @override
  String get roomTakePhoto => 'Take a photo';

  @override
  String get roomGallery => 'Choose from gallery';

  @override
  String get roomTips => 'For the best result';

  @override
  String get roomTipCorner => 'Stand in a corner and show the whole room';

  @override
  String get roomTipLight => 'Use daylight and keep the photo sharp';

  @override
  String get roomTipDoor =>
      'Include a door or window: it helps estimate the size';

  @override
  String get roomPrivacy =>
      'Your photo is sent to Google Gemini through Firebase to read the room. It is not saved in your account.';

  @override
  String get roomReading => 'Reading your room…';

  @override
  String get roomReadingText =>
      'Looking at the style, colours and size. This takes a few seconds.';

  @override
  String get roomFailed => 'Could not read the room';

  @override
  String get roomAnotherPhoto => 'Choose another photo';

  @override
  String get roomYourRoom => 'Your room';

  @override
  String get roomType => 'Room';

  @override
  String get roomStyle => 'Style';

  @override
  String get roomColours => 'Colours';

  @override
  String get roomSize => 'Room size';

  @override
  String get roomWidth => 'Width';

  @override
  String get roomLength => 'Length';

  @override
  String roomDecrease(String label) {
    return 'Decrease $label';
  }

  @override
  String roomIncrease(String label) {
    return 'Increase $label';
  }

  @override
  String get roomSizeHigh => 'Size confirmed.';

  @override
  String get roomSizeMedium =>
      'Size is estimated from the photo. Adjust it if you know better.';

  @override
  String get roomSizeLow =>
      'Size is a rough guess from the photo. Please set the real size.';

  @override
  String get roomSetTitle => 'Your furniture set';

  @override
  String roomSetFor(String room, String style, String size) {
    return 'Picked for: $room · $style · $size';
  }

  @override
  String get roomNothingFits => 'Nothing fits yet';

  @override
  String get roomNothingFitsText =>
      'No product in the catalog fits this room size. Check the room size above.';

  @override
  String roomSlotUnfilled(String slot) {
    return 'Nothing in the catalog fits here: $slot';
  }

  @override
  String roomFloorCrowded(String percent) {
    return 'Furniture covers $percent% of the floor: the room may feel crowded.';
  }

  @override
  String roomFloorOk(String percent) {
    return 'Furniture covers $percent% of the floor: plenty of space to move.';
  }

  @override
  String get roomSetTotal => 'Set total';

  @override
  String get roomAddAll => 'Add all to cart';

  @override
  String roomPiecesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces added to your cart',
      one: '1 piece added to your cart',
    );
    return '$_temp0';
  }

  @override
  String get roomOtherOptions => 'Other options';

  @override
  String roomQuantityPrice(String quantity, String price, String total) {
    return '$quantity × $price = $total';
  }

  @override
  String get roomTypeLiving => 'Living room';

  @override
  String get roomTypeBedroom => 'Bedroom';

  @override
  String get roomTypeDining => 'Dining room';

  @override
  String get roomTypeOffice => 'Home office';

  @override
  String get styleModern => 'Modern';

  @override
  String get styleScandinavian => 'Scandinavian';

  @override
  String get styleMinimalist => 'Minimalist';

  @override
  String get styleClassic => 'Classic';

  @override
  String get styleIndustrial => 'Industrial';

  @override
  String get styleRustic => 'Rustic';

  @override
  String get styleMidCentury => 'Mid-century';

  @override
  String get slotSofa => 'Sofa';

  @override
  String get slotArmchair => 'Armchair';

  @override
  String get slotCoffeeTable => 'Coffee table';

  @override
  String get slotLighting => 'Lighting';

  @override
  String get slotStorage => 'Storage';

  @override
  String get slotBed => 'Bed';

  @override
  String get slotReadingChair => 'Reading chair';

  @override
  String get slotDiningTable => 'Dining table';

  @override
  String get slotDiningChairs => 'Dining chairs';

  @override
  String get slotDesk => 'Desk';

  @override
  String get slotDeskChair => 'Chair';

  @override
  String get slotShelving => 'Shelving';

  @override
  String reasonSameStyle(String style) {
    return 'Matches your $style style';
  }

  @override
  String reasonSecondaryStyle(String style) {
    return 'Fits the $style touch of your room';
  }

  @override
  String reasonRelatedStyle(String style) {
    return 'Pairs well with $style interiors';
  }

  @override
  String reasonColor(String color, String tones) {
    return '$color goes with your $tones tones';
  }

  @override
  String reasonColorPlain(String color) {
    return '$color suits the room colours';
  }

  @override
  String reasonSize(String width, String percent) {
    return '$width cm wide, about $percent% of the floor';
  }

  @override
  String get reasonNoFloor => 'Takes no floor space';

  @override
  String reasonTonesJoin(String first, String second) {
    return '$first and $second';
  }

  @override
  String get locationTitle => 'Delivery point';

  @override
  String get locationMyPosition => 'My location';

  @override
  String get locationConfirm => 'Deliver here';

  @override
  String get locationFinding => 'Finding the address…';

  @override
  String get locationMoveHint => 'Move the map to put the pin on your entrance';

  @override
  String get locationNoAddress =>
      'No address here, but you can still use this point.';
}
