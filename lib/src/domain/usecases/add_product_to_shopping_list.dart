import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/repositories/shopping_repository.dart';

class AddProductToShoppingList extends UseCase<void, Product> {
  final ShoppingRepository _repository;

  AddProductToShoppingList(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(Product product) async {
    StreamController<void> controller = StreamController();
    try {
      await _repository.addToShoppingList(product);
      controller.add(product);
      controller.close();
    } catch(e) {
      controller.addError(e);
    }
    return controller.stream;
  }

}