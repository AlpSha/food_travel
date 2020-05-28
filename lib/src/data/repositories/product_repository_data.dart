import 'package:food_travel/src/data/helpers/product_helper.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/repositories/product_repository.dart';

class ProductRepositoryData implements ProductRepository {
  @override
  void addProductToFavorites(Product product) {
    // TODO: implement addProductToFavorites
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
    // TODO: implement removeProductFromFavorites
  }

}