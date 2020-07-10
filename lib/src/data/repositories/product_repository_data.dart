import 'package:food_travel/src/data/helpers/product_helper.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/review.dart';
import 'package:food_travel/src/domain/repositories/product_repository.dart';
import 'package:food_travel/src/domain/repositories/review_repository.dart';

class ProductRepositoryData implements ProductRepository, ReviewRepository {
  @override
  void addProductToFavorites(Product product) {
    try {
      ProductHelper.markProductAsFavorite(true, product.id);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Product getProductWithBarcode(String barcode) {
    // TODO: implement getProductWithBarcode
    throw UnimplementedError();
  }

  @override
  Stream<List<Product>> getProductsStreamOnCurrentCountry() {
    return ProductHelper.getProductsListStream();
  }

  @override
  void removeProductFromFavorites(Product product) {
    try {
      ProductHelper.markProductAsFavorite(false, product.id);
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<List<Review>> getReviewsOfProduct(Product product) async {
    try {
      return ProductHelper.getReviewsOfProductOnPreferredLanguages(product);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addReviewToProduct(Product product, Review review) async {
    try {
      await ProductHelper.addReviewToProduct(product, review);
    } catch (e) {
      rethrow;
    }
  }
}