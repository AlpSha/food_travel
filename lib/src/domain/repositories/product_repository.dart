import 'package:food_travel/src/domain/entities/product.dart';

abstract class ProductRepository {
  Stream<List<Product>> getProductsStreamOnCurrentCountry();

  void addProductToFavorites(Product product);

  void removeProductFromFavorites(Product product);

  Product getProductWithBarcode(String barcode);

}