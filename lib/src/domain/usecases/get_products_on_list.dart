import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/repositories/shopping_repository.dart';

class GetProductsOnList extends UseCase<List<Product>, void> {
  final ShoppingRepository _repository;

  GetProductsOnList(this._repository);

  StreamSubscription subscription;
  StreamController<List<Product>> controller = StreamController();

  @override
  Future<Stream<List<Product>>> buildUseCaseStream(void params) async {
    void onListChange(products) {
      try {
        print('list changed');
        controller.add(products);
      } catch(e, st) {
        print(st);
        rethrow;
      }
    }
    try {
      final stream = _repository.getShoppingListStream();
      subscription = stream.listen(onListChange);
    } catch(e) {
      controller.addError(e);
    }
    return controller.stream;
  }

  @override
  void dispose() {
    if(subscription != null) {
      subscription.cancel();
    }
    controller.close();
    super.dispose();
  }

}