import 'package:food_travel/src/data/helpers/product_helper.dart';
import 'package:food_travel/src/data/helpers/shopping_helper.dart';
import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/domain/repositories/initialization_repository.dart';

class InitializationRepositoryData implements InitializationRepository {
  @override
  Future<void> fetchAllData() async {
    await UserHelper.fetchCurrentUser();
    await ProductHelper.fetchProducts();
    await ShoppingHelper.fetchShoppingList();
  }


}