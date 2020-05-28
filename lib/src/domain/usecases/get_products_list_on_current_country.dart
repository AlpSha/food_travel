import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/repositories/product_repository.dart';

class GetProductsListOnCurrentCountry extends UseCase<List<Product>, void> {
  final ProductRepository _repository;

  GetProductsListOnCurrentCountry(this._repository);

  Function onListChanged;
  StreamController<List<Product>> controller = StreamController();

  @override
  Future<Stream<List<Product>>> buildUseCaseStream(void params) async {
    try {
      onListChanged = () {};
      _repository.getProductsStreamOnCurrentCountry().listen((event) {
        print(event);
      });
      controller.add([]);
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
