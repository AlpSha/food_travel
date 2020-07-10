import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/repositories/product_repository.dart';

class ToggleFavoriteStatusOfProduct extends UseCase<void, Product> {
  final ProductRepository _repository;

  ToggleFavoriteStatusOfProduct(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(Product product) async {
    StreamController<void> controller = StreamController();
    try {
      if (product.isFavorite) {
        _repository.removeProductFromFavorites(product);
      } else {
        _repository.addProductToFavorites(product);
      }
      controller.close();
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

