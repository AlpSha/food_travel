import 'package:food_travel/src/domain/entities/product.dart';

abstract class ShoppingRepository {
  Stream<List<Product>> getShoppingListStream();

  Future<void> addToShoppingList(Product product);

  Future<void> removeFromShoppingList(Product product);

}