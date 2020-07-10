import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/review.dart';
import 'package:food_travel/src/domain/repositories/review_repository.dart';

class AddReviewToAProduct extends UseCase<void, AddReviewToAProductParams> {
  final ReviewRepository _reviewRepository;

  AddReviewToAProduct(this._reviewRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(AddReviewToAProductParams params) async {
    StreamController<void> controller = StreamController();
    try {
      await _reviewRepository.addReviewToProduct(params.product, params.review);
      logger.finest('AddReviewToAProduct Successful');
      controller.close();
    } catch (e) {
      logger.severe('AddReviewToAProduct Unsuccessful');
      controller.addError(e);
    }
    return controller.stream;
  }

}

class AddReviewToAProductParams {
  Product product;
  Review review;

  AddReviewToAProductParams(this.product, this.review);
}