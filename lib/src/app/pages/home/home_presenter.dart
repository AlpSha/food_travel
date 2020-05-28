import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/usecases/get_products_list_on_current_country.dart';

class HomePresenter extends Presenter {
  Function getProductsOnNext;
  Function getProductsOnError;

  GetProductsListOnCurrentCountry getProductsListOnCurrentCountry;

  HomePresenter(productRepository)
      : getProductsListOnCurrentCountry =
            GetProductsListOnCurrentCountry(productRepository);

  void startSyncingProducts() {
    getProductsListOnCurrentCountry
        .execute(GetProductsListOnCurrentCountryObserver(this));
  }

  @override
  void dispose() {
    getProductsListOnCurrentCountry.dispose();
  }
}

class GetProductsListOnCurrentCountryObserver extends Observer<List<Product>> {
  final HomePresenter _presenter;

  GetProductsListOnCurrentCountryObserver(this._presenter);

  @override
  void onComplete() {
    print('completed');
  }

  @override
  void onError(e) {
    assert(_presenter.getProductsOnError != null);
    _presenter.getProductsOnError(e);
  }

  @override
  void onNext(List<Product> products) {
    assert(_presenter.getProductsOnNext != null);
    _presenter.getProductsOnNext(products);
  }
}
