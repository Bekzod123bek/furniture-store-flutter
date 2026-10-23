import 'package:furniture_store/features/catalog/domain/entities/design_style.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_category.dart';
import 'package:furniture_store/features/catalog/domain/entities/product_filter.dart';
import 'package:furniture_store/l10n/app_localizations.dart';

extension ProductCategoryLabel on ProductCategory {
  String label(AppLocalizations l10n) => switch (this) {
    ProductCategory.sofa => l10n.categorySofa,
    ProductCategory.armchair => l10n.categoryArmchair,
    ProductCategory.chair => l10n.categoryChair,
    ProductCategory.table => l10n.categoryTable,
    ProductCategory.bed => l10n.categoryBed,
    ProductCategory.lamp => l10n.categoryLamp,
    ProductCategory.storage => l10n.categoryStorage,
  };
}

extension SortOptionLabel on SortOption {
  String label(AppLocalizations l10n) => switch (this) {
    SortOption.popular => l10n.sortPopular,
    SortOption.newest => l10n.sortNewest,
    SortOption.priceAsc => l10n.sortPriceAsc,
    SortOption.priceDesc => l10n.sortPriceDesc,
    SortOption.rating => l10n.sortRating,
  };
}

extension DesignStyleLabel on DesignStyle {
  String label(AppLocalizations l10n) => switch (this) {
    DesignStyle.modern => l10n.styleModern,
    DesignStyle.scandinavian => l10n.styleScandinavian,
    DesignStyle.minimalist => l10n.styleMinimalist,
    DesignStyle.classic => l10n.styleClassic,
    DesignStyle.industrial => l10n.styleIndustrial,
    DesignStyle.rustic => l10n.styleRustic,
    DesignStyle.midCentury => l10n.styleMidCentury,
  };
}
