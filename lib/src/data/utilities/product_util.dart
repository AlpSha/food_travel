import 'package:food_travel/src/domain/entities/review.dart';

class ProductUtil {
  static double getAvgRate(List<Review> reviews) {
    var total = 0.0;
    if (reviews == null || reviews.length == 0) {
      return total;
    }
    for (var rev in reviews) {
      total += rev.rate;
    }
    return double.parse((total / reviews.length).toStringAsFixed(1));
  }
}