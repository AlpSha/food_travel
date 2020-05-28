import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/home/home_presenter.dart';
import 'package:food_travel/src/domain/entities/product.dart';

class HomeController extends Controller {
  final HomePresenter _presenter;

  var isLoading = true;

  List<Product> products;

  HomeController(productRepository)
      : _presenter = HomePresenter(productRepository);

  @override
  void initListeners() {
    _presenter.getProductsOnNext = (products) {
      this.products = products;
      isLoading = false;
      refreshUI();
    };

    _presenter.getProductsOnError = (e) {
      isLoading = false;
      refreshUI();
      kShowAlert(
        context: getContext(),
        title: 'Ürünler okunamadı',
        content: 'Daha sonra tekrar deneyin',
      );
    };
  }

  void fetchProducts() {
    _presenter.startSyncingProducts();
  }
}
