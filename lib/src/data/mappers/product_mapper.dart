import 'package:food_travel/src/data/helpers/user_helper.dart';
import 'package:food_travel/src/data/models/product_model.dart';
import 'package:food_travel/src/data/utilities/product_util.dart';
import 'package:food_travel/src/domain/entities/product.dart';
import 'package:food_travel/src/domain/entities/review.dart';

class ProductMapper {
  static Product createProductFromModel(ProductModel productModel) {
    final reviews = productModel.reviews.map((reviewModel) => Review(
          comment: reviewModel.comment,
          rate: reviewModel.stars,
        ));
    final avgRate = ProductUtil.getAvgRate(reviews);
    final allergens = productModel.allergens;
    final userHasAllergy = UserHelper.userHasAllergyToAny(allergens);
    final isFavorite = UserHelper.isFavoriteOfUser(productModel.barcode);
    return Product(
      title: productModel.title,
      avgRate: avgRate,
      reviews: reviews,
      barcode: productModel.barcode,
      ingredients: productModel.ingredients,
      imageUrl: productModel.imageUrl,
      isFavorite: isFavorite,
      price: productModel.price,
      userHasAllergy: userHasAllergy,
    );
  }
}
