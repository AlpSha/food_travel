import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:food_travel/src/app/constants.dart';
import 'package:food_travel/src/app/pages/product_details/product_details_presenter.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/review.dart';
import 'package:food_travel/src/domain/repositories/product_repository.dart';
import 'package:food_travel/src/domain/repositories/review_repository.dart';
import 'package:food_travel/src/domain/repositories/shopping_repository.dart';

class ProductDetailsController extends Controller {
  final Product product;
  final ProductDetailsPresenter _presenter;

  List<Review> reviews;
  int itemCountOnList;
  bool isLoading = true;
  bool commenting = false;

  double commentRating;
  TextEditingController commentController = TextEditingController();

  String imageUrl;

  ProductDetailsController(
    ProductRepository productRepository,
    ShoppingRepository shoppingRepository,
    ReviewRepository reviewRepository,
    this.product,
  ) : _presenter = ProductDetailsPresenter(
          productRepository,
          shoppingRepository,
          reviewRepository,
        );

  @override
  void initListeners() {
    _presenter.getProductsOnListOnError = (e) {
      kShowAlert(
        context: getContext(),
        title: 'Hata oluştu',
        content: 'Listenizdeki ürünlere ulaşamadık',
      );
    };

    _presenter.getProductsOnListOnNext = (List<Product> products) {
      itemCountOnList = products.length;
      refreshUI();
    };

    _presenter.getAllReviewsOfAProductOnNext = (List<Review> reviews) {
      this.reviews = reviews;
      isLoading = false;
      refreshUI();
    };

    _presenter.getAllReviewsOfAProductOnError = (e) {
      kShowAlert(
        context: getContext(),
        title: 'Hata oluştu',
        content: 'Ürüne ait değerlendirmelere erişemiyoruz',
      );
      reviews = [];
      refreshUI();
    };

    _presenter.addReviewToAProductOnComplete = () {
      final ScaffoldState state = getState();
      state.showSnackBar(
        SnackBar(
          content: Text('Değerlendirmeniz kaydedildi'),
        ),
      );
      _presenter.loadReviews(product);
    };

    _presenter.addReviewToAProductOnError = (e) {
      kShowAlert(
          context: getContext(),
          title: 'Üzgünüm',
          content: 'Değerlendirmeniz kaydedilemedi');
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
    _presenter.loadReviews(product);
    final _firebaseStorage = FirebaseStorage.instance;
    _firebaseStorage.ref().child(product.imageUrl).getDownloadURL().then((url) {
      imageUrl = url;
      refreshUI();
    });
    KeyboardVisibility.onChange.listen((bool visible) {
      commenting = visible;
    });
  }

  void addReview() {
    int rate = commentRating.toInt();
    isLoading = true;
    refreshUI();
    _presenter.addReview(
      product,
      Review(
        rate: rate,
        comment: commentController.text,
      ),
    );
    commentController.clear();
    FocusScope.of(getContext()).unfocus();
  }

  void openListPage() {
    // TODO implement
  }
}
