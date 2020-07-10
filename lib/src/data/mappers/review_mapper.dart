import 'package:food_travel/src/data/models/review_model.dart';
import 'package:food_travel/src/domain/entities/review.dart';

class ReviewMapper {
  static Review createReviewFromModel(ReviewModel reviewModel) {
    return Review(
      comment: reviewModel.comment,
      rate: reviewModel.stars,
      uid: reviewModel.uid,
    );
  }
}
