import 'package:food_travel/src/data/exceptions/initialize_failed_exception.dart';
import 'package:food_travel/src/data/helpers/product_helper.dart';
import 'package:food_travel/src/data/helpers/shopping_helper.dart';
import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/domain/repositories/initialization_repository.dart';

class InitializationRepositoryData implements InitializationRepository {
  @override
  Future<void> fetchAllData() async {
    try {
      await UserHelper.fetchCurrentUser();
      await ProductHelper.fetchProducts();
      bool result = await ShoppingHelper.fetchShoppingList();
      if (!result) {
        ShoppingHelper.createShoppingListForUser();
      }
      result = await ShoppingHelper.fetchShoppingList();
      if(!result) {
        throw InitializeFailedException('Can\'t create shopping list');
      }
    } catch(e) {
      rethrow;
    }
  }


}