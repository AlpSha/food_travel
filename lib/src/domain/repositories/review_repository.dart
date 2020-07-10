import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviewsOfProduct(Product product);

  Future<void> addReviewToProduct(Product product, Review review);
}