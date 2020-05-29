import 'package:food_travel/src/data/exceptions/list_update_failed_exception.dart';
import 'package:food_travel/src/data/helpers/shopping_helper.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/repositories/shopping_repository.dart';

class ShoppingRepositoryData extends ShoppingRepository {
  @override
  Stream<List<Product>> getShoppingListStream() {
    return ShoppingHelper.receiveListStream();
  }

  @override
  Future<void> addToShoppingList(Product product) async {
    try {
      final success = await ShoppingHelper.addToShoppingList(product);
      if(success) {
        return;
      } else {
        throw ListUpdateFailedException('Can\t add product');
      }
    } catch(e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromShoppingList(Product product) {
    return ShoppingHelper.removeFromShoppingList(product.barcode);
  }

}