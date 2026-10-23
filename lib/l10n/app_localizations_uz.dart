// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'Furniture Store';

  @override
  String get commonRetry => 'Qayta urinish';

  @override
  String get commonCouldNotLoad => 'Yuklab boʻlmadi';

  @override
  String get commonCancel => 'Bekor qilish';

  @override
  String get commonClose => 'Yopish';

  @override
  String get commonBack => 'Orqaga';

  @override
  String get commonFree => 'Bepul';

  @override
  String get commonTotal => 'Jami';

  @override
  String get commonApply => 'Qoʻllash';

  @override
  String get commonReset => 'Tozalash';

  @override
  String get commonUndo => 'Qaytarish';

  @override
  String get commonRemove => 'Oʻchirish';

  @override
  String get commonIncrease => 'Koʻpaytirish';

  @override
  String get commonDecrease => 'Kamaytirish';

  @override
  String get commonHello => 'Salom 👋';

  @override
  String commonHelloName(String name) {
    return 'Salom, $name 👋';
  }

  @override
  String get errorNetwork =>
      'Internet aloqasi yoʻq. Tekshirib, qayta urinib koʻring.';

  @override
  String get errorServer =>
      'Server javob bermayapti. Birozdan keyin urinib koʻring.';

  @override
  String get errorCache => 'Qurilmada saqlangan maʼlumotni oʻqib boʻlmadi.';

  @override
  String get errorNotFound => 'Hech narsa topilmadi.';

  @override
  String get errorInvalidCredentials => 'Email yoki parol notoʻgʻri.';

  @override
  String get errorUnexpected => 'Nimadir xato ketdi. Qayta urinib koʻring.';

  @override
  String get errorEmptyCart => 'Savatchangiz boʻsh.';

  @override
  String get errorIncompleteAddress => 'Yetkazish manzilini toʻldiring.';

  @override
  String get errorOrderNotCancellable =>
      'Bu buyurtmani endi bekor qilib boʻlmaydi.';

  @override
  String get errorEmailInUse =>
      'Bu email allaqachon roʻyxatdan oʻtgan. Kirib koʻring.';

  @override
  String get errorWeakPassword =>
      'Kuchliroq parol tanlang (kamida 6 ta belgi).';

  @override
  String get errorInvalidEmail => 'Toʻgʻri email kiriting.';

  @override
  String get errorAccountDisabled => 'Bu akkaunt oʻchirilgan.';

  @override
  String get errorTooManyAttempts =>
      'Juda koʻp urinish. Bir necha daqiqa kutib, qayta urinib koʻring.';

  @override
  String get errorSignInAgain => 'Buning uchun qaytadan kiring.';

  @override
  String get errorSignedOut => 'Siz akkauntdan chiqqansiz.';

  @override
  String get errorPhotoTooLarge => 'Rasm juda katta (10 MB dan ortiq).';

  @override
  String get errorPhotoAccess =>
      'Kamera yoki galereyaga ruxsat berilmagan. Telefon sozlamalarida ruxsat bering.';

  @override
  String get errorPhotoUnreadable =>
      'Rasmni tahlil qilib boʻlmadi. Boshqa rasm tanlang.';

  @override
  String get errorNotARoom =>
      'Bu xona ichiga oʻxshamaydi. Jihozlamoqchi boʻlgan xonangizni rasmga oling.';

  @override
  String get errorAnalysisLimit =>
      'Rasm tahlili limiti hozircha tugadi. Keyinroq urinib koʻring.';

  @override
  String get errorLocationOff =>
      'Joylashuv (GPS) oʻchiq. Uni yoqib, qayta urinib koʻring.';

  @override
  String get errorLocationDenied => 'Joylashuvga ruxsat berilmadi.';

  @override
  String get errorLocationDeniedForever =>
      'Joylashuvga ruxsat bloklangan. Telefon sozlamalarida ruxsat bering.';

  @override
  String get validationRequired => 'Toʻldirish shart';

  @override
  String get validationName => 'Ismingizni kiriting';

  @override
  String get validationEmail => 'Toʻgʻri email kiriting';

  @override
  String validationPassword(String min) {
    return 'Kamida $min ta belgi';
  }

  @override
  String get validationPhone => 'Toʻgʻri telefon raqam kiriting';

  @override
  String get onboardingSkip => 'Oʻtkazib yuborish';

  @override
  String get onboardingNext => 'Keyingi';

  @override
  String get onboardingStart => 'Boshlash';

  @override
  String get onboarding1Title => 'Uyingizga mos mebel';

  @override
  String get onboarding1Text =>
      'Ishonchli ustalardan tanlab olingan divan, stul va stollar.';

  @override
  String get onboarding2Title => 'Xonangizni AI jihozlab beradi';

  @override
  String get onboarding2Text =>
      'Xonangizni rasmga oling va mos toʻplamni oling: uslubingiz, ranglaringiz, toʻgʻri oʻlcham.';

  @override
  String get onboarding3Title => 'Eshigingizgacha yetkazamiz';

  @override
  String onboarding3Text(String amount) {
    return '$amount dan ortiq buyurtmalarga bepul yetkazish. Kirish joyingizni xaritada belgilang.';
  }

  @override
  String get loginWelcome => 'Xush kelibsiz';

  @override
  String get loginWelcomeText => 'Xaridni davom ettirish uchun kiring.';

  @override
  String get loginCreateTitle => 'Akkaunt yaratish';

  @override
  String get loginCreateText =>
      'Sevimlilarni saqlash va buyurtmalarni kuzatish uchun roʻyxatdan oʻting.';

  @override
  String get loginSignIn => 'Kirish';

  @override
  String get loginRegister => 'Roʻyxatdan oʻtish';

  @override
  String get loginCreateButton => 'Akkaunt yaratish';

  @override
  String get loginFullName => 'Ism familiya';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Parol';

  @override
  String get loginShowPassword => 'Parolni koʻrsatish';

  @override
  String get loginHidePassword => 'Parolni yashirish';

  @override
  String get loginForgot => 'Parolni unutdingizmi?';

  @override
  String get loginEnterEmailFirst => 'Avval yuqoriga emailingizni kiriting';

  @override
  String loginResetSent(String email) {
    return 'Parolni tiklash havolasi $email manziliga yuborildi';
  }

  @override
  String get navHome => 'Asosiy';

  @override
  String get navFavorites => 'Sevimli';

  @override
  String get navCart => 'Savatcha';

  @override
  String get navProfile => 'Profil';

  @override
  String get navScan => 'AI xona';

  @override
  String get homeTitle => 'Oʻzingizga yoqqan mebelni toping';

  @override
  String get homeSearchHint => 'Divan, eman, chiroq qidiring…';

  @override
  String get homeClearSearch => 'Qidiruvni tozalash';

  @override
  String get homeFilters => 'Filtrlar';

  @override
  String get homeRoomCardTitle => 'Xonangizni rasm orqali jihozlang';

  @override
  String get homeRoomCardText =>
      'AI uslubingiz, ranglar va oʻlchamga mos mebel tanlaydi';

  @override
  String get homeRoomCardAction => 'Sinab koʻrish';

  @override
  String get homeLoading => 'Yuklanmoqda…';

  @override
  String get homePopular => 'Hozir mashhur';

  @override
  String homeResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta natija',
      zero: 'Natija yoʻq',
    );
    return '$_temp0';
  }

  @override
  String get homeSort => 'Saralash';

  @override
  String get homeEmptyCatalog => 'Hozircha mahsulot yoʻq';

  @override
  String get homeEmptyCatalogText =>
      'Katalog boʻsh. Yangilash uchun pastga torting.';

  @override
  String get homeNothingFound => 'Hech narsa topilmadi';

  @override
  String get homeNothingFoundText =>
      'Boshqa soʻz bilan qidiring yoki filtrlarni tozalang.';

  @override
  String get homeResetFilters => 'Filtrlarni tozalash';

  @override
  String get homeAllCategories => 'Hammasi';

  @override
  String get homeShopNow => 'Koʻrish';

  @override
  String get categorySofa => 'Divanlar';

  @override
  String get categoryArmchair => 'Kreslolar';

  @override
  String get categoryChair => 'Stullar';

  @override
  String get categoryTable => 'Stollar';

  @override
  String get categoryBed => 'Karavotlar';

  @override
  String get categoryLamp => 'Chiroqlar';

  @override
  String get categoryStorage => 'Shkaflar';

  @override
  String get sortPopular => 'Mashhur';

  @override
  String get sortNewest => 'Yangilari';

  @override
  String get sortPriceAsc => 'Avval arzonlari';

  @override
  String get sortPriceDesc => 'Avval qimmatlari';

  @override
  String get sortRating => 'Reyting boʻyicha';

  @override
  String get filterTitle => 'Filtrlar';

  @override
  String get filterPrice => 'Narx';

  @override
  String get filterMaterial => 'Material';

  @override
  String get filterRating => 'Reyting';

  @override
  String get filterAnyRating => 'Istalgan';

  @override
  String get filterOnSale => 'Faqat chegirmadagilar';

  @override
  String get filterShow => 'Natijalarni koʻrsatish';

  @override
  String get productNew => 'YANGI';

  @override
  String productRatingReviews(String rating, String reviews) {
    return '$rating · $reviews ta sharh';
  }

  @override
  String productSave(String percent) {
    return '$percent% tejang';
  }

  @override
  String productColour(String name) {
    return 'Rang: $name';
  }

  @override
  String get productAbout => 'Tavsif';

  @override
  String get productMaterial => 'Material';

  @override
  String get productSize => 'Oʻlcham';

  @override
  String get productDelivery => 'Yetkazish';

  @override
  String get productDeliveryDays => '3–5 kun';

  @override
  String get productReviews => 'Sharhlar';

  @override
  String productReviewsTotal(String total) {
    return 'jami $total ta';
  }

  @override
  String get productRelated => 'Sizga yoqishi mumkin';

  @override
  String productAdd(String price) {
    return 'Qoʻshish · $price';
  }

  @override
  String productAdded(String quantity, String name) {
    return '$quantity × $name savatchaga qoʻshildi';
  }

  @override
  String get productAddToCart => 'Savatchaga qoʻshish';

  @override
  String get productAddFavorite => 'Sevimlilarga qoʻshish';

  @override
  String get productRemoveFavorite => 'Sevimlilardan olib tashlash';

  @override
  String get productNotFound => 'Mahsulot topilmadi';

  @override
  String get productNotFoundText =>
      'U katalogdan olib tashlangan boʻlishi mumkin.';

  @override
  String get favoritesTitle => 'Sevimlilar';

  @override
  String get favoritesEmpty => 'Hali sevimlilar yoʻq';

  @override
  String get favoritesEmptyText =>
      'Saqlash uchun istalgan mahsulotdagi yurakchani bosing.';

  @override
  String get favoritesBrowse => 'Mahsulotlarni koʻrish';

  @override
  String get cartTitle => 'Savatcha';

  @override
  String get cartEmpty => 'Savatchangiz boʻsh';

  @override
  String get cartEmptyText =>
      'Yoqqan narsani qoʻshing, u shu yerda paydo boʻladi.';

  @override
  String get cartStartShopping => 'Xaridni boshlash';

  @override
  String cartCheckout(String price) {
    return 'Rasmiylashtirish · $price';
  }

  @override
  String cartRemoved(String name) {
    return '$name olib tashlandi';
  }

  @override
  String get cartPromoHint => 'Promo-kod';

  @override
  String get cartPromoUnknown => 'Bunday kod yoʻq. SALE10 ni sinab koʻring';

  @override
  String cartPromoApplied(String code) {
    return '$code qoʻllandi';
  }

  @override
  String cartPromoOff(String percent) {
    return 'Mahsulotlarga $percent% chegirma';
  }

  @override
  String get cartPromoRemove => 'Kodni olib tashlash';

  @override
  String cartSubtotal(int count) {
    return 'Mahsulotlar ($count ta)';
  }

  @override
  String get cartDiscount => 'Chegirma';

  @override
  String get cartDelivery => 'Yetkazish';

  @override
  String cartFreeDeliveryHint(String amount) {
    return 'Bepul yetkazish uchun yana $amount qoʻshing';
  }

  @override
  String get checkoutTitle => 'Rasmiylashtirish';

  @override
  String get checkoutAddress => 'Yetkazish manzili';

  @override
  String get checkoutPhone => 'Telefon';

  @override
  String get checkoutPhoneHint => '+998 90 123 45 67';

  @override
  String get checkoutCity => 'Shahar';

  @override
  String get checkoutDefaultCity => 'Toshkent';

  @override
  String get checkoutStreet => 'Koʻcha, uy, xonadon';

  @override
  String get checkoutDeliveryTitle => 'Yetkazish';

  @override
  String get checkoutStandardFree => 'Oddiy · Bepul';

  @override
  String checkoutStandardPrice(String price) {
    return 'Oddiy · $price';
  }

  @override
  String checkoutExpress(String price) {
    return 'Tezkor · +$price';
  }

  @override
  String get checkoutPayment => 'Toʻlov';

  @override
  String get checkoutCash => 'Naqd';

  @override
  String get checkoutCard => 'Yetkazilganda karta';

  @override
  String get checkoutPayNote =>
      'Toʻlov buyurtma yetib kelganda olinadi. Ilovada pul yechilmaydi.';

  @override
  String get checkoutSummary => 'Buyurtma';

  @override
  String checkoutPlace(String price) {
    return 'Buyurtma berish · $price';
  }

  @override
  String get checkoutLocation => 'Yetkazish nuqtasi';

  @override
  String get checkoutPickOnMap => 'Xaritadan tanlash';

  @override
  String get checkoutChangeLocation => 'Oʻzgartirish';

  @override
  String get checkoutLocationHint =>
      'Kuryer tezroq topishi uchun kirish joyini xaritada belgilang.';

  @override
  String get paymentCashOnDelivery => 'Yetkazilganda naqd';

  @override
  String get paymentCardOnDelivery => 'Yetkazilganda karta';

  @override
  String get deliveryStandard => 'Oddiy';

  @override
  String get deliveryExpress => 'Tezkor';

  @override
  String get successTitle => 'Buyurtma qabul qilindi!';

  @override
  String successText(String number, String total) {
    return 'Buyurtma $number · $total\nUni Profil → Buyurtmalarim boʻlimida kuzating.';
  }

  @override
  String get successContinue => 'Xaridni davom ettirish';

  @override
  String get ordersTitle => 'Buyurtmalarim';

  @override
  String get ordersEmpty => 'Hali buyurtma yoʻq';

  @override
  String get ordersEmptyText => 'Bergan buyurtmalaringiz shu yerda chiqadi.';

  @override
  String ordersNumber(String number) {
    return 'Buyurtma $number';
  }

  @override
  String ordersItems(int count) {
    return '$count ta mahsulot';
  }

  @override
  String get ordersPayment => 'Toʻlov';

  @override
  String get ordersCancel => 'Buyurtmani bekor qilish';

  @override
  String get ordersCancelTitle => 'Buyurtma bekor qilinsinmi?';

  @override
  String ordersCancelText(String number) {
    return '$number buyurtmasi bekor qilinadi.';
  }

  @override
  String get ordersKeep => 'Qoldirish';

  @override
  String get ordersOnMap => 'Yetkazish nuqtasi xaritada belgilangan';

  @override
  String get statusProcessing => 'Jarayonda';

  @override
  String get statusShipped => 'Joʻnatildi';

  @override
  String get statusDelivered => 'Yetkazildi';

  @override
  String get statusCancelled => 'Bekor qilindi';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileOrders => 'Buyurtmalar';

  @override
  String get profileFavorites => 'Sevimlilar';

  @override
  String get profileFurnish => 'Xonani rasm orqali jihozlash';

  @override
  String get profileMyOrders => 'Buyurtmalarim';

  @override
  String get profileAbout => 'Ilova haqida';

  @override
  String get profileAboutText =>
      'Rasmlar: Unsplash. Xona tahlili: Google Gemini. Xarita: © OpenStreetMap hissadorlari.';

  @override
  String get profileTheme => 'Mavzu';

  @override
  String get themeSystem => 'Tizim';

  @override
  String get themeLight => 'Yorugʻ';

  @override
  String get themeDark => 'Qorongʻi';

  @override
  String get profileLanguage => 'Til';

  @override
  String get languageSystem => 'Telefon';

  @override
  String get profileSignOut => 'Chiqish';

  @override
  String get profileSignOutTitle => 'Akkauntdan chiqasizmi?';

  @override
  String get profileSignOutText =>
      'Savatcha, sevimlilar va buyurtmalar akkauntingizda saqlanib qoladi.';

  @override
  String get roomTitle => 'Xonani jihozlash';

  @override
  String get roomStartOver => 'Qaytadan boshlash';

  @override
  String get roomIntroTitle => 'Rasm bering, toʻplamni oling';

  @override
  String get roomIntroText =>
      'Xonangiz uslubi, ranglari va oʻlchamini aniqlab, unga mos mebel tanlaymiz.';

  @override
  String get roomTakePhoto => 'Rasmga olish';

  @override
  String get roomGallery => 'Galereyadan tanlash';

  @override
  String get roomTips => 'Eng yaxshi natija uchun';

  @override
  String get roomTipCorner => 'Burchakda turib, butun xonani koʻrsating';

  @override
  String get roomTipLight => 'Kunduzgi yorugʻlikda, aniq rasm oling';

  @override
  String get roomTipDoor =>
      'Eshik yoki deraza tushsin: bu oʻlchamni aniqlashga yordam beradi';

  @override
  String get roomPrivacy =>
      'Xonani tahlil qilish uchun rasm Firebase orqali Google Gemini’ga yuboriladi. U akkauntingizda saqlanmaydi.';

  @override
  String get roomReading => 'Xonangiz tahlil qilinmoqda…';

  @override
  String get roomReadingText =>
      'Uslub, rang va oʻlcham aniqlanmoqda. Bu bir necha soniya oladi.';

  @override
  String get roomFailed => 'Xonani aniqlab boʻlmadi';

  @override
  String get roomAnotherPhoto => 'Boshqa rasm tanlash';

  @override
  String get roomYourRoom => 'Xonangiz';

  @override
  String get roomType => 'Xona';

  @override
  String get roomStyle => 'Uslub';

  @override
  String get roomColours => 'Ranglar';

  @override
  String get roomSize => 'Xona oʻlchami';

  @override
  String get roomWidth => 'Eni';

  @override
  String get roomLength => 'Boʻyi';

  @override
  String roomDecrease(String label) {
    return '$label: kamaytirish';
  }

  @override
  String roomIncrease(String label) {
    return '$label: koʻpaytirish';
  }

  @override
  String get roomSizeHigh => 'Oʻlcham tasdiqlangan.';

  @override
  String get roomSizeMedium =>
      'Oʻlcham rasmdan taxminan aniqlandi. Bilsangiz, toʻgʻrilang.';

  @override
  String get roomSizeLow =>
      'Oʻlcham rasmdan taxmin qilindi. Iltimos, haqiqiy oʻlchamni kiriting.';

  @override
  String get roomSetTitle => 'Mebel toʻplamingiz';

  @override
  String roomSetFor(String room, String style, String size) {
    return 'Tanlandi: $room · $style · $size';
  }

  @override
  String get roomNothingFits => 'Hozircha mos mebel yoʻq';

  @override
  String get roomNothingFitsText =>
      'Katalogdagi hech bir mahsulot bu oʻlchamga sigʻmaydi. Yuqoridagi xona oʻlchamini tekshiring.';

  @override
  String roomSlotUnfilled(String slot) {
    return 'Katalogda bu xonaga sigʻadigani yoʻq: $slot';
  }

  @override
  String roomFloorCrowded(String percent) {
    return 'Mebel polning $percent% ini egallaydi: xona tor boʻlib qolishi mumkin.';
  }

  @override
  String roomFloorOk(String percent) {
    return 'Mebel polning $percent% ini egallaydi: yurish uchun joy yetarli.';
  }

  @override
  String get roomSetTotal => 'Toʻplam narxi';

  @override
  String get roomAddAll => 'Hammasini savatchaga';

  @override
  String roomPiecesAdded(int count) {
    return 'Savatchaga $count ta mebel qoʻshildi';
  }

  @override
  String get roomOtherOptions => 'Boshqa variantlar';

  @override
  String roomQuantityPrice(String quantity, String price, String total) {
    return '$quantity × $price = $total';
  }

  @override
  String get roomTypeLiving => 'Mehmonxona';

  @override
  String get roomTypeBedroom => 'Yotoqxona';

  @override
  String get roomTypeDining => 'Ovqatlanish xonasi';

  @override
  String get roomTypeOffice => 'Ish xonasi';

  @override
  String get styleModern => 'Zamonaviy';

  @override
  String get styleScandinavian => 'Skandinav';

  @override
  String get styleMinimalist => 'Minimalizm';

  @override
  String get styleClassic => 'Klassik';

  @override
  String get styleIndustrial => 'Industrial';

  @override
  String get styleRustic => 'Rustik';

  @override
  String get styleMidCentury => 'Mid-century';

  @override
  String get slotSofa => 'Divan';

  @override
  String get slotArmchair => 'Kreslo';

  @override
  String get slotCoffeeTable => 'Jurnal stoli';

  @override
  String get slotLighting => 'Yoritish';

  @override
  String get slotStorage => 'Saqlash joyi';

  @override
  String get slotBed => 'Karavot';

  @override
  String get slotReadingChair => 'Kitob oʻqish kreslosi';

  @override
  String get slotDiningTable => 'Ovqat stoli';

  @override
  String get slotDiningChairs => 'Ovqat stullari';

  @override
  String get slotDesk => 'Ish stoli';

  @override
  String get slotDeskChair => 'Stul';

  @override
  String get slotShelving => 'Javonlar';

  @override
  String reasonSameStyle(String style) {
    return 'Xonangizdagi «$style» uslubiga mos';
  }

  @override
  String reasonSecondaryStyle(String style) {
    return 'Xonadagi «$style» elementlariga mos';
  }

  @override
  String reasonRelatedStyle(String style) {
    return '«$style» interyeri bilan yaxshi uygʻunlashadi';
  }

  @override
  String reasonColor(String color, String tones) {
    return '$color rangi xonadagi $tones ranglarga mos';
  }

  @override
  String reasonColorPlain(String color) {
    return '$color rangi xona ranglariga mos';
  }

  @override
  String reasonSize(String width, String percent) {
    return 'Eni $width sm, polning taxminan $percent% i';
  }

  @override
  String get reasonNoFloor => 'Poldan joy egallamaydi';

  @override
  String reasonTonesJoin(String first, String second) {
    return '$first va $second';
  }

  @override
  String get locationTitle => 'Yetkazish nuqtasi';

  @override
  String get locationMyPosition => 'Mening joylashuvim';

  @override
  String get locationConfirm => 'Shu yerga yetkazish';

  @override
  String get locationFinding => 'Manzil aniqlanmoqda…';

  @override
  String get locationMoveHint =>
      'Pinni kirish joyingizga qoʻyish uchun xaritani suring';

  @override
  String get locationNoAddress =>
      'Bu yerda manzil topilmadi, lekin nuqtani ishlatishingiz mumkin.';
}
