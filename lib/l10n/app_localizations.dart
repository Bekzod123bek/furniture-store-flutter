import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Furniture Store'**
  String get appName;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load'**
  String get commonCouldNotLoad;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get commonFree;

  /// No description provided for @commonTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get commonTotal;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get commonReset;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get commonIncrease;

  /// No description provided for @commonDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get commonDecrease;

  /// No description provided for @commonHello.
  ///
  /// In en, this message translates to:
  /// **'Hello 👋'**
  String get commonHello;

  /// No description provided for @commonHelloName.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String commonHelloName(String name);

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check it and try again.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The server is not responding. Try again later.'**
  String get errorServer;

  /// No description provided for @errorCache.
  ///
  /// In en, this message translates to:
  /// **'Could not read data saved on this device.'**
  String get errorCache;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing was found.'**
  String get errorNotFound;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errorUnexpected;

  /// No description provided for @errorEmptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty.'**
  String get errorEmptyCart;

  /// No description provided for @errorIncompleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the delivery address.'**
  String get errorIncompleteAddress;

  /// No description provided for @errorOrderNotCancellable.
  ///
  /// In en, this message translates to:
  /// **'This order can no longer be cancelled.'**
  String get errorOrderNotCancellable;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Try signing in.'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a stronger password (at least 6 characters).'**
  String get errorWeakPassword;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get errorInvalidEmail;

  /// No description provided for @errorAccountDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account is disabled.'**
  String get errorAccountDisabled;

  /// No description provided for @errorTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a few minutes and try again.'**
  String get errorTooManyAttempts;

  /// No description provided for @errorSignInAgain.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again to do this.'**
  String get errorSignInAgain;

  /// No description provided for @errorSignedOut.
  ///
  /// In en, this message translates to:
  /// **'You are signed out.'**
  String get errorSignedOut;

  /// No description provided for @errorPhotoTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The photo is too large (over 10 MB).'**
  String get errorPhotoTooLarge;

  /// No description provided for @errorPhotoAccess.
  ///
  /// In en, this message translates to:
  /// **'Camera or photo access is turned off. Allow it in the phone settings.'**
  String get errorPhotoAccess;

  /// No description provided for @errorPhotoUnreadable.
  ///
  /// In en, this message translates to:
  /// **'The photo could not be analysed. Try a different one.'**
  String get errorPhotoUnreadable;

  /// No description provided for @errorNotARoom.
  ///
  /// In en, this message translates to:
  /// **'This does not look like the inside of a room. Take a photo of the room you want to furnish.'**
  String get errorNotARoom;

  /// No description provided for @errorAnalysisLimit.
  ///
  /// In en, this message translates to:
  /// **'The photo analysis limit is reached for now. Try again later.'**
  String get errorAnalysisLimit;

  /// No description provided for @errorLocationOff.
  ///
  /// In en, this message translates to:
  /// **'Location is turned off. Turn it on and try again.'**
  String get errorLocationOff;

  /// No description provided for @errorLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location access was not allowed.'**
  String get errorLocationDenied;

  /// No description provided for @errorLocationDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location access is blocked. Allow it in the phone settings.'**
  String get errorLocationDeniedForever;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get validationRequired;

  /// No description provided for @validationName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get validationName;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validationEmail;

  /// No description provided for @validationPassword.
  ///
  /// In en, this message translates to:
  /// **'At least {min} characters'**
  String validationPassword(String min);

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get validationPhone;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Furniture that feels like home'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Text.
  ///
  /// In en, this message translates to:
  /// **'Hand-picked sofas, chairs and tables from trusted makers.'**
  String get onboarding1Text;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Let AI furnish your room'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Text.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your room and get a matching set: your style, your colours, the right size.'**
  String get onboarding2Text;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Delivered to your door'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Text.
  ///
  /// In en, this message translates to:
  /// **'Free delivery on orders over {amount}. Mark your entrance on the map.'**
  String onboarding3Text(String amount);

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcome;

  /// No description provided for @loginWelcomeText.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue shopping.'**
  String get loginWelcomeText;

  /// No description provided for @loginCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateTitle;

  /// No description provided for @loginCreateText.
  ///
  /// In en, this message translates to:
  /// **'Sign up to save favorites and track orders.'**
  String get loginCreateText;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignIn;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get loginRegister;

  /// No description provided for @loginCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateButton;

  /// No description provided for @loginFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get loginFullName;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePassword;

  /// No description provided for @loginForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgot;

  /// No description provided for @loginEnterEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Enter your email above first'**
  String get loginEnterEmailFirst;

  /// No description provided for @loginResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to {email}'**
  String loginResetSent(String email);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navFavorites;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'AI room'**
  String get navScan;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Find furniture you love'**
  String get homeTitle;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search sofas, oak, lamps…'**
  String get homeSearchHint;

  /// No description provided for @homeClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get homeClearSearch;

  /// No description provided for @homeFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get homeFilters;

  /// No description provided for @homeRoomCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Furnish your room from a photo'**
  String get homeRoomCardTitle;

  /// No description provided for @homeRoomCardText.
  ///
  /// In en, this message translates to:
  /// **'AI picks furniture for your style, colours and size'**
  String get homeRoomCardText;

  /// No description provided for @homeRoomCardAction.
  ///
  /// In en, this message translates to:
  /// **'Try it'**
  String get homeRoomCardAction;

  /// No description provided for @homeLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get homeLoading;

  /// No description provided for @homePopular.
  ///
  /// In en, this message translates to:
  /// **'Popular now'**
  String get homePopular;

  /// No description provided for @homeResults.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results} =1{1 result} other{{count} results}}'**
  String homeResults(int count);

  /// No description provided for @homeSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get homeSort;

  /// No description provided for @homeEmptyCatalog.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get homeEmptyCatalog;

  /// No description provided for @homeEmptyCatalogText.
  ///
  /// In en, this message translates to:
  /// **'The catalog is empty. Pull down to refresh.'**
  String get homeEmptyCatalogText;

  /// No description provided for @homeNothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get homeNothingFound;

  /// No description provided for @homeNothingFoundText.
  ///
  /// In en, this message translates to:
  /// **'Try another search word or reset the filters.'**
  String get homeNothingFoundText;

  /// No description provided for @homeResetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get homeResetFilters;

  /// No description provided for @homeAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get homeAllCategories;

  /// No description provided for @homeShopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop now'**
  String get homeShopNow;

  /// No description provided for @categorySofa.
  ///
  /// In en, this message translates to:
  /// **'Sofas'**
  String get categorySofa;

  /// No description provided for @categoryArmchair.
  ///
  /// In en, this message translates to:
  /// **'Armchairs'**
  String get categoryArmchair;

  /// No description provided for @categoryChair.
  ///
  /// In en, this message translates to:
  /// **'Chairs'**
  String get categoryChair;

  /// No description provided for @categoryTable.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get categoryTable;

  /// No description provided for @categoryBed.
  ///
  /// In en, this message translates to:
  /// **'Beds'**
  String get categoryBed;

  /// No description provided for @categoryLamp.
  ///
  /// In en, this message translates to:
  /// **'Lamps'**
  String get categoryLamp;

  /// No description provided for @categoryStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get categoryStorage;

  /// No description provided for @sortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get sortPopular;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get sortPriceDesc;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get sortRating;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterTitle;

  /// No description provided for @filterPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get filterPrice;

  /// No description provided for @filterMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get filterMaterial;

  /// No description provided for @filterRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get filterRating;

  /// No description provided for @filterAnyRating.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filterAnyRating;

  /// No description provided for @filterOnSale.
  ///
  /// In en, this message translates to:
  /// **'Only items on sale'**
  String get filterOnSale;

  /// No description provided for @filterShow.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get filterShow;

  /// No description provided for @productNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get productNew;

  /// No description provided for @productRatingReviews.
  ///
  /// In en, this message translates to:
  /// **'{rating} · {reviews} reviews'**
  String productRatingReviews(String rating, String reviews);

  /// No description provided for @productSave.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String productSave(String percent);

  /// No description provided for @productColour.
  ///
  /// In en, this message translates to:
  /// **'Colour: {name}'**
  String productColour(String name);

  /// No description provided for @productAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get productAbout;

  /// No description provided for @productMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get productMaterial;

  /// No description provided for @productSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get productSize;

  /// No description provided for @productDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get productDelivery;

  /// No description provided for @productDeliveryDays.
  ///
  /// In en, this message translates to:
  /// **'3–5 days'**
  String get productDeliveryDays;

  /// No description provided for @productReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get productReviews;

  /// No description provided for @productReviewsTotal.
  ///
  /// In en, this message translates to:
  /// **'{total} total'**
  String productReviewsTotal(String total);

  /// No description provided for @productRelated.
  ///
  /// In en, this message translates to:
  /// **'You may also like'**
  String get productRelated;

  /// No description provided for @productAdd.
  ///
  /// In en, this message translates to:
  /// **'Add · {price}'**
  String productAdd(String price);

  /// No description provided for @productAdded.
  ///
  /// In en, this message translates to:
  /// **'{quantity} × {name} added to cart'**
  String productAdded(String quantity, String name);

  /// No description provided for @productAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get productAddToCart;

  /// No description provided for @productAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get productAddFavorite;

  /// No description provided for @productRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get productRemoveFavorite;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @productNotFoundText.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed from the catalog.'**
  String get productNotFoundText;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmpty;

  /// No description provided for @favoritesEmptyText.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any product to save it here.'**
  String get favoritesEmptyText;

  /// No description provided for @favoritesBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse products'**
  String get favoritesBrowse;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyText.
  ///
  /// In en, this message translates to:
  /// **'Add something you like and it will appear here.'**
  String get cartEmptyText;

  /// No description provided for @cartStartShopping.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get cartStartShopping;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout · {price}'**
  String cartCheckout(String price);

  /// No description provided for @cartRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} removed'**
  String cartRemoved(String name);

  /// No description provided for @cartPromoHint.
  ///
  /// In en, this message translates to:
  /// **'Promo code'**
  String get cartPromoHint;

  /// No description provided for @cartPromoUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown code. Try SALE10'**
  String get cartPromoUnknown;

  /// No description provided for @cartPromoApplied.
  ///
  /// In en, this message translates to:
  /// **'{code} applied'**
  String cartPromoApplied(String code);

  /// No description provided for @cartPromoOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off your items'**
  String cartPromoOff(String percent);

  /// No description provided for @cartPromoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove code'**
  String get cartPromoRemove;

  /// No description provided for @cartSubtotal.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Subtotal (1 item)} other{Subtotal ({count} items)}}'**
  String cartSubtotal(int count);

  /// No description provided for @cartDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get cartDiscount;

  /// No description provided for @cartDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get cartDelivery;

  /// No description provided for @cartFreeDeliveryHint.
  ///
  /// In en, this message translates to:
  /// **'Add {amount} more for free delivery'**
  String cartFreeDeliveryHint(String amount);

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get checkoutAddress;

  /// No description provided for @checkoutPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get checkoutPhone;

  /// No description provided for @checkoutPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+998 90 123 45 67'**
  String get checkoutPhoneHint;

  /// No description provided for @checkoutCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get checkoutCity;

  /// No description provided for @checkoutDefaultCity.
  ///
  /// In en, this message translates to:
  /// **'Tashkent'**
  String get checkoutDefaultCity;

  /// No description provided for @checkoutStreet.
  ///
  /// In en, this message translates to:
  /// **'Street, house, apartment'**
  String get checkoutStreet;

  /// No description provided for @checkoutDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get checkoutDeliveryTitle;

  /// No description provided for @checkoutStandardFree.
  ///
  /// In en, this message translates to:
  /// **'Standard · Free'**
  String get checkoutStandardFree;

  /// No description provided for @checkoutStandardPrice.
  ///
  /// In en, this message translates to:
  /// **'Standard · {price}'**
  String checkoutStandardPrice(String price);

  /// No description provided for @checkoutExpress.
  ///
  /// In en, this message translates to:
  /// **'Express · +{price}'**
  String checkoutExpress(String price);

  /// No description provided for @checkoutPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get checkoutPayment;

  /// No description provided for @checkoutCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get checkoutCash;

  /// No description provided for @checkoutCard.
  ///
  /// In en, this message translates to:
  /// **'Card on delivery'**
  String get checkoutCard;

  /// No description provided for @checkoutPayNote.
  ///
  /// In en, this message translates to:
  /// **'You pay when the order arrives. No payment is taken in the app.'**
  String get checkoutPayNote;

  /// No description provided for @checkoutSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get checkoutSummary;

  /// No description provided for @checkoutPlace.
  ///
  /// In en, this message translates to:
  /// **'Place order · {price}'**
  String checkoutPlace(String price);

  /// No description provided for @checkoutLocation.
  ///
  /// In en, this message translates to:
  /// **'Delivery point'**
  String get checkoutLocation;

  /// No description provided for @checkoutPickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Choose on map'**
  String get checkoutPickOnMap;

  /// No description provided for @checkoutChangeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get checkoutChangeLocation;

  /// No description provided for @checkoutLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Mark your entrance on the map so the courier finds you faster.'**
  String get checkoutLocationHint;

  /// No description provided for @paymentCashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery'**
  String get paymentCashOnDelivery;

  /// No description provided for @paymentCardOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Card on delivery'**
  String get paymentCardOnDelivery;

  /// No description provided for @deliveryStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get deliveryStandard;

  /// No description provided for @deliveryExpress.
  ///
  /// In en, this message translates to:
  /// **'Express'**
  String get deliveryExpress;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Order placed!'**
  String get successTitle;

  /// No description provided for @successText.
  ///
  /// In en, this message translates to:
  /// **'Order {number} · {total}\nYou can follow it in Profile → My orders.'**
  String successText(String number, String total);

  /// No description provided for @successContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get successContinue;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get ordersTitle;

  /// No description provided for @ordersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get ordersEmpty;

  /// No description provided for @ordersEmptyText.
  ///
  /// In en, this message translates to:
  /// **'Your placed orders will show up here.'**
  String get ordersEmptyText;

  /// No description provided for @ordersNumber.
  ///
  /// In en, this message translates to:
  /// **'Order {number}'**
  String ordersNumber(String number);

  /// No description provided for @ordersItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String ordersItems(int count);

  /// No description provided for @ordersPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get ordersPayment;

  /// No description provided for @ordersCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get ordersCancel;

  /// No description provided for @ordersCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get ordersCancelTitle;

  /// No description provided for @ordersCancelText.
  ///
  /// In en, this message translates to:
  /// **'Order {number} will be cancelled.'**
  String ordersCancelText(String number);

  /// No description provided for @ordersKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep order'**
  String get ordersKeep;

  /// No description provided for @ordersOnMap.
  ///
  /// In en, this message translates to:
  /// **'Delivery point marked on the map'**
  String get ordersOnMap;

  /// No description provided for @statusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get statusProcessing;

  /// No description provided for @statusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get statusShipped;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get profileOrders;

  /// No description provided for @profileFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get profileFavorites;

  /// No description provided for @profileFurnish.
  ///
  /// In en, this message translates to:
  /// **'Furnish a room from a photo'**
  String get profileFurnish;

  /// No description provided for @profileMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get profileMyOrders;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get profileAbout;

  /// No description provided for @profileAboutText.
  ///
  /// In en, this message translates to:
  /// **'Photos: Unsplash. Room analysis: Google Gemini. Maps: © OpenStreetMap contributors.'**
  String get profileAboutText;

  /// No description provided for @profileTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get languageSystem;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get profileSignOutTitle;

  /// No description provided for @profileSignOutText.
  ///
  /// In en, this message translates to:
  /// **'Your cart, favorites and orders stay in your account.'**
  String get profileSignOutText;

  /// No description provided for @roomTitle.
  ///
  /// In en, this message translates to:
  /// **'Furnish your room'**
  String get roomTitle;

  /// No description provided for @roomStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get roomStartOver;

  /// No description provided for @roomIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo in, furniture set out'**
  String get roomIntroTitle;

  /// No description provided for @roomIntroText.
  ///
  /// In en, this message translates to:
  /// **'We read the style, colours and size of your room and pick furniture that belongs there.'**
  String get roomIntroText;

  /// No description provided for @roomTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get roomTakePhoto;

  /// No description provided for @roomGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get roomGallery;

  /// No description provided for @roomTips.
  ///
  /// In en, this message translates to:
  /// **'For the best result'**
  String get roomTips;

  /// No description provided for @roomTipCorner.
  ///
  /// In en, this message translates to:
  /// **'Stand in a corner and show the whole room'**
  String get roomTipCorner;

  /// No description provided for @roomTipLight.
  ///
  /// In en, this message translates to:
  /// **'Use daylight and keep the photo sharp'**
  String get roomTipLight;

  /// No description provided for @roomTipDoor.
  ///
  /// In en, this message translates to:
  /// **'Include a door or window: it helps estimate the size'**
  String get roomTipDoor;

  /// No description provided for @roomPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your photo is sent to Google Gemini through Firebase to read the room. It is not saved in your account.'**
  String get roomPrivacy;

  /// No description provided for @roomReading.
  ///
  /// In en, this message translates to:
  /// **'Reading your room…'**
  String get roomReading;

  /// No description provided for @roomReadingText.
  ///
  /// In en, this message translates to:
  /// **'Looking at the style, colours and size. This takes a few seconds.'**
  String get roomReadingText;

  /// No description provided for @roomFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read the room'**
  String get roomFailed;

  /// No description provided for @roomAnotherPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose another photo'**
  String get roomAnotherPhoto;

  /// No description provided for @roomYourRoom.
  ///
  /// In en, this message translates to:
  /// **'Your room'**
  String get roomYourRoom;

  /// No description provided for @roomType.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get roomType;

  /// No description provided for @roomStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get roomStyle;

  /// No description provided for @roomColours.
  ///
  /// In en, this message translates to:
  /// **'Colours'**
  String get roomColours;

  /// No description provided for @roomSize.
  ///
  /// In en, this message translates to:
  /// **'Room size'**
  String get roomSize;

  /// No description provided for @roomWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get roomWidth;

  /// No description provided for @roomLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get roomLength;

  /// No description provided for @roomDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease {label}'**
  String roomDecrease(String label);

  /// No description provided for @roomIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase {label}'**
  String roomIncrease(String label);

  /// No description provided for @roomSizeHigh.
  ///
  /// In en, this message translates to:
  /// **'Size confirmed.'**
  String get roomSizeHigh;

  /// No description provided for @roomSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Size is estimated from the photo. Adjust it if you know better.'**
  String get roomSizeMedium;

  /// No description provided for @roomSizeLow.
  ///
  /// In en, this message translates to:
  /// **'Size is a rough guess from the photo. Please set the real size.'**
  String get roomSizeLow;

  /// No description provided for @roomSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Your furniture set'**
  String get roomSetTitle;

  /// No description provided for @roomSetFor.
  ///
  /// In en, this message translates to:
  /// **'Picked for: {room} · {style} · {size}'**
  String roomSetFor(String room, String style, String size);

  /// No description provided for @roomNothingFits.
  ///
  /// In en, this message translates to:
  /// **'Nothing fits yet'**
  String get roomNothingFits;

  /// No description provided for @roomNothingFitsText.
  ///
  /// In en, this message translates to:
  /// **'No product in the catalog fits this room size. Check the room size above.'**
  String get roomNothingFitsText;

  /// No description provided for @roomSlotUnfilled.
  ///
  /// In en, this message translates to:
  /// **'Nothing in the catalog fits here: {slot}'**
  String roomSlotUnfilled(String slot);

  /// No description provided for @roomFloorCrowded.
  ///
  /// In en, this message translates to:
  /// **'Furniture covers {percent}% of the floor: the room may feel crowded.'**
  String roomFloorCrowded(String percent);

  /// No description provided for @roomFloorOk.
  ///
  /// In en, this message translates to:
  /// **'Furniture covers {percent}% of the floor: plenty of space to move.'**
  String roomFloorOk(String percent);

  /// No description provided for @roomSetTotal.
  ///
  /// In en, this message translates to:
  /// **'Set total'**
  String get roomSetTotal;

  /// No description provided for @roomAddAll.
  ///
  /// In en, this message translates to:
  /// **'Add all to cart'**
  String get roomAddAll;

  /// No description provided for @roomPiecesAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 piece added to your cart} other{{count} pieces added to your cart}}'**
  String roomPiecesAdded(int count);

  /// No description provided for @roomOtherOptions.
  ///
  /// In en, this message translates to:
  /// **'Other options'**
  String get roomOtherOptions;

  /// No description provided for @roomQuantityPrice.
  ///
  /// In en, this message translates to:
  /// **'{quantity} × {price} = {total}'**
  String roomQuantityPrice(String quantity, String price, String total);

  /// No description provided for @roomTypeLiving.
  ///
  /// In en, this message translates to:
  /// **'Living room'**
  String get roomTypeLiving;

  /// No description provided for @roomTypeBedroom.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get roomTypeBedroom;

  /// No description provided for @roomTypeDining.
  ///
  /// In en, this message translates to:
  /// **'Dining room'**
  String get roomTypeDining;

  /// No description provided for @roomTypeOffice.
  ///
  /// In en, this message translates to:
  /// **'Home office'**
  String get roomTypeOffice;

  /// No description provided for @styleModern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get styleModern;

  /// No description provided for @styleScandinavian.
  ///
  /// In en, this message translates to:
  /// **'Scandinavian'**
  String get styleScandinavian;

  /// No description provided for @styleMinimalist.
  ///
  /// In en, this message translates to:
  /// **'Minimalist'**
  String get styleMinimalist;

  /// No description provided for @styleClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get styleClassic;

  /// No description provided for @styleIndustrial.
  ///
  /// In en, this message translates to:
  /// **'Industrial'**
  String get styleIndustrial;

  /// No description provided for @styleRustic.
  ///
  /// In en, this message translates to:
  /// **'Rustic'**
  String get styleRustic;

  /// No description provided for @styleMidCentury.
  ///
  /// In en, this message translates to:
  /// **'Mid-century'**
  String get styleMidCentury;

  /// No description provided for @slotSofa.
  ///
  /// In en, this message translates to:
  /// **'Sofa'**
  String get slotSofa;

  /// No description provided for @slotArmchair.
  ///
  /// In en, this message translates to:
  /// **'Armchair'**
  String get slotArmchair;

  /// No description provided for @slotCoffeeTable.
  ///
  /// In en, this message translates to:
  /// **'Coffee table'**
  String get slotCoffeeTable;

  /// No description provided for @slotLighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get slotLighting;

  /// No description provided for @slotStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get slotStorage;

  /// No description provided for @slotBed.
  ///
  /// In en, this message translates to:
  /// **'Bed'**
  String get slotBed;

  /// No description provided for @slotReadingChair.
  ///
  /// In en, this message translates to:
  /// **'Reading chair'**
  String get slotReadingChair;

  /// No description provided for @slotDiningTable.
  ///
  /// In en, this message translates to:
  /// **'Dining table'**
  String get slotDiningTable;

  /// No description provided for @slotDiningChairs.
  ///
  /// In en, this message translates to:
  /// **'Dining chairs'**
  String get slotDiningChairs;

  /// No description provided for @slotDesk.
  ///
  /// In en, this message translates to:
  /// **'Desk'**
  String get slotDesk;

  /// No description provided for @slotDeskChair.
  ///
  /// In en, this message translates to:
  /// **'Chair'**
  String get slotDeskChair;

  /// No description provided for @slotShelving.
  ///
  /// In en, this message translates to:
  /// **'Shelving'**
  String get slotShelving;

  /// No description provided for @reasonSameStyle.
  ///
  /// In en, this message translates to:
  /// **'Matches your {style} style'**
  String reasonSameStyle(String style);

  /// No description provided for @reasonSecondaryStyle.
  ///
  /// In en, this message translates to:
  /// **'Fits the {style} touch of your room'**
  String reasonSecondaryStyle(String style);

  /// No description provided for @reasonRelatedStyle.
  ///
  /// In en, this message translates to:
  /// **'Pairs well with {style} interiors'**
  String reasonRelatedStyle(String style);

  /// No description provided for @reasonColor.
  ///
  /// In en, this message translates to:
  /// **'{color} goes with your {tones} tones'**
  String reasonColor(String color, String tones);

  /// No description provided for @reasonColorPlain.
  ///
  /// In en, this message translates to:
  /// **'{color} suits the room colours'**
  String reasonColorPlain(String color);

  /// No description provided for @reasonSize.
  ///
  /// In en, this message translates to:
  /// **'{width} cm wide, about {percent}% of the floor'**
  String reasonSize(String width, String percent);

  /// No description provided for @reasonNoFloor.
  ///
  /// In en, this message translates to:
  /// **'Takes no floor space'**
  String get reasonNoFloor;

  /// No description provided for @reasonTonesJoin.
  ///
  /// In en, this message translates to:
  /// **'{first} and {second}'**
  String reasonTonesJoin(String first, String second);

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery point'**
  String get locationTitle;

  /// No description provided for @locationMyPosition.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get locationMyPosition;

  /// No description provided for @locationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Deliver here'**
  String get locationConfirm;

  /// No description provided for @locationFinding.
  ///
  /// In en, this message translates to:
  /// **'Finding the address…'**
  String get locationFinding;

  /// No description provided for @locationMoveHint.
  ///
  /// In en, this message translates to:
  /// **'Move the map to put the pin on your entrance'**
  String get locationMoveHint;

  /// No description provided for @locationNoAddress.
  ///
  /// In en, this message translates to:
  /// **'No address here, but you can still use this point.'**
  String get locationNoAddress;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
