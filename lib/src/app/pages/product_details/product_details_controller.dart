import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/product_details/product_details_presenter.dart';
import 'package:food_travel/src/domain/entities/product.dart';

class ProductDetailsController extends Controller {
  final Product product;
  final ProductDetailsPresenter _presenter;

  int itemCountOnList;
  bool isLoading = true;

  String imageUrl;

  ProductDetailsController(productRepository, shoppingRepository, this.product)
      : _presenter =
            ProductDetailsPresenter(productRepository, shoppingRepository);

  @override
  void initListeners() {
    _presenter.getProductsOnListOnError = (e) {
      kShowAlert(
          context: getContext(),
          title: 'Hata oluştu',
          content: 'Listenizdeki ürünlere ulaşamadık');
    };

    _presenter.getProductsOnListOnNext = (List<Product> products) {
      itemCountOnList = products.length;
      refreshUI();
    };
  }

  void initController(GlobalKey<State<StatefulWidget>> key) {
    super.initController(key);
    initPage();
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void initPage() async {
    _presenter.startSyncingShoppingList();
    final _firebaseStorage = FirebaseStorage.instance;
    _firebaseStorage.ref().child(product.imageUrl).getDownloadURL().then((url) {
      imageUrl = url;
      print(imageUrl);
      refreshUI();
    });
  }

  void openListPage() {}
}
