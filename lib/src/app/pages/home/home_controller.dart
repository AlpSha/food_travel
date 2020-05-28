import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/home/home_presenter.dart';
import 'package:food_travel/src/domain/entities/product.dart';

class HomeController extends Controller {
  final HomePresenter _presenter;
  String appBarTitle;

  var isLoading = true;
  var onlyFavorites = false;

  List<Product> products;

  HomeController(productRepository, this.onlyFavorites)
      : _presenter = HomePresenter(productRepository);

  @override
  void initListeners() {
    _presenter.getProductsOnNext = (List<Product> products) {
      print('fetched products');
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
  }

  @override
  void initController(GlobalKey<State<StatefulWidget>> key) {
    super.initController(key);
    fetchProducts();
    if(onlyFavorites) {
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

  void fetchProducts() {
    _presenter.startSyncingProducts();
  }

  void toggleFavoriteProduct(Product product) {
    // TODO
  }

  void addToList(Product product) {
    // TODO
  }

  void undoAddToList(Product product) {
    // TODO
  }
}
