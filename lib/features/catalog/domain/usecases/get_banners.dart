import 'package:furniture_store/core/result/result.dart';
import 'package:furniture_store/core/usecase/usecase.dart';
import 'package:furniture_store/features/catalog/domain/entities/promo_banner.dart';
import 'package:furniture_store/features/catalog/domain/repositories/catalog_repository.dart';

class GetBanners implements UseCase<List<PromoBanner>, NoParams> {
  const GetBanners(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Result<List<PromoBanner>>> call(NoParams params) =>
      _repository.getBanners();
}
