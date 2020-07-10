import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/review.dart';
import 'package:food_travel/src/domain/repositories/product_repository.dart';
import 'package:food_travel/src/domain/repositories/review_repository.dart';
import 'package:food_travel/src/domain/repositories/shopping_repository.dart';
import 'package:food_travel/src/domain/usecases/add_review_to_a_product.dart';
import 'package:food_travel/src/domain/usecases/get_products_on_list.dart';
import 'package:food_travel/src/domain/usecases/get_all_reviews_of_a_product.dart';

class ProductDetailsPresenter extends Presenter {
  Function getProductsOnListOnNext;
  Function getProductsOnListOnError;

  Function getAllReviewsOfAProductOnNext;
  Function getAllReviewsOfAProductOnError;

  Function addReviewToAProductOnComplete;
  Function addReviewToAProductOnError;

  final GetProductsOnList _getProductsOnList;
  final GetAllReviewsOfAProduct _getAllReviewsOfAProduct;
  final AddReviewToAProduct _addReviewToAProduct;

  ProductDetailsPresenter(
    ProductRepository productRepository,
    ShoppingRepository shoppingRepository,
    ReviewRepository reviewRepository,
  )   : _getProductsOnList = GetProductsOnList(shoppingRepository),
        _addReviewToAProduct = AddReviewToAProduct(reviewRepository),
        _getAllReviewsOfAProduct = GetAllReviewsOfAProduct(reviewRepository);

  void startSyncingShoppingList() {
    _getProductsOnList.execute(GetProductsOnListObserver(this));
  }

  void loadReviews(Product product) {
    _getAllReviewsOfAProduct.execute(
      GetAllReviewsOfAProductObserver(this),
      GetAllReviewsOfAProductParams(product),
    );
  }

  void addReview(Product product, Review review) {
    _addReviewToAProduct.execute(
      AddReviewToAProductObserver(this),
      AddReviewToAProductParams(product, review),
    );
  }

  @override
  void dispose() {
    _getProductsOnList.dispose();
    _getAllReviewsOfAProduct.dispose();
    _addReviewToAProduct.dispose();
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

class GetAllReviewsOfAProductObserver extends Observer<List<Review>> {
  final ProductDetailsPresenter _presenter;

  GetAllReviewsOfAProductObserver(this._presenter);

  @override
  void onComplete() {}

  @override
  void onError(e) {
    assert(_presenter.getAllReviewsOfAProductOnError != null);
    _presenter.getAllReviewsOfAProductOnError(e);
  }

  @override
  void onNext(List<Review> reviews) {
    assert(_presenter.getAllReviewsOfAProductOnNext != null);
    _presenter.getAllReviewsOfAProductOnNext(reviews);
  }
}

class AddReviewToAProductObserver extends Observer<void> {
  final ProductDetailsPresenter _presenter;

  AddReviewToAProductObserver(this._presenter);

  @override
  void onComplete() {
    assert(_presenter.addReviewToAProductOnComplete != null);
    _presenter.addReviewToAProductOnComplete();
  }

  @override
  void onError(e) {
    assert(_presenter.addReviewToAProductOnError != null);
    _presenter.addReviewToAProductOnError(e);
  }

  @override
  void onNext(_) {}
}
