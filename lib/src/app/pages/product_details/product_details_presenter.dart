import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/usecases/get_products_on_list.dart';

class ProductDetailsPresenter extends Presenter {
  Function getProductsOnListOnNext;
  Function getProductsOnListOnError;

  final GetProductsOnList _getProductsOnList;

  ProductDetailsPresenter(
    productRepository,
    shoppingRepository,
  ) : _getProductsOnList = GetProductsOnList(shoppingRepository);

  void startSyncingShoppingList() {
    _getProductsOnList.execute(GetProductsOnListObserver(this));
  }

  @override
  void dispose() {
    _getProductsOnList.dispose();
  }
}

class GetProductsOnListObserver extends Observer<List<Product>> {
  final ProductDetailsPresenter _presenter;

  GetProductsOnListObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    assert(_presenter.getProductsOnListOnError != null);
    _presenter.getProductsOnListOnError(e);
  }

  @override
  void onNext(List<Product> products) {
    assert(_presenter.getProductsOnListOnNext != null);
    _presenter.getProductsOnListOnNext(products);
  }

}
