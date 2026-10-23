// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Furniture Store';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonCouldNotLoad => 'Не удалось загрузить';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonFree => 'Бесплатно';

  @override
  String get commonTotal => 'Итого';

  @override
  String get commonApply => 'Применить';

  @override
  String get commonReset => 'Сбросить';

  @override
  String get commonUndo => 'Вернуть';

  @override
  String get commonRemove => 'Удалить';

  @override
  String get commonIncrease => 'Увеличить';

  @override
  String get commonDecrease => 'Уменьшить';

  @override
  String get commonHello => 'Привет 👋';

  @override
  String commonHelloName(String name) {
    return 'Привет, $name 👋';
  }

  @override
  String get errorNetwork =>
      'Нет подключения к интернету. Проверьте его и попробуйте снова.';

  @override
  String get errorServer => 'Сервер не отвечает. Попробуйте позже.';

  @override
  String get errorCache => 'Не удалось прочитать данные на устройстве.';

  @override
  String get errorNotFound => 'Ничего не найдено.';

  @override
  String get errorInvalidCredentials => 'Неверный email или пароль.';

  @override
  String get errorUnexpected => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get errorEmptyCart => 'Ваша корзина пуста.';

  @override
  String get errorIncompleteAddress => 'Заполните адрес доставки.';

  @override
  String get errorOrderNotCancellable => 'Этот заказ уже нельзя отменить.';

  @override
  String get errorEmailInUse =>
      'Этот email уже зарегистрирован. Попробуйте войти.';

  @override
  String get errorWeakPassword =>
      'Выберите пароль надёжнее (не менее 6 символов).';

  @override
  String get errorInvalidEmail => 'Введите корректный email.';

  @override
  String get errorAccountDisabled => 'Этот аккаунт отключён.';

  @override
  String get errorTooManyAttempts =>
      'Слишком много попыток. Подождите несколько минут.';

  @override
  String get errorSignInAgain => 'Для этого войдите снова.';

  @override
  String get errorSignedOut => 'Вы вышли из аккаунта.';

  @override
  String get errorPhotoTooLarge => 'Фото слишком большое (больше 10 МБ).';

  @override
  String get errorPhotoAccess =>
      'Нет доступа к камере или фото. Разрешите его в настройках телефона.';

  @override
  String get errorPhotoUnreadable =>
      'Не удалось проанализировать фото. Попробуйте другое.';

  @override
  String get errorNotARoom =>
      'Это не похоже на комнату. Сфотографируйте комнату, которую хотите обставить.';

  @override
  String get errorAnalysisLimit =>
      'Лимит анализа фото пока исчерпан. Попробуйте позже.';

  @override
  String get errorLocationOff =>
      'Геолокация выключена. Включите её и попробуйте снова.';

  @override
  String get errorLocationDenied => 'Доступ к геолокации не разрешён.';

  @override
  String get errorLocationDeniedForever =>
      'Доступ к геолокации заблокирован. Разрешите его в настройках телефона.';

  @override
  String get validationRequired => 'Обязательное поле';

  @override
  String get validationName => 'Введите имя';

  @override
  String get validationEmail => 'Введите корректный email';

  @override
  String validationPassword(String min) {
    return 'Не менее $min символов';
  }

  @override
  String get validationPhone => 'Введите корректный номер телефона';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get onboarding1Title => 'Мебель, в которой уютно';

  @override
  String get onboarding1Text =>
      'Диваны, стулья и столы от проверенных мастеров.';

  @override
  String get onboarding2Title => 'ИИ обставит вашу комнату';

  @override
  String get onboarding2Text =>
      'Сфотографируйте комнату и получите подходящий набор: ваш стиль, ваши цвета, нужный размер.';

  @override
  String get onboarding3Title => 'Доставим до двери';

  @override
  String onboarding3Text(String amount) {
    return 'Бесплатная доставка заказов от $amount. Отметьте подъезд на карте.';
  }

  @override
  String get loginWelcome => 'С возвращением';

  @override
  String get loginWelcomeText => 'Войдите, чтобы продолжить покупки.';

  @override
  String get loginCreateTitle => 'Создать аккаунт';

  @override
  String get loginCreateText =>
      'Зарегистрируйтесь, чтобы сохранять избранное и следить за заказами.';

  @override
  String get loginSignIn => 'Войти';

  @override
  String get loginRegister => 'Регистрация';

  @override
  String get loginCreateButton => 'Создать аккаунт';

  @override
  String get loginFullName => 'Имя и фамилия';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginShowPassword => 'Показать пароль';

  @override
  String get loginHidePassword => 'Скрыть пароль';

  @override
  String get loginForgot => 'Забыли пароль?';

  @override
  String get loginEnterEmailFirst => 'Сначала введите email выше';

  @override
  String loginResetSent(String email) {
    return 'Ссылка для сброса пароля отправлена на $email';
  }

  @override
  String get navHome => 'Главная';

  @override
  String get navFavorites => 'Избранное';

  @override
  String get navCart => 'Корзина';

  @override
  String get navProfile => 'Профиль';

  @override
  String get navScan => 'ИИ-комната';

  @override
  String get homeTitle => 'Найдите мебель по душе';

  @override
  String get homeSearchHint => 'Поиск: диван, дуб, лампа…';

  @override
  String get homeClearSearch => 'Очистить поиск';

  @override
  String get homeFilters => 'Фильтры';

  @override
  String get homeRoomCardTitle => 'Обставьте комнату по фото';

  @override
  String get homeRoomCardText =>
      'ИИ подберёт мебель под ваш стиль, цвета и размер';

  @override
  String get homeRoomCardAction => 'Попробовать';

  @override
  String get homeLoading => 'Загрузка…';

  @override
  String get homePopular => 'Популярное';

  @override
  String homeResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count результата',
      many: '$count результатов',
      few: '$count результата',
      one: '$count результат',
      zero: 'Нет результатов',
    );
    return '$_temp0';
  }

  @override
  String get homeSort => 'Сортировка';

  @override
  String get homeEmptyCatalog => 'Пока нет товаров';

  @override
  String get homeEmptyCatalogText =>
      'Каталог пуст. Потяните вниз, чтобы обновить.';

  @override
  String get homeNothingFound => 'Ничего не найдено';

  @override
  String get homeNothingFoundText =>
      'Попробуйте другое слово или сбросьте фильтры.';

  @override
  String get homeResetFilters => 'Сбросить фильтры';

  @override
  String get homeAllCategories => 'Все';

  @override
  String get homeShopNow => 'Смотреть';

  @override
  String get categorySofa => 'Диваны';

  @override
  String get categoryArmchair => 'Кресла';

  @override
  String get categoryChair => 'Стулья';

  @override
  String get categoryTable => 'Столы';

  @override
  String get categoryBed => 'Кровати';

  @override
  String get categoryLamp => 'Светильники';

  @override
  String get categoryStorage => 'Хранение';

  @override
  String get sortPopular => 'Популярные';

  @override
  String get sortNewest => 'Новинки';

  @override
  String get sortPriceAsc => 'Сначала дешевле';

  @override
  String get sortPriceDesc => 'Сначала дороже';

  @override
  String get sortRating => 'По рейтингу';

  @override
  String get filterTitle => 'Фильтры';

  @override
  String get filterPrice => 'Цена';

  @override
  String get filterMaterial => 'Материал';

  @override
  String get filterRating => 'Рейтинг';

  @override
  String get filterAnyRating => 'Любой';

  @override
  String get filterOnSale => 'Только со скидкой';

  @override
  String get filterShow => 'Показать результаты';

  @override
  String get productNew => 'НОВИНКА';

  @override
  String productRatingReviews(String rating, String reviews) {
    return '$rating · отзывов: $reviews';
  }

  @override
  String productSave(String percent) {
    return 'Скидка $percent%';
  }

  @override
  String productColour(String name) {
    return 'Цвет: $name';
  }

  @override
  String get productAbout => 'Описание';

  @override
  String get productMaterial => 'Материал';

  @override
  String get productSize => 'Размер';

  @override
  String get productDelivery => 'Доставка';

  @override
  String get productDeliveryDays => '3–5 дней';

  @override
  String get productReviews => 'Отзывы';

  @override
  String productReviewsTotal(String total) {
    return 'всего $total';
  }

  @override
  String get productRelated => 'Вам может понравиться';

  @override
  String productAdd(String price) {
    return 'Добавить · $price';
  }

  @override
  String productAdded(String quantity, String name) {
    return '$quantity × $name — в корзине';
  }

  @override
  String get productAddToCart => 'В корзину';

  @override
  String get productAddFavorite => 'В избранное';

  @override
  String get productRemoveFavorite => 'Убрать из избранного';

  @override
  String get productNotFound => 'Товар не найден';

  @override
  String get productNotFoundText => 'Возможно, его убрали из каталога.';

  @override
  String get favoritesTitle => 'Избранное';

  @override
  String get favoritesEmpty => 'Пока ничего нет';

  @override
  String get favoritesEmptyText =>
      'Нажмите на сердечко, чтобы сохранить товар здесь.';

  @override
  String get favoritesBrowse => 'Смотреть товары';

  @override
  String get cartTitle => 'Корзина';

  @override
  String get cartEmpty => 'Корзина пуста';

  @override
  String get cartEmptyText =>
      'Добавьте то, что нравится, и оно появится здесь.';

  @override
  String get cartStartShopping => 'Начать покупки';

  @override
  String cartCheckout(String price) {
    return 'Оформить · $price';
  }

  @override
  String cartRemoved(String name) {
    return '$name — удалено';
  }

  @override
  String get cartPromoHint => 'Промокод';

  @override
  String get cartPromoUnknown => 'Нет такого кода. Попробуйте SALE10';

  @override
  String cartPromoApplied(String code) {
    return '$code применён';
  }

  @override
  String cartPromoOff(String percent) {
    return 'Скидка $percent% на товары';
  }

  @override
  String get cartPromoRemove => 'Удалить код';

  @override
  String cartSubtotal(int count) {
    return 'Товары ($count шт.)';
  }

  @override
  String get cartDiscount => 'Скидка';

  @override
  String get cartDelivery => 'Доставка';

  @override
  String cartFreeDeliveryHint(String amount) {
    return 'Добавьте ещё $amount для бесплатной доставки';
  }

  @override
  String get checkoutTitle => 'Оформление';

  @override
  String get checkoutAddress => 'Адрес доставки';

  @override
  String get checkoutPhone => 'Телефон';

  @override
  String get checkoutPhoneHint => '+998 90 123 45 67';

  @override
  String get checkoutCity => 'Город';

  @override
  String get checkoutDefaultCity => 'Ташкент';

  @override
  String get checkoutStreet => 'Улица, дом, квартира';

  @override
  String get checkoutDeliveryTitle => 'Доставка';

  @override
  String get checkoutStandardFree => 'Обычная · Бесплатно';

  @override
  String checkoutStandardPrice(String price) {
    return 'Обычная · $price';
  }

  @override
  String checkoutExpress(String price) {
    return 'Экспресс · +$price';
  }

  @override
  String get checkoutPayment => 'Оплата';

  @override
  String get checkoutCash => 'Наличные';

  @override
  String get checkoutCard => 'Картой курьеру';

  @override
  String get checkoutPayNote =>
      'Оплата при получении. В приложении деньги не списываются.';

  @override
  String get checkoutSummary => 'Итог';

  @override
  String checkoutPlace(String price) {
    return 'Оформить заказ · $price';
  }

  @override
  String get checkoutLocation => 'Точка доставки';

  @override
  String get checkoutPickOnMap => 'Выбрать на карте';

  @override
  String get checkoutChangeLocation => 'Изменить';

  @override
  String get checkoutLocationHint =>
      'Отметьте подъезд на карте, чтобы курьер быстрее вас нашёл.';

  @override
  String get paymentCashOnDelivery => 'Наличными при получении';

  @override
  String get paymentCardOnDelivery => 'Картой при получении';

  @override
  String get deliveryStandard => 'Обычная';

  @override
  String get deliveryExpress => 'Экспресс';

  @override
  String get successTitle => 'Заказ оформлен!';

  @override
  String successText(String number, String total) {
    return 'Заказ $number · $total\nСледите за ним в Профиль → Мои заказы.';
  }

  @override
  String get successContinue => 'Продолжить покупки';

  @override
  String get ordersTitle => 'Мои заказы';

  @override
  String get ordersEmpty => 'Заказов пока нет';

  @override
  String get ordersEmptyText => 'Здесь появятся ваши заказы.';

  @override
  String ordersNumber(String number) {
    return 'Заказ $number';
  }

  @override
  String ordersItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товара',
      many: '$count товаров',
      few: '$count товара',
      one: '$count товар',
    );
    return '$_temp0';
  }

  @override
  String get ordersPayment => 'Оплата';

  @override
  String get ordersCancel => 'Отменить заказ';

  @override
  String get ordersCancelTitle => 'Отменить заказ?';

  @override
  String ordersCancelText(String number) {
    return 'Заказ $number будет отменён.';
  }

  @override
  String get ordersKeep => 'Оставить';

  @override
  String get ordersOnMap => 'Точка доставки отмечена на карте';

  @override
  String get statusProcessing => 'В обработке';

  @override
  String get statusShipped => 'Отправлен';

  @override
  String get statusDelivered => 'Доставлен';

  @override
  String get statusCancelled => 'Отменён';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileOrders => 'Заказы';

  @override
  String get profileFavorites => 'Избранное';

  @override
  String get profileFurnish => 'Обставить комнату по фото';

  @override
  String get profileMyOrders => 'Мои заказы';

  @override
  String get profileAbout => 'О приложении';

  @override
  String get profileAboutText =>
      'Фото: Unsplash. Анализ комнаты: Google Gemini. Карты: © участники OpenStreetMap.';

  @override
  String get profileTheme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get languageSystem => 'Телефон';

  @override
  String get profileSignOut => 'Выйти';

  @override
  String get profileSignOutTitle => 'Выйти из аккаунта?';

  @override
  String get profileSignOutText =>
      'Корзина, избранное и заказы останутся в вашем аккаунте.';

  @override
  String get roomTitle => 'Обставить комнату';

  @override
  String get roomStartOver => 'Начать заново';

  @override
  String get roomIntroTitle => 'Фото на входе, мебель на выходе';

  @override
  String get roomIntroText =>
      'Мы определим стиль, цвета и размер комнаты и подберём подходящую мебель.';

  @override
  String get roomTakePhoto => 'Сфотографировать';

  @override
  String get roomGallery => 'Выбрать из галереи';

  @override
  String get roomTips => 'Для лучшего результата';

  @override
  String get roomTipCorner => 'Встаньте в угол и покажите всю комнату';

  @override
  String get roomTipLight => 'Снимайте при дневном свете и без размытия';

  @override
  String get roomTipDoor =>
      'Захватите дверь или окно: это помогает оценить размер';

  @override
  String get roomPrivacy =>
      'Фото отправляется в Google Gemini через Firebase для анализа комнаты. Оно не сохраняется в аккаунте.';

  @override
  String get roomReading => 'Анализируем комнату…';

  @override
  String get roomReadingText =>
      'Определяем стиль, цвета и размер. Это займёт несколько секунд.';

  @override
  String get roomFailed => 'Не удалось распознать комнату';

  @override
  String get roomAnotherPhoto => 'Выбрать другое фото';

  @override
  String get roomYourRoom => 'Ваша комната';

  @override
  String get roomType => 'Комната';

  @override
  String get roomStyle => 'Стиль';

  @override
  String get roomColours => 'Цвета';

  @override
  String get roomSize => 'Размер комнаты';

  @override
  String get roomWidth => 'Ширина';

  @override
  String get roomLength => 'Длина';

  @override
  String roomDecrease(String label) {
    return '$label: уменьшить';
  }

  @override
  String roomIncrease(String label) {
    return '$label: увеличить';
  }

  @override
  String get roomSizeHigh => 'Размер подтверждён.';

  @override
  String get roomSizeMedium =>
      'Размер оценён по фото. Поправьте, если знаете точнее.';

  @override
  String get roomSizeLow => 'Размер примерный. Пожалуйста, укажите реальный.';

  @override
  String get roomSetTitle => 'Ваш набор мебели';

  @override
  String roomSetFor(String room, String style, String size) {
    return 'Подобрано: $room · $style · $size';
  }

  @override
  String get roomNothingFits => 'Пока ничего не подходит';

  @override
  String get roomNothingFitsText =>
      'Ни один товар не помещается в комнату такого размера. Проверьте размер выше.';

  @override
  String roomSlotUnfilled(String slot) {
    return 'В каталоге нет подходящего: $slot';
  }

  @override
  String roomFloorCrowded(String percent) {
    return 'Мебель занимает $percent% пола: может быть тесно.';
  }

  @override
  String roomFloorOk(String percent) {
    return 'Мебель занимает $percent% пола: места достаточно.';
  }

  @override
  String get roomSetTotal => 'Сумма набора';

  @override
  String get roomAddAll => 'Всё в корзину';

  @override
  String roomPiecesAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'В корзину добавлено $count предмета',
      many: 'В корзину добавлено $count предметов',
      few: 'В корзину добавлено $count предмета',
      one: 'В корзину добавлен $count предмет',
    );
    return '$_temp0';
  }

  @override
  String get roomOtherOptions => 'Другие варианты';

  @override
  String roomQuantityPrice(String quantity, String price, String total) {
    return '$quantity × $price = $total';
  }

  @override
  String get roomTypeLiving => 'Гостиная';

  @override
  String get roomTypeBedroom => 'Спальня';

  @override
  String get roomTypeDining => 'Столовая';

  @override
  String get roomTypeOffice => 'Кабинет';

  @override
  String get styleModern => 'Современный';

  @override
  String get styleScandinavian => 'Скандинавский';

  @override
  String get styleMinimalist => 'Минимализм';

  @override
  String get styleClassic => 'Классический';

  @override
  String get styleIndustrial => 'Индустриальный';

  @override
  String get styleRustic => 'Рустик';

  @override
  String get styleMidCentury => 'Мид-сенчури';

  @override
  String get slotSofa => 'Диван';

  @override
  String get slotArmchair => 'Кресло';

  @override
  String get slotCoffeeTable => 'Журнальный столик';

  @override
  String get slotLighting => 'Освещение';

  @override
  String get slotStorage => 'Хранение';

  @override
  String get slotBed => 'Кровать';

  @override
  String get slotReadingChair => 'Кресло для чтения';

  @override
  String get slotDiningTable => 'Обеденный стол';

  @override
  String get slotDiningChairs => 'Обеденные стулья';

  @override
  String get slotDesk => 'Письменный стол';

  @override
  String get slotDeskChair => 'Стул';

  @override
  String get slotShelving => 'Стеллаж';

  @override
  String reasonSameStyle(String style) {
    return 'Подходит к стилю «$style»';
  }

  @override
  String reasonSecondaryStyle(String style) {
    return 'Сочетается с элементами «$style» в комнате';
  }

  @override
  String reasonRelatedStyle(String style) {
    return 'Хорошо смотрится в интерьере «$style»';
  }

  @override
  String reasonColor(String color, String tones) {
    return '$color сочетается с цветами комнаты: $tones';
  }

  @override
  String reasonColorPlain(String color) {
    return '$color подходит к цветам комнаты';
  }

  @override
  String reasonSize(String width, String percent) {
    return 'Ширина $width см, около $percent% пола';
  }

  @override
  String get reasonNoFloor => 'Не занимает место на полу';

  @override
  String reasonTonesJoin(String first, String second) {
    return '$first и $second';
  }

  @override
  String get locationTitle => 'Точка доставки';

  @override
  String get locationMyPosition => 'Моё местоположение';

  @override
  String get locationConfirm => 'Доставить сюда';

  @override
  String get locationFinding => 'Определяем адрес…';

  @override
  String get locationMoveHint =>
      'Двигайте карту, чтобы поставить метку на подъезд';

  @override
  String get locationNoAddress =>
      'Адрес здесь не найден, но точку можно использовать.';
}
