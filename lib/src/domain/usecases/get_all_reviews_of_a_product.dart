import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/review.dart';
import 'package:food_travel/src/domain/repositories/review_repository.dart';

class GetAllReviewsOfAProduct extends UseCase<List<Review>, GetAllReviewsOfAProductParams> {
  final ReviewRepository _reviewRepository;

  GetAllReviewsOfAProduct(this._reviewRepository);

  @override
  Future<Stream<List<Review>>> buildUseCaseStream(GetAllReviewsOfAProductParams params) async {
    StreamController<List<Review>> controller = StreamController();
    try {
      final reviews = await _reviewRepository.getReviewsOfProduct(params.product);
      logger.finest('GetAllReviewsOfAProduct Successful');
      controller.add(reviews);
      controller.close();
    } catch(e) {
      logger.severe('GetAllReviewsOfAProduct Unsuccessful');
     controller.addError(e);
    }
    return controller.stream;
  }
}

class GetAllReviewsOfAProductParams {
  final Product product;

  GetAllReviewsOfAProductParams(this.product);
}