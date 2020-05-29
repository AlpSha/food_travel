import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/home/home_presenter.dart';
import 'package:food_travel/src/app/pages/product_details/product_details_view.dart';
import 'package:food_travel/src/domain/entities/product.dart';

class HomeController extends Controller {
  final HomePresenter _presenter;
  String appBarTitle;
  int itemCountOnList;

  var isLoading = true;
  var onlyFavorites = false;

  GlobalKey<State<StatefulWidget>> _globalKey;

  List<Product> products;

  HomeController(productRepository, shoppingRepository, this.onlyFavorites)
      : _presenter = HomePresenter(
          productRepository,
          shoppingRepository,
        );

  @override
  void initListeners() {
    _presenter.getProductsOnNext = (List<Product> products) {
      if (onlyFavorites) {
        this.products = products.where((p) => p.isFavorite).toList();
      } else {
        this.products = products;
      }
      isLoading = false;
      refreshUI();
    };

    _presenter.getProductsOnError = (e) {
      kShowAlert(
        context: getContext(),
        title: 'Ürünler okunamadı',
        content: 'Daha sonra tekrar deneyin',
      );
    };

    _presenter.toggleFavoriteOnComplete = () {
      refreshUI();
    };

    _presenter.toggleFavoriteOnError = (e) {};

    _presenter.getShoppingListOnNext = (List<Product> list) {
      itemCountOnList = list.length;
      print('updated shopping list');
      refreshUI();
    };

    _presenter.getShoppingListOnError = (e) {
      kShowAlert(
          context: getContext(),
          title: 'Hata oluştu',
          content: 'Liste bilgisi güncellenemedi');
    };

    _presenter.addProductToShoppingListOnNext = (Product product) {
      final scaffoldState = _globalKey.currentState as ScaffoldState;
      scaffoldState.hideCurrentSnackBar();
      scaffoldState.showSnackBar(
        SnackBar(
          content: Text(
            'Alışveriş listesine eklendi',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: "Geri al",
            onPressed: () => undoAddToList(product),
          ),
        ),
      );
    };

    _presenter.addProductToShoppingListOnError = (e) {
      kShowAlert(
          context: getContext(),
          title: 'Hata oluştu',
          content: 'İsteğinizi gerçekleştiremiyoruz');
    };

    _presenter.removeProductFromShoppingListOnError = (e) {
      kShowAlert(
          context: getContext(),
          title: 'Hata oluştu',
          content: 'İşlemi geri alamadık');
    };

    _presenter.removeProductFromShoppingListOnComplete = () {
      final scaffoldState = _globalKey.currentState as ScaffoldState;
      scaffoldState.hideCurrentSnackBar();
    };
  }

  @override
  void initController(GlobalKey<State<StatefulWidget>> key) {
    super.initController(key);
    _globalKey = key;
    fetchListAndProducts();
    if (onlyFavorites) {
      appBarTitle = 'Favoriler';
    } else {
      appBarTitle = 'Ürünler';
    }
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void fetchListAndProducts() {
    _presenter.startSyncingProducts();
    _presenter.startSyncingShoppingList();
  }

  void openProductDetailsPage(Product product) {
    Navigator.of(getContext()).push(MaterialPageRoute(
      builder: (ctx) => ProductDetailsView(product),
    ));
  }

  void toggleFavoriteProduct(Product product) {
    _presenter.toggleFavoriteStatus(product);
  }

  void addToList(Product product) {
    _presenter.addToShoppingList(product);
  }

  void undoAddToList(Product product) {
    _presenter.removeFromShoppingList(product);
  }

  void openListPage() {
    // TODO
  }
}
