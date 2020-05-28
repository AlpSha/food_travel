import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/data/models/product_model.dart';
import 'package:food_travel/src/data/utilities/product_util.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/review.dart';

class ProductMapper {
  static Product createProductFromModel(ProductModel productModel) {
    final List<Review> reviews = List.from(productModel.reviews.map((reviewModel) => Review(
      comment: reviewModel.comment,
      rate: reviewModel.stars,
    )));
    final avgRate = ProductUtil.getAvgRate(reviews);
    final allergens = productModel.allergens;
    final userHasAllergy = UserHelper.userHasAllergyToAny(allergens);
    final isFavorite = UserHelper.isFavoriteOfUser(productModel.barcode);
    print(productModel.imageUrl);
    return Product(
      productModel.title,
      productModel.price,
      isFavorite,
      productModel.barcode,
      reviews,
      avgRate,
      productModel.ingredients,
      allergens,
      productModel.imageUrl,
      userHasAllergy,
    );
  }
}
