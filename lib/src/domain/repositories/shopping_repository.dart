import 'package:food_travel/src/domain/entities/product.dart';

abstract class ShoppingRepository {
  List<Product> getShoppingList();

  void addToShoppingList(Product product);

  void removeFromShoppingList(Product product);

}