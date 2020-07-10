import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/usecases/add_product_to_shopping_list.dart';
import 'package:food_travel/src/domain/usecases/get_products_list_on_current_country.dart';
import 'package:food_travel/src/domain/usecases/get_products_on_list.dart';
import 'package:food_travel/src/domain/usecases/remove_product_from_shopping_list.dart';
import 'package:food_travel/src/domain/usecases/toggle_favorite_status_of_product.dart';

class HomePresenter extends Presenter {
  Function getProductsOnNext;
  Function getProductsOnError;

  Function toggleFavoriteOnComplete;
  Function toggleFavoriteOnError;

  Function getShoppingListOnNext;
  Function getShoppingListOnError;

  Function addProductToShoppingListOnNext;
  Function addProductToShoppingListOnError;

  Function removeProductFromShoppingListOnComplete;
  Function removeProductFromShoppingListOnError;


  GetProductsListOnCurrentCountry _getProductsListOnCurrentCountry;
  ToggleFavoriteStatusOfProduct _toggleFavoriteStatusOfProduct;
  GetProductsOnList _getProductsOnList;
  AddProductToShoppingList _addProductToShoppingList;
  RemoveProductFromShoppingList _removeProductFromShoppingList;

  HomePresenter(productRepository, shoppingRepository)
      : _getProductsListOnCurrentCountry =
            GetProductsListOnCurrentCountry(productRepository),
        _toggleFavoriteStatusOfProduct =
            ToggleFavoriteStatusOfProduct(productRepository),
        _getProductsOnList = GetProductsOnList(shoppingRepository),
        _addProductToShoppingList = AddProductToShoppingList(shoppingRepository),
        _removeProductFromShoppingList = RemoveProductFromShoppingList(shoppingRepository);

  void startSyncingProducts() {
    _getProductsListOnCurrentCountry
        .execute(GetProductsListOnCurrentCountryObserver(this));
  }

  void startSyncingShoppingList() {
    _getProductsOnList.execute(GetProductsOnListObserver(this));
  }

  void toggleFavoriteStatus(Product product) {
    _toggleFavoriteStatusOfProduct.execute(
        ToggleFavoriteStatusOfProductObserver(this), product);
  }

  void getShoppingList() {
    _getProductsOnList.execute(GetProductsOnListObserver(this));
  }

  void addToShoppingList(Product product) {
    _addProductToShoppingList.execute(AddProductToShoppingListObserver(this), product);
  }

  void removeFromShoppingList(Product product) {
    _removeProductFromShoppingList.execute(RemoveProductFromShoppingListObserver(this), product);
  }

  @override
  void dispose() {
    _toggleFavoriteStatusOfProduct.dispose();
    _getProductsListOnCurrentCountry.dispose();
    _getProductsOnList.dispose();
    _addProductToShoppingList.dispose();
    _removeProductFromShoppingList.dispose();
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

class ToggleFavoriteStatusOfProductObserver extends Observer<void> {
  final HomePresenter _presenter;

  ToggleFavoriteStatusOfProductObserver(this._presenter);

  @override
  void onComplete() {
    assert(_presenter.toggleFavoriteOnComplete != null);
    _presenter.toggleFavoriteOnComplete();
  }

  @override
  void onError(e) {
    assert(_presenter.toggleFavoriteOnError != null);
    _presenter.toggleFavoriteOnError(e);
  }

  @override
  void onNext(_) {}
}

class GetProductsOnListObserver extends Observer<List<Product>> {
  final HomePresenter _presenter;

  GetProductsOnListObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    assert(_presenter.getShoppingListOnError != null);
    _presenter.getShoppingListOnError(e);
  }

  @override
  void onNext(List<Product> list) {
    assert(_presenter.getShoppingListOnNext != null);
    _presenter.getShoppingListOnNext(list);
  }
}

class AddProductToShoppingListObserver extends Observer<Product> {
  final HomePresenter _presenter;

  AddProductToShoppingListObserver(this._presenter);

  @override
  void onNext(Product product) {
    assert(_presenter.addProductToShoppingListOnNext != null);
    _presenter.addProductToShoppingListOnNext(product);
  }

  @override
  void onError(e) {
    assert(_presenter.addProductToShoppingListOnError != null);
    _presenter.addProductToShoppingListOnError(e);
  }

  @override
  void onComplete() {}

}


class RemoveProductFromShoppingListObserver extends Observer<void> {
  final HomePresenter _presenter;

  RemoveProductFromShoppingListObserver(this._presenter);

  @override
  void onComplete() {
    assert(_presenter.removeProductFromShoppingListOnComplete != null);
    _presenter.removeProductFromShoppingListOnComplete();
  }

  @override
  void onError(e) {
    assert(_presenter.removeProductFromShoppingListOnError != null);
    _presenter.removeProductFromShoppingListOnError(e);
  }

  @override
  void onNext(_) {}

}
