import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/repositories/product_repository.dart';

class GetProductsListOnCurrentCountry extends UseCase<List<Product>, void> {
  final ProductRepository _repository;

  GetProductsListOnCurrentCountry(this._repository);

  StreamSubscription subscription;
  StreamController<List<Product>> controller = StreamController();

  @override
  Future<Stream<List<Product>>> buildUseCaseStream(void params) async {
    void onListChange (products) {
      try {
        controller.add(products);
      } catch(e, st) {
        print(st);
        rethrow;
      }
    }
    try {
      final stream = _repository.getProductsStreamOnCurrentCountry();
      subscription = stream.listen(onListChange);
    } catch (e, st) {
      print(st);
      controller.addError(e);
    }
    return controller.stream;
  }

  @override
  void dispose() {
    subscription.cancel();
    controller.close();
    super.dispose();
  }
}
